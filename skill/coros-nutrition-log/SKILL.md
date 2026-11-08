---
name: coros-nutrition-log
description: Sets up and keeps a personal nutrition log page in Claude that reads daily burn from COROS. Use when the user asks to set up the nutrition log, sends a photo or description of food to log, logs morning weight, sets a training day type, or asks for today's totals or balance.
---

# COROS nutrition log

The user keeps a food, weight and burn log on a page (an artifact) in Claude. You log what they eat from photos or descriptions; the page shows daily totals against targets, morning weight, burn from COROS and the balance.

Reply in the user's language. Write `desc` and `note` in the user's language too. Store meal kinds, sources and day types as the English keys listed below: the page translates them. If the user asks for the page in another language, follow `TRANSLATING.md` from https://github.com/l3x4/claude-coros-nutrition-log.

## 1. Find the page

1. Look among the user's artifacts for one titled **Nutrition log** (or the name they gave it). If memory holds its slug, use that.
2. If there is none, set it up first by following `SETUP.md` from https://github.com/l3x4/claude-coros-nutrition-log.
3. Find the user's data folder: `data/users/<id>/`, where `<id>` is the user's id in this artifact's database (the database "who am I" call returns it). Every document you write goes there and nowhere else.

## 2. Logging rules

- **What is in the photo is what was eaten**, not leftovers, unless the user says otherwise. Shared dishes: count only the user's share as they describe it.
- **Days run from midnight to midnight** in the user's local time, the same as COROS counts calories. Food eaten after midnight goes to the new date, even before sleep.
- **When no label or weight is visible, search the web** for the product's package size and nutrition before estimating. For dishes, estimate the portion from what is visible and say what you assumed in `note`.
- **Write each meal right away**, one write per message, as soon as the user sends it. Do not batch a day's meals.
- After writing, reply briefly: the breakdown (item → kcal), the entry's kcal and protein, and the day so far against the target. Read the day's documents to total them; other chats may have written entries too.
- Corrections ("I ate the whole lasagna", "remove the salad"): read the document, then update it with its current version.

## 3. Documents

All paths are inside `data/users/<id>/`. Every write to an existing document needs its current version: read it first.

**Meal**, id `meal-YYYYMMDD-HHMM-<short-slug>` (for example `meal-20261108-1530-lunch`):

```json
{
  "kind": "meal",
  "date": "2026-11-08",
  "time": "15:30",
  "title": "lunch",
  "desc": "Plov with beef ~480 g (~920); tomato salad (~90); cola, can (~135)",
  "note": "Estimated from the photo: ~150 g meat, ~20 g oil",
  "kcal": 1150, "p": 50, "f": 41, "c": 144,
  "src": "photo",
  "createdAt": 1794127380000
}
```

- `date`: the local calendar date when it was eaten, `YYYY-MM-DD`. `time`: local `HH:MM`.
- `title`: `breakfast` | `lunch` | `dinner` | `snack` | `workout` (fuel during training).
- `src`: `photo` | `label` (nutrition label seen) | `said` (described, no photo) | `manual`.
- `kcal`, `p`, `f`, `c`: whole numbers (kcal, grams of protein, fat, carbs). Keep `kcal` close to 4p + 9f + 4c unless alcohol or fibre explains the gap.
- `createdAt`: current time in milliseconds.

**Day**, id `day-YYYY-MM-DD`: `{"kind": "day", "date": "2026-11-08", "type": "maint", "weight": 94.6}`
- `type`: `rest` (no training) | `regular` (easy run up to 1.5 h) | `key` (intervals, long run, big climbing, race-like) | `maint` (no deficit: taper, race, recovery, travel) | `carb` (carb loading 1–2 days before a race).
- `weight`: morning weight in kg, one decimal.
- `active` and `activeAt` are written by the page from COROS (active kcal). Leave them alone.

**Settings**, id `settings`:
```json
{
  "lang": "en", "sex": "male", "age": 42, "height": 180,
  "startWeight": 84, "goalWeight": 78, "startDate": "2026-11-16", "goalDate": "2027-04-18",
  "goalNote": "Trail 60K, May 7",
  "targets": {"rest": {"kcal": 1900, "p": 170, "f": 65, "c": 160}}
}
```
All fields are optional. `lang` is the page language, a BCP 47 tag: `en`, or a language with a translation document `i18n-<lang>` (see `TRANSLATING.md`); the user can switch it in Settings. `startDate` and `goalDate` (`YYYY-MM-DD`) set the plan; for a race, the goal date is best 2–3 weeks before it, so the taper and race week are at maintenance. `targets` holds only the day types the user fixed by hand; the others are suggested by the page from the profile. `burnK` (0.3–1.5) fixes the watch factor; without it the page fits the factor from the weight trend.

## 4. How the page computes things (for answering questions)

- Base metabolism: Mifflin–St Jeor from the 7-day average weight (or last weigh-in, or start weight): 10 × kg + 6.25 × cm − 5 × age + 5 (male) or − 161 (female).
- Burn for a day = base metabolism × 1.2 + COROS active kcal × factor. COROS active calories cover only workouts and brisk walking (cadence over 130), so the 1.2 stands for digestion and everyday movement. The factor starts at 0.85 (watches tend to overestimate workouts). Once the last 4 weeks hold at least 10 weigh-ins and 14 days with both meals and COROS data, the factor is refit so that average intake minus the weight trend (7,700 kcal per kg) equals average burn.
- Balance = eaten − burn; negative is a deficit.
- Needed pace: (current weight − goal weight) ÷ days to the goal date, shown per week and as kcal a day (× 7,700 per kg). Current weight is the 7-day average. Above 0.75% of body weight a week the page warns that the pace is aggressive.
- Planned path: a straight line from the start weight on the start date (or the first weigh-in) to the goal weight on the goal date.
- Actual pace: average logged balance over the last 7 finished days, and the scale trend over the last 14 days (needs 4 weigh-ins over at least a week).
- Suggested targets: base × 1.25 scaled by day type (rest ×0.82 but never below base metabolism, easy ×1.04, key ×1.38), no deficit = base metabolism × 1.45; protein 1.8 g/kg (1.7 on no-deficit days), fat 0.7–0.85 g/kg, carbs fill the rest; carb loading = 7 g carbs, 1.4 g protein, 0.55 g fat per kg.

## 5. Privacy

Each person's data sits in their own `data/users/<id>/` folder, which nobody else can read, the page owner included. Do not read or write other folders. The page reads only the daily COROS summary, and only after the user allows it.
