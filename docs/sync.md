# Sync

Habit writes are copied into `sync_outbox`. Sync now, on the profile of a signed-in account, pushes those rows to `SyncRemote` and pulls what the remote has.

The current remote is in memory inside the app process. It is the seam for a later Supabase adapter: replace `syncRemoteProvider`.

When both sides changed the same habit, the later `updatedAt` wins. If the timestamps are equal, the writer id that sorts later wins, so both devices end on the same row.

Guest mode still stores habits. They are queued, and they move with the account at sign-in. Completions use the key `habitId|date`, so the same day from two devices becomes one row. Archive, delete, and reorder are queued too.
