# Credits and asset licenses

Every image, sound, font and data source that ships with Athar, with where it
comes from and its license. Keep this file up to date when an asset changes.

## Artwork (made for this app)

| Asset | Source | License |
| --- | --- | --- |
| Logo (the lantern), app icon, splash images, notification icon, store icon and feature graphic | Drawn in code: `lib/core/widgets/brand/athar_logo.dart`, exported by `tool/render_brand_test.dart` | Original work, owned by the project |
| Background pattern (eight-pointed star lattice) | Drawn in code: `lib/core/widgets/brand/pattern_background.dart` | Original work. The star-and-cross lattice is a traditional geometric motif, not a copyrighted design |
| Tasbih beads, qibla needle, ayah number star, tasbih tab icon | Drawn in code | Original work |
| Other icons | [Material Icons](https://fonts.google.com/icons) bundled with Flutter | Apache License 2.0 |

The app no longer contains any photos or third-party illustrations.

## Sounds

| File | Source | License |
| --- | --- | --- |
| `notification.wav` (short tone, prayer and azkar reminders) | Synthesized for this app (two bell tones) | Original work |
| `azan.mp3`, `azan_short.wav`, `ios/Runner/azan.wav` | Adhan by Sheikh Abdul Basit, from a 2012 adhan collection. The original publisher and license are **unknown** | Kept by the project owner, see below |

### Adhan recording

The project owner decided to keep the current adhan (Sheikh Abdul Basit) for the
first release. Its original publisher and license are not verified. If a rights
holder objects, or for a future release, a free alternative is:

- "The Adhan - Muslim Call to Prayer - Aaqib Azeez.mp3" by Atcovi, Wikimedia Commons,
  [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/):
  https://commons.wikimedia.org/wiki/File:The_Adhan_-_Muslim_Call_to_Prayer_-_Aaqib_Azeez.mp3
  Credit it as *"Adhan by Atcovi, CC BY-SA 4.0, via Wikimedia Commons"* if it is used.

## Fonts

| Font | License |
| --- | --- |
| Amiri | SIL Open Font License 1.1 (`assets/google_fonts/OFL-Amiri.txt`) |
| Poppins | SIL Open Font License 1.1 (`assets/google_fonts/OFL-Poppins.txt`) |

## Data

| Data | Source | Notes |
| --- | --- | --- |
| Quran text, Tafsir Al-Muyassar, Saheeh International translation | [`quran_with_tafsir`](https://pub.dev/packages/quran_with_tafsir) | The Saheeh International translation is published by Al-Muntada Al-Islami. It is widely used in free apps, but it is copyrighted |
| Ayah audio | [everyayah.com](https://everyayah.com) | Streamed, not bundled |
| Recitations and live radio | [mp3quran.net](https://mp3quran.net) | Streamed through their public API |
| Hadith texts and translations | [fawazahmed0/hadith-api](https://github.com/fawazahmed0/hadith-api) | The API is released under the Unlicense. Some English translations come from published books |
| Azkar texts | `assets/data/*.json`, from Hisn al-Muslim | Classical texts |
| Prayer times | [`prayers_times`](https://pub.dev/packages/prayers_times) | Calculated on the device |
