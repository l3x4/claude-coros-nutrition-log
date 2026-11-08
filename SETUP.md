# Setup instructions for Claude

The user gave you this repository and asked you to set up the nutrition log. Follow these steps. Talk to the user in their language; keep it short, they want a working log, not a walkthrough.

## 1. Get the files

Clone the repository (GitHub is reachable from your workspace):

```sh
git clone --depth 1 https://github.com/l3x4/claude-coros-nutrition-log
```

You need these files, byte for byte as they are in the repository:

- `index.html`: the page.
- `skill/coros-nutrition-log/SKILL.md`: how to log food into the page.
- `TRANSLATING.md`: how to translate the page, if the user doesn't speak English.

Never retype, summarise or reformat them. If you can't get the raw files (for example, only a summarising web fetch is available), say so and stop rather than rebuilding the page from memory.

## 2. Publish the page

1. Look among the user's artifacts for one titled **Nutrition log**. If there is one, ask whether to update it to the current `index.html` (republish the file to the same artifact) or leave it. Their entries are kept either way.
2. Otherwise publish `index.html` as a new artifact titled **Nutrition log**, from the cloned file.
3. Then declare its capabilities (a new page is published first, then declared), exactly:

   ```json
   {"db": {}, "user": {}, "mcp": {"servers": [{"server": "COROS", "tools": ["queryDailyHealthData"]}]}}
   ```

   If the user hasn't connected COROS to Claude, declare the same anyway and suggest connecting it: the page works without it and picks up burn once COROS is connected.

## 3. Save the logging rules

Later chats need the rules in `SKILL.md`.

- If you can propose a skill to the user, propose a new skill named `coros-nutrition-log` with the `description` from the frontmatter of `SKILL.md`, and the whole of `SKILL.md` as its content, unchanged. Ask the user to save it from the card.
- If skills aren't available, ask whether to save to memory the page link and this line: "log food into the nutrition log following https://github.com/l3x4/claude-coros-nutrition-log/blob/main/skill/coros-nutrition-log/SKILL.md".

## 4. Hand over

1. Get the user's data folder: `data/users/<id>/`, where `<id>` is the user's id in the artifact's database (the database "who am I" call).
2. Language: the page ships in English. If the user talks to you in another language, translate the page into it by following `TRANSLATING.md` (it saves a translation document and sets `lang` in `settings`). If `settings` already has `lang` and that translation exists, leave it.
3. Ask the user to open the page, allow it to read COROS when it asks, and fill **Profile** in Settings: sex, age, height, start and goal weight, start and goal date. If they'd rather answer in chat, write the `settings` document yourself (format in `SKILL.md`).
4. Tell them how to use it in one or two lines: send a photo of what they eat, say their morning weight, say the day type (rest, easy, key, no deficit, carb loading).

## Updating later

When the user asks to update the nutrition log, clone the repository again, republish `index.html` to their existing artifact (their data stays), and propose the new `SKILL.md` as an update to their `coros-nutrition-log` skill. If they use a translation and the page's `_version` is now higher than the translation's `version`, update the translation as `TRANSLATING.md` describes.
