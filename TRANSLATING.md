# Translating the page (instructions for Claude)

The page ships in English only. To show it in another language, you write a translation document into the user's own storage; the page picks it up and lists the language in Settings. Do this at setup when the user talks to you in a language other than English, or whenever they ask for another language.

## 1. Get the English strings

They are the JSON block `<script type="application/json" id="i18n-en">` in `index.html` (from the cloned repository, or the user's published page). Parse it; don't retype it. `_version` is the version of the English strings.

## 2. Translate

Translate every value except `_version`. Keep every key.

- **Placeholders** like `{n}`, `{kg}`, `{d}` must stay exactly as they are; move them wherever the grammar needs them. A value that drops a placeholder is ignored and the English text is shown instead.
- **Plurals.** A value may be an object of plural forms instead of a string, keyed by the language's plural categories (`zero`, `one`, `two`, `few`, `many`, `other`; see the CLDR plural rules). The page picks the form from `{n}`. `other` is required and must keep every placeholder; the other forms may drop `{n}` ("one day"). Use forms wherever a count appears in a phrase that agrees with it. Label-style phrasing ("days: {n}") avoids the problem and is fine too.
- **Keep it short where the English is short.** Keys ending in `.short`, keys starting with `th` (table headers) and `macroP` / `macroF` / `macroC` (one-letter protein, fat, carbs) sit in narrow columns.
- **Keep symbols**: →, ×, ≈, −, ±, %. Units (`kcal`, `kg`, `g`) take the usual local abbreviation.
- `listSep` and `sep` are separators (`", "` and `" · "`): use the local comma ("، " in Arabic and Persian, "、" in Japanese and Chinese).
- `langLbl` is the word "Language" in the target language.
- Sports and nutrition terms take their usual local names (carb loading, taper, deficit).

## 3. Save

Write one document to `data/users/<id>/i18n-<lang>` (same data folder as the meals):

```json
{
  "kind": "i18n",
  "lang": "he",
  "name": "עברית",
  "locale": "he-IL",
  "dir": "rtl",
  "font": "IBM Plex Sans Hebrew",
  "version": 1,
  "strings": { "title": "…", "goal": "…" }
}
```

- `lang`: BCP 47 language tag. `name`: the language's own name, shown in Settings.
- `locale`: tag for number and date formats, e.g. `de-DE`, `pt-BR`, `ar-EG`. Defaults to `lang`.
- `dir`: `rtl` for Arabic, Hebrew, Persian, Urdu and other right-to-left scripts; otherwise `ltr`. In `rtl`, the page mirrors its layout; charts keep time running left to right.
- `font`: only when IBM Plex doesn't cover the script (it covers Latin, Cyrillic and Greek). A Google Fonts family name: `IBM Plex Sans Arabic`, `IBM Plex Sans Hebrew`, `IBM Plex Sans Thai`, `IBM Plex Sans Devanagari`, `IBM Plex Sans JP`, `IBM Plex Sans KR`, `Noto Sans SC`, `Noto Sans TC`; for other scripts, the matching `Noto Sans …` family. Without it, the phone's system font is used.
- `version`: the `_version` you translated from.

Then set `lang` in the `settings` document to the same tag, so the page opens in it.

## Updating

If `version` is lower than the page's `_version`, or keys are missing, translate the missing or changed keys and update the document. Until then the page shows those strings in English.

## Notes for specific scripts

- In Arabic, numbers may display in Arabic-Indic digits (١٢٣), depending on the locale. Input fields accept those digits and the Arabic decimal mark, so the user can type either.
- Meal kinds, sources and day types are stored as English keys (`breakfast`, `photo`, `key`); only their display is translated. Food descriptions in entries stay in whatever language they were written in.
