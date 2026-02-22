// Disable right click context menu
document.addEventListener('contextmenu', e => e.preventDefault());

// Prevent common DevTools shortcuts
document.addEventListener('keydown', e => {
    // F12 key
    if (e.key === 'F12') {
        e.preventDefault();
        return false;
    }
    // Ctrl + Shift + I/J/C
    if (e.ctrlKey && e.shiftKey && (e.key === 'I' || e.key === 'i' || e.key === 'J' || e.key === 'j' || e.key === 'C' || e.key === 'c')) {
        e.preventDefault();
        return false;
    }
    // Ctrl + U (View Source)
    if (e.ctrlKey && (e.key === 'U' || e.key === 'u')) {
        e.preventDefault();
        return false;
    }
});

// Supabase setup for polling ban status
const supabaseUrl = 'https://grgcynxsmanqfsgkiytu.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdyZ2N5bnhzbWFucWZzZ2tpeXR1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA1NDkxMDQsImV4cCI6MjA4NjEyNTEwNH0.rlTuj58kCkZqb_nIGQhCeBkvFeY04FtFx-SLpwXp-Yg';
const sb = window.supabase.createClient(supabaseUrl, supabaseKey);

async function checkBanStatus() {
    const { data: { session } } = await sb.auth.getSession();
    if (!session) return; // No session, maybe logged out

    const { data: profile } = await sb.from('profiles')
        .select('banned, banned_until')
        .eq('id', session.user.id)
        .single();

    if (profile) {
        let isStillBanned = profile.banned;
        if (profile.banned_until && new Date(profile.banned_until) > new Date()) {
            isStillBanned = true;
        } else if (profile.banned_until && new Date(profile.banned_until) <= new Date()) {
            isStillBanned = false;
        }

        if (!isStillBanned) {
            // Ban is lifted, redirect back
            let base = window.location.pathname.replace('/ban/index.html', '').replace('/ban/', '');
            if (!base.endsWith('/')) base += '/';
            window.location.href = new URL('index.html', window.location.origin + base).href;
        }
    }
}

// Check every 30 seconds
setInterval(checkBanStatus, 30000);
// Check immediately on load
checkBanStatus();
