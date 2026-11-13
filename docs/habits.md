# Habits

The Today screen lists habits that are due on the local calendar day. Daily habits and times-per-week habits show every day from their start date. Weekday habits show only on the chosen days. Archived and deleted habits stay out of the list.

Tapping the circle logs today's target value. Tapping it again clears that day. Both actions can be undone from the snack bar. The check icon scales briefly when it changes.

Drag a row to reorder. The new order is stored as `sortOrder` and is shared with habits that are not due today: only the relative order of the visible rows changes.

Open a habit to see the current streak, the best streak, and a 12-week history grid. From there you can edit, archive, or delete. Delete asks for confirmation. On iOS that confirmation is an action sheet.

Add and edit use the same form: name, icon, color, frequency, and an optional reminder time. The time picker is the Cupertino wheel on iOS and the Material clock on Android. Reminder scheduling itself is a later milestone; the chosen minute-of-day is saved now.

The name cannot be empty. A weekday habit needs at least one day. Times per week is a number from 1 to 7.
