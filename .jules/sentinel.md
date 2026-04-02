## 2024-11-20 - DOM XSS in Note and Profile Views
**Vulnerability:** Several dynamically rendered UI components (like `note-list`, `note-detail`, `similar-notes`, and `user-profile`) injected user-controlled fields (`note.title`, `note.category`, `note.type`, `note.subject`, `note.url`, and `profile.username`) into `innerHTML` strings without proper sanitization. This allows for Cross-Site Scripting (XSS).
**Learning:** Even though an `escapeHtml()` function exists in the codebase, it is easy to forget to use it when constructing template literals for DOM insertion, especially for nested or less common models like Notes.
**Prevention:** Always wrap variables representing user input with `escapeHtml()` when interpolating them into HTML strings that will be passed to `innerHTML`.
