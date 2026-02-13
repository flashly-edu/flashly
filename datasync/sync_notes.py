import time
import sys
import argparse
from playwright.sync_api import sync_playwright

# Configuration - Update these if needed
DEFAULT_FLASHLY_URL = "http://localhost:5500" # Update to your local server URL
# Mapping from Grail terms to Flashly select values
CATEGORY_MAP = {
    "GCE 'O' Levels": "O Level",
    "GCE 'A' Levels": "A Level",
    "IB": "IB",
    "GCE 'N' Levels": "N Level",
    "IP": "IP",
    "Sec 1-2 (Non IP)": "Sec 1-2",
    "Secondary 1-2": "Sec 1-2"
}

TYPE_MAP = {
    "Exam Papers": "Exam Papers",
    "Notes/Practices": "Notes/Practices",
    "TYS Answers": "TYS Answers",
    "MYEs/CAs/Other Tests": "MYEs/CAs/Other Tests",
    "User Mock Papers": "User Mock Papers"
}

def scrape_grail(page, target_url):
    print(f"[*] Navigating to Grail: {target_url}")
    page.goto(target_url)
    
    # Wait for content to load
    page.wait_for_selector('a[href^="https://document.grail.moe/"]')
    
    # Find all card containers
    # Based on the snippet, they are divs with backdrop-blur-sm and p-4
    cards = page.locator('div.backdrop-blur-sm.p-4').all()
    print(f"[*] Found {len(cards)} documents on page.")
    
    notes = []
    for card in cards:
        try:
            doc_link = card.locator('a[href^="https://document.grail.moe/"]').first
            title = doc_link.inner_text().strip()
            pdf_url = doc_link.get_attribute('href')
            
            # Extract metadata from the labels
            # We look for the <p> that contains the category text, then find its container's second <p>
            category_raw = card.locator('div:has(p:text-is("Category")) >> p.text-sm').inner_text().strip()
            subject_raw = card.locator('div:has(p:text-is("Subject")) >> p.text-sm').inner_text().strip()
            type_raw = card.locator('div:has(p:text-is("Type")) >> p.text-sm').inner_text().strip()
            
            # Map values to Flashly equivalents
            category = CATEGORY_MAP.get(category_raw, category_raw)
            # Subject names seem consistent between Grail and Flashly usually, but we strip just in case
            subject = subject_raw 
            doc_type = TYPE_MAP.get(type_raw, type_raw)
            
            notes.append({
                'title': title,
                'url': pdf_url,
                'category': category,
                'subject': subject,
                'type': doc_type
            })
            print(f"  [+] Identified: {title} ({subject})")
        except Exception as e:
            print(f"  [!] Error parsing card: {e}")
            
    return notes

def add_to_flashly(page, flashly_url, notes):
    print(f"[*] Navigating to Flashly: {flashly_url}")
    page.goto(flashly_url)
    
    print("[!] Please ENSURE YOU ARE LOGGED IN as kohzanden@gmail.com in the browser window.")
    print("[!] Script will wait for the 'Add Note' button to appear...")
    
    # Switch to Notes tab first
    page.locator('#nav-notes').click()
    
    # Wait for the button (admin restricted)
    add_btn = page.locator('#add-note-btn')
    add_btn.wait_for(state="visible", timeout=60000) # Wait up to 1 minute for user to log in if needed
    
    for note in notes:
        print(f"[*] Syncing: {note['title']}...")
        
        # Open Modal
        add_btn.click()
        page.wait_for_selector('#add-note-modal:not(.hidden)')
        
        # Fill Form
        page.fill('#note-title', note['title'])
        page.select_option('#note-category', label=note['category'])
        page.select_option('#note-subject', label=note['subject'])
        page.select_option('#note-type', label=note['type'])
        page.fill('#note-url', note['url'])
        
        # Submit
        page.click('#add-note-form button[type="submit"]')
        
        # Wait for toast and modal to close
        page.wait_for_selector('#add-note-modal.hidden')
        print(f"  [v] Successfully added {note['title']}")
        
        # Small delay to prevent spamming
        time.sleep(1)

def main():
    parser = argparse.ArgumentParser(description="Sync notes from Grail.moe to Flashly")
    parser.add_argument("url", help="The grail.moe library URL to scrape")
    parser.add_argument("--flashly", default=DEFAULT_FLASHLY_URL, help="Your local Flashly app URL")
    
    args = parser.parse_args()
    
    if "grail.moe/library" not in args.url:
        print("[!] Error: Please provide a valid grail.moe library URL.")
        sys.exit(1)

    with sync_playwright() as p:
        # Launch browser in headed mode so user can log in if needed
        browser = p.chromium.launch(headless=False)
        context = browser.new_context()
        page = context.new_page()
        
        try:
            # 1. Scrape Grail
            notes = scrape_grail(page, args.url)
            
            if not notes:
                print("[!] No notes found to sync.")
                return
            
            # 2. Add to Flashly
            add_to_flashly(page, args.flashly, notes)
            
            print("\n[*] All notes synced successfully!")
            
        except Exception as e:
            print(f"\n[!] An error occurred: {e}")
        finally:
            print("[*] Keeping browser open for 5 seconds...")
            time.sleep(5)
            browser.close()

if __name__ == "__main__":
    main()
