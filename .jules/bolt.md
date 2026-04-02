## 2024-05-18 - Replacing Date Instantiation with String Comparison in Loops
**Learning:** Instantiating `new Date(string)` inside tight loops processing tens of thousands of items (like flashcards) is a major performance bottleneck due to parsing overhead and memory allocation. However, since dates are often stored in ISO 8601 format, they are lexicographically sortable.
**Action:** Replace `new Date(card.due_at) <= now` with `card.due_at <= now.toISOString()` and optimize `.sort()` similarly using string comparisons when processing large arrays of database records.
