// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(version, build) => "Version ${version} (${build})";

  static String m1(count) =>
      "${Intl.plural(count, one: '1 ayah', other: '${count} ayahs')}";

  static String m2(surah, ayah) => "${surah} - Ayah ${ayah}";

  static String m3(surah, ayah) => "${surah} • Ayah ${ayah}";

  static String m4(count) => "Completed khatmas: ${count}";

  static String m5(city) => "${city} (default)";

  static String m6(number) => "Hadith ${number}";

  static String m7(first, last) => "Hadiths ${first} - ${last}";

  static String m8(days) => "A full khatma about every ${days} days";

  static String m9(position) => "Last read: ${position}";

  static String m10(count) => "${count} min";

  static String m11(name, time) => "Next: ${name} - ${time}";

  static String m12(query) => "No ayahs contain “${query}”";

  static String m13(time) => "Notification time: ${time}";

  static String m14(page, juz) => "Page ${page} • Juz ${juz}";

  static String m15(page) => "Page ${page}";

  static String m16(count) =>
      "${Intl.plural(count, one: '1 page', other: '${count} pages')}";

  static String m17(name) => "${name}";

  static String m18(read, total) => "Read ${read} of ${total} pages";

  static String m19(name) => "Reciter: ${name}";

  static String m20(count) => "${count} narrations";

  static String m21(query) => "Search the ayahs for “${query}”";

  static String m22(query) => "Results for “${query}”";

  static String m23(url) =>
      "Islami: the Holy Quran, prayer times, azkar and hadiths\n${url}";

  static String m24(count) => "Day streak: ${count}";

  static String m25(count) => " • ${count}-day streak";

  static String m26(count) => "${count} surahs";

  static String m27(name) => "Surahs recited by ${name}";

  static String m28(city) => "Times for ${city} - tap to use your location";

  static String m29(today, goal) => "Today ${today} of ${goal} pages";

  static String m30(today, goal) => "Today’s wird ${today}/${goal} pages";

  static String m31(count) => "Total: ${count}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "Enter_text_here":
            MessageLookupByLibrary.simpleMessage("Enter text here"),
        "Suras_List": MessageLookupByLibrary.simpleMessage("Suras List"),
        "Verse": MessageLookupByLibrary.simpleMessage("Verses"),
        "aboutApp": MessageLookupByLibrary.simpleMessage("About"),
        "addBookmark": MessageLookupByLibrary.simpleMessage("Add bookmark"),
        "addToFavorites":
            MessageLookupByLibrary.simpleMessage("Add to favorites"),
        "addedToFavorites":
            MessageLookupByLibrary.simpleMessage("Added to favorites"),
        "adhanFull": MessageLookupByLibrary.simpleMessage("Full adhan"),
        "adhanPerPrayer":
            MessageLookupByLibrary.simpleMessage("Adhan for each prayer"),
        "adhanShort": MessageLookupByLibrary.simpleMessage(
            "Short adhan (first 30 seconds)"),
        "adhanSilent":
            MessageLookupByLibrary.simpleMessage("Silent (notification only)"),
        "adhanSound": MessageLookupByLibrary.simpleMessage("Adhan sound"),
        "adhanTone": MessageLookupByLibrary.simpleMessage("Short tone"),
        "adhanTurnedOff":
            MessageLookupByLibrary.simpleMessage("Adhan turned off"),
        "adhanTurnedOn":
            MessageLookupByLibrary.simpleMessage("Adhan turned on"),
        "allowLocation": MessageLookupByLibrary.simpleMessage("Allow location"),
        "appSubtitle": MessageLookupByLibrary.simpleMessage("Islami app"),
        "appVersion": m0,
        "asr": MessageLookupByLibrary.simpleMessage("Asr"),
        "asrHanafi": MessageLookupByLibrary.simpleMessage("Asr: Hanafi"),
        "asrShafi": MessageLookupByLibrary.simpleMessage("Asr: Shafi’i"),
        "audioLibrary": MessageLookupByLibrary.simpleMessage("Audio library"),
        "ayahCopied": MessageLookupByLibrary.simpleMessage("Ayah copied"),
        "ayahCount": m1,
        "ayahRef": m2,
        "ayahRefDot": m3,
        "azkar": MessageLookupByLibrary.simpleMessage("Azkar"),
        "azkarAfterPrayer":
            MessageLookupByLibrary.simpleMessage("After prayer azkar"),
        "azkarEvening": MessageLookupByLibrary.simpleMessage("Evening azkar"),
        "azkarFood": MessageLookupByLibrary.simpleMessage("Food azkar"),
        "azkarMorning": MessageLookupByLibrary.simpleMessage("Morning azkar"),
        "azkarMosque": MessageLookupByLibrary.simpleMessage("Mosque azkar"),
        "azkarPrayer": MessageLookupByLibrary.simpleMessage("Prayer azkar"),
        "azkarSleep": MessageLookupByLibrary.simpleMessage("Sleep azkar"),
        "azkarWakingUp":
            MessageLookupByLibrary.simpleMessage("Waking up azkar"),
        "back": MessageLookupByLibrary.simpleMessage("Back"),
        "bookmarkAdded": MessageLookupByLibrary.simpleMessage("Bookmark added"),
        "bookmarkRemoved":
            MessageLookupByLibrary.simpleMessage("Bookmark removed"),
        "bookmarks": MessageLookupByLibrary.simpleMessage("Bookmarks"),
        "bookmarksEmpty": MessageLookupByLibrary.simpleMessage(
            "Long-press any ayah and choose \"Add bookmark\""),
        "calculationMethod":
            MessageLookupByLibrary.simpleMessage("Calculation method"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "changeReciter": MessageLookupByLibrary.simpleMessage("Change reciter"),
        "chooseRecitation":
            MessageLookupByLibrary.simpleMessage("Choose a recitation"),
        "chooseReciter":
            MessageLookupByLibrary.simpleMessage("Choose a reciter"),
        "chooseReciterSubtitle":
            MessageLookupByLibrary.simpleMessage("Pick your favorite reciter"),
        "chooseRewaya":
            MessageLookupByLibrary.simpleMessage("Choose a narration"),
        "clear": MessageLookupByLibrary.simpleMessage("Clear"),
        "close": MessageLookupByLibrary.simpleMessage("Close"),
        "completedKhatmas": m4,
        "continueReading": MessageLookupByLibrary.simpleMessage("Continue"),
        "copy": MessageLookupByLibrary.simpleMessage("Copy"),
        "copyAyah": MessageLookupByLibrary.simpleMessage("Copy ayah"),
        "dailyWird": MessageLookupByLibrary.simpleMessage("Daily wird"),
        "defaultAyahReciter":
            MessageLookupByLibrary.simpleMessage("Default ayah reciter"),
        "defaultCity": m5,
        "defaultCityName": MessageLookupByLibrary.simpleMessage("Menofia"),
        "deleteBookmark":
            MessageLookupByLibrary.simpleMessage("Remove bookmark"),
        "dhuhr": MessageLookupByLibrary.simpleMessage("Dhuhr"),
        "disableAdhan": MessageLookupByLibrary.simpleMessage("Turn off adhan"),
        "editGoal": MessageLookupByLibrary.simpleMessage("Edit goal"),
        "enableAdhan": MessageLookupByLibrary.simpleMessage("Turn on adhan"),
        "enableLocationForTimes": MessageLookupByLibrary.simpleMessage(
            "Turn on location and allow access to update the prayer times"),
        "enableLocationHint": MessageLookupByLibrary.simpleMessage(
            "Turn on location and allow the app to access it"),
        "enableNotifications":
            MessageLookupByLibrary.simpleMessage("Enable notifications"),
        "fajr": MessageLookupByLibrary.simpleMessage("Fajr"),
        "favoriteHadiths":
            MessageLookupByLibrary.simpleMessage("Favorite hadiths"),
        "favorites": MessageLookupByLibrary.simpleMessage("Favorites"),
        "favoritesEmpty": MessageLookupByLibrary.simpleMessage(
            "Tap ♡ on any hadith to add it here"),
        "finish": MessageLookupByLibrary.simpleMessage("Finish"),
        "fullJuz":
            MessageLookupByLibrary.simpleMessage("A full juz (20 pages)"),
        "hadithCopied": MessageLookupByLibrary.simpleMessage("Hadith copied"),
        "hadithLoadError": MessageLookupByLibrary.simpleMessage(
            "Couldn’t load the hadiths, check your internet connection"),
        "hadithNumber": m6,
        "hadithRange": m7,
        "hadiths": MessageLookupByLibrary.simpleMessage("Hadiths"),
        "hideTafsir": MessageLookupByLibrary.simpleMessage("Hide tafsir"),
        "history": MessageLookupByLibrary.simpleMessage("History"),
        "isha": MessageLookupByLibrary.simpleMessage("Isha"),
        "khatma": MessageLookupByLibrary.simpleMessage("Khatma"),
        "khatmaCompletedMessage": MessageLookupByLibrary.simpleMessage(
            "Congratulations! You completed a full reading of the Quran"),
        "khatmaEveryDays": m8,
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "lastRead": MessageLookupByLibrary.simpleMessage("Last read"),
        "lastReadAt": m9,
        "listen": MessageLookupByLibrary.simpleMessage("Listen"),
        "listenToAyah":
            MessageLookupByLibrary.simpleMessage("Listen to the ayah"),
        "liveBroadcast": MessageLookupByLibrary.simpleMessage("Live"),
        "location": MessageLookupByLibrary.simpleMessage("Location"),
        "locationDeniedForever": MessageLookupByLibrary.simpleMessage(
            "Location permission is denied, enable it from the app settings"),
        "locationFailed": MessageLookupByLibrary.simpleMessage(
            "Couldn’t find your location, please try again"),
        "locationNeededForQibla": MessageLookupByLibrary.simpleMessage(
            "We need your location to find the Qibla direction"),
        "maghrib": MessageLookupByLibrary.simpleMessage("Maghrib"),
        "meccan": MessageLookupByLibrary.simpleMessage("Meccan"),
        "medinan": MessageLookupByLibrary.simpleMessage("Medinan"),
        "minutesCount": m10,
        "myLocation":
            MessageLookupByLibrary.simpleMessage("My current location (GPS)"),
        "navHome": MessageLookupByLibrary.simpleMessage("Home"),
        "navQibla": MessageLookupByLibrary.simpleMessage("Qibla"),
        "navQuran": MessageLookupByLibrary.simpleMessage("Quran"),
        "navRadio": MessageLookupByLibrary.simpleMessage("Radio"),
        "navTasbih": MessageLookupByLibrary.simpleMessage("Tasbih"),
        "next": MessageLookupByLibrary.simpleMessage("Next"),
        "nextPrayer": m11,
        "noAyahsFor": m12,
        "noCompassSensor": MessageLookupByLibrary.simpleMessage(
            "Your device doesn’t have a compass sensor"),
        "noInternetHint": MessageLookupByLibrary.simpleMessage(
            "Check your internet connection"),
        "noReciterFound": MessageLookupByLibrary.simpleMessage(
            "No reciter matches this name"),
        "noSurahFound":
            MessageLookupByLibrary.simpleMessage("No surah matches this name"),
        "notificationTime": m13,
        "off": MessageLookupByLibrary.simpleMessage("Off"),
        "onboarding1_body": MessageLookupByLibrary.simpleMessage(
            "We Are Very Excited To Have You In Our Community"),
        "onboarding1_title":
            MessageLookupByLibrary.simpleMessage("Welcome To Islami"),
        "onboarding2_body": MessageLookupByLibrary.simpleMessage(
            "Read, and your Lord is the Most Generous"),
        "onboarding2_title":
            MessageLookupByLibrary.simpleMessage("Reading the Quran"),
        "onboarding3_body": MessageLookupByLibrary.simpleMessage(
            "Praise the name of your Lord, the Most High"),
        "onboarding3_title": MessageLookupByLibrary.simpleMessage("Tasbeeh"),
        "onboarding4_body": MessageLookupByLibrary.simpleMessage(
            "You can listen to the Holy Quran Radio through the application for free and easily"),
        "onboarding4_title":
            MessageLookupByLibrary.simpleMessage("Holy Quran Radio"),
        "openSettings": MessageLookupByLibrary.simpleMessage("Open settings"),
        "pageAndJuz": m14,
        "pageNumber": m15,
        "pagesCount": m16,
        "pause": MessageLookupByLibrary.simpleMessage("Pause"),
        "play": MessageLookupByLibrary.simpleMessage("Play"),
        "playAll": MessageLookupByLibrary.simpleMessage("Play all"),
        "playFromHere": MessageLookupByLibrary.simpleMessage(
            "Play from here to the end of the surah"),
        "prayerCalculationMethod": MessageLookupByLibrary.simpleMessage(
            "Prayer times calculation method"),
        "prayerName": m17,
        "prayerTimes": MessageLookupByLibrary.simpleMessage("Prayer times"),
        "previous": MessageLookupByLibrary.simpleMessage("Previous"),
        "qiblaDirection":
            MessageLookupByLibrary.simpleMessage("Qibla direction"),
        "quranFontSize":
            MessageLookupByLibrary.simpleMessage("Quran font size"),
        "radioAbdulbari":
            MessageLookupByLibrary.simpleMessage("Abdulbari Mohammed Radio"),
        "radioAndRecitations":
            MessageLookupByLibrary.simpleMessage("Radio & Recitations"),
        "radioBasfar":
            MessageLookupByLibrary.simpleMessage("Abdullah Basfar Radio"),
        "radioKhayat":
            MessageLookupByLibrary.simpleMessage("Abdullah Khayat Radio"),
        "rateApp": MessageLookupByLibrary.simpleMessage("Rate the app"),
        "readPagesOf": m18,
        "reading": MessageLookupByLibrary.simpleMessage("Reading"),
        "readingTracker":
            MessageLookupByLibrary.simpleMessage("Reading tracker"),
        "recitations": MessageLookupByLibrary.simpleMessage("Recitations"),
        "reciterLabel": m19,
        "recitersLoadError": MessageLookupByLibrary.simpleMessage(
            "Couldn’t load the reciters, check your internet connection"),
        "reminderBeforePrayer":
            MessageLookupByLibrary.simpleMessage("Reminder before prayer"),
        "removeBookmark":
            MessageLookupByLibrary.simpleMessage("Remove bookmark"),
        "removeFromFavorites":
            MessageLookupByLibrary.simpleMessage("Remove from favorites"),
        "removedFromFavorites":
            MessageLookupByLibrary.simpleMessage("Removed from favorites"),
        "resetKhatmaConfirm": MessageLookupByLibrary.simpleMessage(
            "Your current khatma progress will be reset. Are you sure?"),
        "retry": MessageLookupByLibrary.simpleMessage("Retry"),
        "rewayatCount": m20,
        "rotateDeviceForQibla": MessageLookupByLibrary.simpleMessage(
            "Rotate your device to find the Qibla"),
        "searchAyahsFor": m21,
        "searchReciter":
            MessageLookupByLibrary.simpleMessage("Search for a reciter"),
        "searchResultsFor": m22,
        "searchSurahOrAyah": MessageLookupByLibrary.simpleMessage(
            "Search for a surah or an ayah"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "shareApp": MessageLookupByLibrary.simpleMessage("Share the app"),
        "shareAppText": m23,
        "showEnglishTranslation":
            MessageLookupByLibrary.simpleMessage("Show English translation"),
        "skip": MessageLookupByLibrary.simpleMessage("Skip"),
        "start": MessageLookupByLibrary.simpleMessage("Start"),
        "startKhatmaHint": MessageLookupByLibrary.simpleMessage(
            "Start your khatma from Surah Al-Fatihah"),
        "startNewKhatma":
            MessageLookupByLibrary.simpleMessage("Start a new khatma"),
        "startOver": MessageLookupByLibrary.simpleMessage("Start over"),
        "storeOpenFailed":
            MessageLookupByLibrary.simpleMessage("Couldn’t open the store"),
        "streakDays": m24,
        "streakSuffix": m25,
        "sunrise": MessageLookupByLibrary.simpleMessage("Sunrise"),
        "surahCount": m26,
        "surahPrefix": MessageLookupByLibrary.simpleMessage("Surah"),
        "surahsByReciter": m27,
        "tafsirMuyassar": MessageLookupByLibrary.simpleMessage(
            "Tafsir (Al-Muyassar, Arabic)"),
        "tafsirUnavailable": MessageLookupByLibrary.simpleMessage(
            "Tafsir is not available for this ayah"),
        "timesForCity": m28,
        "timesForMyLocation": MessageLookupByLibrary.simpleMessage(
            "Times for your location - tap to refresh"),
        "timesUpdatedForLocation": MessageLookupByLibrary.simpleMessage(
            "Prayer times updated for your location"),
        "todayPagesOf": m29,
        "todayWird": m30,
        "total": m31,
        "totalLabel": MessageLookupByLibrary.simpleMessage("Total:"),
        "turnOnGpsForQibla": MessageLookupByLibrary.simpleMessage(
            "Turn on location (GPS) to find the Qibla"),
        "useMyLocation": MessageLookupByLibrary.simpleMessage(
            "Use my current location (GPS)")
      };
}
