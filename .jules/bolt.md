## 2026-04-02 - Optimize daily review count queries
**Learning:** Identical and conditional network queries to the database were discovered.
**Action:** Use cached sizes of local sets to replace network calls where possible and conditionally invoke queries.
