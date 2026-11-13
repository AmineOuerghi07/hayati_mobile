# Local data

Drift is the source of truth on the device. The UI talks to repositories, not to tables.

Every row has `id` (uuid created on the device), `createdAt`, `updatedAt`, and a nullable `deletedAt`. Deletes are soft so a later sync can send them.

| Table | What it stores |
| --- | --- |
| habits | Name, icon, color, boolean or quantity, frequency, reminder minutes after local midnight, start date, archive time, sort order |
| habit_completions | One value per habit per local date. Unique on habit and date. Clearing a day sets `deletedAt` and a later check revives that row |
| app_settings | Locale, color theme, appearance, and week start |

`sync_outbox` is not in this schema yet. It arrives with sync.

## Themes

Appearance is system, light, or dark. The color theme is a separate palette, and each palette has both a light scheme and a dark scheme:

| Id | Character |
| --- | --- |
| hayati | Brand green |
| oasis | Teal |
| dawn | Amber |
| dusk | Indigo |
| blossom | Rose |
| sea | Blue |
| ink | Slate |
| contrast | Brand green at the highest Material contrast |

Filled buttons use a darker shade of the palette so white text stays readable. The font is IBM Plex Sans Arabic.
