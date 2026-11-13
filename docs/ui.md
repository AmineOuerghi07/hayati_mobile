# UI

Hayati is meant to feel quiet: warm surfaces, soft cards, and short motion. The same tokens drive every screen.

## Tokens

`HayatiTokens` lives on the theme. Spacing is 4, 8, 12, 16, 24, and 32. Chips use a 12 radius, cards 20, and sheets 28. Motion is 150, 250, or 400 milliseconds on `Curves.easeOutCubic`. A check-off uses a slight overshoot. Every duration becomes zero when the system asks to reduce motion.

Each palette still has a light and a dark scheme. The scaffold is a warm neutral tinted with the palette seed, and cards sit a step lighter so the list can breathe.

## Pieces

- `SoftCard` is the surface for habits, settings groups, and stats.
- `ProgressRing` paints a stroke inset from the edge. The percent is scaled to fit the hole, including at 100% and at large text. A finished ring is a full stroke with a small check, not a filled disc.
- `EmptyState`, `StaggeredItem`, `AnimatedCount`, and `CelebrationOverlay` cover the empty day, the first appearance of a list, streak numbers, and the moment every habit for today is done.
- Destructive confirms use an action sheet on iOS and a dialog elsewhere. Undo stays on a snackbar.

## Visual language

The look borrows from apps known for their visuals. From Streaks it takes checks that fill when tapped. From Fabulous it takes a streak flame. From Finch it takes a small companion that reacts to progress, and from Apple Fitness the nested rings. All of it is painted in Flutter, with no animation package.

- `AuroraBackground` drifts soft color glows behind the Today hero, the stats rings, the habit header, and onboarding.
- `GrowingPlant` grows leaves as today's habits are finished and blooms when the day is complete. On onboarding it grows a little with each starter habit picked.
- `AnimatedCheckButton` fills, draws its tick, and throws a small burst. Quantity habits get a liquid fill with a slow wave across the card instead.
- `StreakFlame` flickers while a streak is alive and goes still and outlined when it is not.
- `ConcentricRings` sweeps today, the week, and the month in together on Stats. The habit header uses a single white ring.
- `CelebrationOverlay` throws confetti with gravity and spin, and a check badge springs in.
- `SkeletonList` shimmers while data loads. The selected tab icon springs in, and tab changes fade and lift.
- `HabitBadge` puts each habit icon on a gradient tile made from its color.

Today's hero also shows a quote that changes once a day. All looping animations stop when the system asks to reduce motion.

## Flow

The first launch is a three-step introduction: welcome, starter habits, and an optional reminder. Skip is always available. After that, Today opens with a greeting, a week strip, and the habits that are due. Past days in the strip, and the previous week, can be filled in. Stats keeps today, the week, and the month as rings, then a seven-day bar chart and the heatmap.

Quantity habits show a minus, the count, and a plus. A note and a mood share the existing completion note, prefixed as `mood:3|text` so older notes still read back.

Check-ins earn XP: 10 for each one and 50 for each badge unlocked. Each level costs 100 XP more than the one before. There are 12 badges: streaks, perfect days and weeks, check-in totals, notes, and early or late check-ins. The Profile card shows the level and a strip of recent badges, and the Achievements page shows them all. Below the list, Today offers a focus timer, which logs minutes or completes a habit, and a 4-4-6 breathing exercise.

The sign-in pages share one `AuthScaffold`: an aurora backdrop, an animated emblem, and a form card. Password fields show a strength meter, codes use separate boxes with a countdown, and the reset flow moves through three steps.

## Responsive layout

The breakpoints follow Material 3. Below 600 wide there is a bottom navigation bar. From 600 there is a navigation rail, which extends with labels at 1200. Reading columns are capped and centered so the whole width still scrolls: lists at 720, the editor at 640, the habit page at 760, sign-in at 480, and badges at 960.

- Today scrolls its hero and week strip with the list on phones, so it works in landscape. From 900 wide the hero sits in a side pane next to the list.
- From 900 wide, Stats splits into an overview column and a heatmap and habits column. The summary tiles go into one row of four once the column is wide enough.
- Onboarding scrolls when it is short. On a landscape phone the plant moves beside the steps, and the template grid adds columns as it widens.
- The focus and breathing dials size themselves from both the width and the height.
