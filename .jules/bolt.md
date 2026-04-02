## 2024-05-24 - Remove Redundant Network Query for Daily Review Limit
**Learning:** The global daily review limit in flashcard study sessions requires counting unique card reviews for the current date. The application was performing two separate identical database queries in the dashboard load: one inside `getGlobalCompletedTodayCount()` and another when generating the `studiedTodayIds` Set.
**Action:** Compute the completed review count locally from the size of the existing `studiedTodayIds` Set, which eliminates the redundant network query and improves dashboard load times.
