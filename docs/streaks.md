# Streaks

Streaks are calculated in `StreakCalculator`. The function has no Flutter imports. The same cases live in `test/fixtures/streak_cases.json` so the web app can reuse them later.

A completion belongs to a local calendar date (`yyyy-MM-dd`), never a UTC timestamp.

## Rules

- **Daily.** The current streak is the run of completed days ending today. If today is not done yet, count the run ending yesterday. A day that has ended without a completion breaks the streak.
- **Weekdays.** Only the chosen weekdays count. Other days are skipped and never break the streak. Monday is 1 and Sunday is 7.
- **Times per week.** The streak counts weeks. The week starts on the day saved in settings. A week counts when completions reach the target. The current week does not break the streak while it is still in progress. Days before the habit's start date are ignored, including when the habit is created mid-week.
- **Quantity.** A day counts when the logged value reaches the target.
- **Archive.** History stays. The streak is scored as of the archive day, so later empty days do not wipe it.
- **Best.** The longest run in the whole history, not only the current one.

Removing a completion is the same as that day never being logged.
