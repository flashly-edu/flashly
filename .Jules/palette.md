## 2024-05-18 - Missing ARIA Labels on Icon-Only Buttons
**Learning:** Icon-only buttons (like `.clear-search-btn`, `.dropdown-btn`, `.modal-close`) often lack accessible names when implemented purely with SVG icons. This makes them invisible or confusing for screen reader users.
**Action:** Always ensure that any button containing only an icon has a descriptive `aria-label` attribute (e.g., `aria-label="Close modal"`).
