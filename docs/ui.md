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

## Flow

The first launch is a three-step introduction: welcome, starter habits, and an optional reminder. Skip is always available. After that, Today opens with a greeting, a week strip, and the habits that are due. Past days in the strip, and the previous week, can be filled in. Stats keeps today, the week, and the month as rings, then a seven-day bar chart and the heatmap.

Quantity habits show a minus, the count, and a plus. A note and a mood share the existing completion note, prefixed as `mood:3|text` so older notes still read back.
