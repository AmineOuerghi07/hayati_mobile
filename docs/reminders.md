# Reminders

A reminder is a minute-of-day stored on the habit. Nothing is scheduled until a habit has one, so the app does not ask for notification permission on first launch.

When the list of active habits changes, or the app returns to the foreground, the coordinator builds a plan and replaces the OS notifications. Archived and deleted habits drop out of that plan, which cancels their alarms. Editing the time replaces the same notification id, derived from the habit id.

The alarm is daily and inexact. Android 14 restricts exact alarms, and a habit reminder does not need to fire at the exact millisecond. After a reboot, the plugin's boot receiver restores the schedule.

Tapping a reminder opens Today. The payload is the word `today`.
