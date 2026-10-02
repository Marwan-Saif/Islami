// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Finish`
  String get finish {
    return Intl.message(
      'Finish',
      name: 'finish',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Welcome To Islami`
  String get onboarding1_title {
    return Intl.message(
      'Welcome To Islami',
      name: 'onboarding1_title',
      desc: '',
      args: [],
    );
  }

  /// `We Are Very Excited To Have You In Our Community`
  String get onboarding1_body {
    return Intl.message(
      'We Are Very Excited To Have You In Our Community',
      name: 'onboarding1_body',
      desc: '',
      args: [],
    );
  }

  /// `Reading the Quran`
  String get onboarding2_title {
    return Intl.message(
      'Reading the Quran',
      name: 'onboarding2_title',
      desc: '',
      args: [],
    );
  }

  /// `Read, and your Lord is the Most Generous`
  String get onboarding2_body {
    return Intl.message(
      'Read, and your Lord is the Most Generous',
      name: 'onboarding2_body',
      desc: '',
      args: [],
    );
  }

  /// `Tasbeeh`
  String get onboarding3_title {
    return Intl.message(
      'Tasbeeh',
      name: 'onboarding3_title',
      desc: '',
      args: [],
    );
  }

  /// `Praise the name of your Lord, the Most High`
  String get onboarding3_body {
    return Intl.message(
      'Praise the name of your Lord, the Most High',
      name: 'onboarding3_body',
      desc: '',
      args: [],
    );
  }

  /// `Holy Quran Radio`
  String get onboarding4_title {
    return Intl.message(
      'Holy Quran Radio',
      name: 'onboarding4_title',
      desc: '',
      args: [],
    );
  }

  /// `You can listen to the Holy Quran Radio through the application for free and easily`
  String get onboarding4_body {
    return Intl.message(
      'You can listen to the Holy Quran Radio through the application for free and easily',
      name: 'onboarding4_body',
      desc: '',
      args: [],
    );
  }

  /// `Suras List`
  String get Suras_List {
    return Intl.message(
      'Suras List',
      name: 'Suras_List',
      desc: '',
      args: [],
    );
  }

  /// `Enter text here`
  String get Enter_text_here {
    return Intl.message(
      'Enter text here',
      name: 'Enter_text_here',
      desc: '',
      args: [],
    );
  }

  /// `Verses`
  String get Verse {
    return Intl.message(
      'Verses',
      name: 'Verse',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message(
      'Retry',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message(
      'Copy',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message(
      'Start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `Open settings`
  String get openSettings {
    return Intl.message(
      'Open settings',
      name: 'openSettings',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Listen`
  String get listen {
    return Intl.message(
      'Listen',
      name: 'listen',
      desc: '',
      args: [],
    );
  }

  /// `Play`
  String get play {
    return Intl.message(
      'Play',
      name: 'play',
      desc: '',
      args: [],
    );
  }

  /// `Pause`
  String get pause {
    return Intl.message(
      'Pause',
      name: 'pause',
      desc: '',
      args: [],
    );
  }

  /// `Previous`
  String get previous {
    return Intl.message(
      'Previous',
      name: 'previous',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favorites {
    return Intl.message(
      'Favorites',
      name: 'favorites',
      desc: '',
      args: [],
    );
  }

  /// `Check your internet connection`
  String get noInternetHint {
    return Intl.message(
      'Check your internet connection',
      name: 'noInternetHint',
      desc: '',
      args: [],
    );
  }

  /// `Radio`
  String get navRadio {
    return Intl.message(
      'Radio',
      name: 'navRadio',
      desc: '',
      args: [],
    );
  }

  /// `Quran`
  String get navQuran {
    return Intl.message(
      'Quran',
      name: 'navQuran',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get navHome {
    return Intl.message(
      'Home',
      name: 'navHome',
      desc: '',
      args: [],
    );
  }

  /// `Tasbih`
  String get navTasbih {
    return Intl.message(
      'Tasbih',
      name: 'navTasbih',
      desc: '',
      args: [],
    );
  }

  /// `Qibla`
  String get navQibla {
    return Intl.message(
      'Qibla',
      name: 'navQibla',
      desc: '',
      args: [],
    );
  }

  /// `Surah`
  String get surahPrefix {
    return Intl.message(
      'Surah',
      name: 'surahPrefix',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, one{1 ayah} other{{count} ayahs}}`
  String ayahCount(num count) {
    return Intl.plural(
      count,
      one: '1 ayah',
      other: '$count ayahs',
      name: 'ayahCount',
      desc: '',
      args: [count],
    );
  }

  /// `{surah} - Ayah {ayah}`
  String ayahRef(Object surah, Object ayah) {
    return Intl.message(
      '$surah - Ayah $ayah',
      name: 'ayahRef',
      desc: '',
      args: [surah, ayah],
    );
  }

  /// `{surah} • Ayah {ayah}`
  String ayahRefDot(Object surah, Object ayah) {
    return Intl.message(
      '$surah • Ayah $ayah',
      name: 'ayahRefDot',
      desc: '',
      args: [surah, ayah],
    );
  }

  /// `Page {page}`
  String pageNumber(Object page) {
    return Intl.message(
      'Page $page',
      name: 'pageNumber',
      desc: '',
      args: [page],
    );
  }

  /// `Page {page} • Juz {juz}`
  String pageAndJuz(Object page, Object juz) {
    return Intl.message(
      'Page $page • Juz $juz',
      name: 'pageAndJuz',
      desc: '',
      args: [page, juz],
    );
  }

  /// `Meccan`
  String get meccan {
    return Intl.message(
      'Meccan',
      name: 'meccan',
      desc: '',
      args: [],
    );
  }

  /// `Medinan`
  String get medinan {
    return Intl.message(
      'Medinan',
      name: 'medinan',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations! You completed a full reading of the Quran`
  String get khatmaCompletedMessage {
    return Intl.message(
      'Congratulations! You completed a full reading of the Quran',
      name: 'khatmaCompletedMessage',
      desc: '',
      args: [],
    );
  }

  /// `No surah matches this name`
  String get noSurahFound {
    return Intl.message(
      'No surah matches this name',
      name: 'noSurahFound',
      desc: '',
      args: [],
    );
  }

  /// `Search for a surah or an ayah`
  String get searchSurahOrAyah {
    return Intl.message(
      'Search for a surah or an ayah',
      name: 'searchSurahOrAyah',
      desc: '',
      args: [],
    );
  }

  /// `Search the ayahs for “{query}”`
  String searchAyahsFor(Object query) {
    return Intl.message(
      'Search the ayahs for “$query”',
      name: 'searchAyahsFor',
      desc: '',
      args: [query],
    );
  }

  /// `Results for “{query}”`
  String searchResultsFor(Object query) {
    return Intl.message(
      'Results for “$query”',
      name: 'searchResultsFor',
      desc: '',
      args: [query],
    );
  }

  /// `No ayahs contain “{query}”`
  String noAyahsFor(Object query) {
    return Intl.message(
      'No ayahs contain “$query”',
      name: 'noAyahsFor',
      desc: '',
      args: [query],
    );
  }

  /// `Reading tracker`
  String get readingTracker {
    return Intl.message(
      'Reading tracker',
      name: 'readingTracker',
      desc: '',
      args: [],
    );
  }

  /// `Daily wird`
  String get dailyWird {
    return Intl.message(
      'Daily wird',
      name: 'dailyWird',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, one{1 page} other{{count} pages}}`
  String pagesCount(num count) {
    return Intl.plural(
      count,
      one: '1 page',
      other: '$count pages',
      name: 'pagesCount',
      desc: '',
      args: [count],
    );
  }

  /// `A full juz (20 pages)`
  String get fullJuz {
    return Intl.message(
      'A full juz (20 pages)',
      name: 'fullJuz',
      desc: '',
      args: [],
    );
  }

  /// `A full khatma about every {days} days`
  String khatmaEveryDays(Object days) {
    return Intl.message(
      'A full khatma about every $days days',
      name: 'khatmaEveryDays',
      desc: '',
      args: [days],
    );
  }

  /// `Start a new khatma`
  String get startNewKhatma {
    return Intl.message(
      'Start a new khatma',
      name: 'startNewKhatma',
      desc: '',
      args: [],
    );
  }

  /// `Your current khatma progress will be reset. Are you sure?`
  String get resetKhatmaConfirm {
    return Intl.message(
      'Your current khatma progress will be reset. Are you sure?',
      name: 'resetKhatmaConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Start over`
  String get startOver {
    return Intl.message(
      'Start over',
      name: 'startOver',
      desc: '',
      args: [],
    );
  }

  /// `Khatma`
  String get khatma {
    return Intl.message(
      'Khatma',
      name: 'khatma',
      desc: '',
      args: [],
    );
  }

  /// `Read {read} of {total} pages`
  String readPagesOf(Object read, Object total) {
    return Intl.message(
      'Read $read of $total pages',
      name: 'readPagesOf',
      desc: '',
      args: [read, total],
    );
  }

  /// `Completed khatmas: {count}`
  String completedKhatmas(Object count) {
    return Intl.message(
      'Completed khatmas: $count',
      name: 'completedKhatmas',
      desc: '',
      args: [count],
    );
  }

  /// `Edit goal`
  String get editGoal {
    return Intl.message(
      'Edit goal',
      name: 'editGoal',
      desc: '',
      args: [],
    );
  }

  /// `Today {today} of {goal} pages`
  String todayPagesOf(Object today, Object goal) {
    return Intl.message(
      'Today $today of $goal pages',
      name: 'todayPagesOf',
      desc: '',
      args: [today, goal],
    );
  }

  /// `Day streak: {count}`
  String streakDays(Object count) {
    return Intl.message(
      'Day streak: $count',
      name: 'streakDays',
      desc: '',
      args: [count],
    );
  }

  /// `Last read`
  String get lastRead {
    return Intl.message(
      'Last read',
      name: 'lastRead',
      desc: '',
      args: [],
    );
  }

  /// `Last read: {position}`
  String lastReadAt(Object position) {
    return Intl.message(
      'Last read: $position',
      name: 'lastReadAt',
      desc: '',
      args: [position],
    );
  }

  /// `Bookmarks`
  String get bookmarks {
    return Intl.message(
      'Bookmarks',
      name: 'bookmarks',
      desc: '',
      args: [],
    );
  }

  /// `Long-press any ayah and choose "Add bookmark"`
  String get bookmarksEmpty {
    return Intl.message(
      'Long-press any ayah and choose "Add bookmark"',
      name: 'bookmarksEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Remove bookmark`
  String get deleteBookmark {
    return Intl.message(
      'Remove bookmark',
      name: 'deleteBookmark',
      desc: '',
      args: [],
    );
  }

  /// `Today’s wird {today}/{goal} pages`
  String todayWird(Object today, Object goal) {
    return Intl.message(
      'Today’s wird $today/$goal pages',
      name: 'todayWird',
      desc: '',
      args: [today, goal],
    );
  }

  /// ` • {count}-day streak`
  String streakSuffix(Object count) {
    return Intl.message(
      ' • $count-day streak',
      name: 'streakSuffix',
      desc: '',
      args: [count],
    );
  }

  /// `Start your khatma from Surah Al-Fatihah`
  String get startKhatmaHint {
    return Intl.message(
      'Start your khatma from Surah Al-Fatihah',
      name: 'startKhatmaHint',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueReading {
    return Intl.message(
      'Continue',
      name: 'continueReading',
      desc: '',
      args: [],
    );
  }

  /// `Bookmark added`
  String get bookmarkAdded {
    return Intl.message(
      'Bookmark added',
      name: 'bookmarkAdded',
      desc: '',
      args: [],
    );
  }

  /// `Bookmark removed`
  String get bookmarkRemoved {
    return Intl.message(
      'Bookmark removed',
      name: 'bookmarkRemoved',
      desc: '',
      args: [],
    );
  }

  /// `Ayah copied`
  String get ayahCopied {
    return Intl.message(
      'Ayah copied',
      name: 'ayahCopied',
      desc: '',
      args: [],
    );
  }

  /// `Reciter: {name}`
  String reciterLabel(Object name) {
    return Intl.message(
      'Reciter: $name',
      name: 'reciterLabel',
      desc: '',
      args: [name],
    );
  }

  /// `Listen to the ayah`
  String get listenToAyah {
    return Intl.message(
      'Listen to the ayah',
      name: 'listenToAyah',
      desc: '',
      args: [],
    );
  }

  /// `Play from here to the end of the surah`
  String get playFromHere {
    return Intl.message(
      'Play from here to the end of the surah',
      name: 'playFromHere',
      desc: '',
      args: [],
    );
  }

  /// `Hide tafsir`
  String get hideTafsir {
    return Intl.message(
      'Hide tafsir',
      name: 'hideTafsir',
      desc: '',
      args: [],
    );
  }

  /// `Tafsir (Al-Muyassar, Arabic)`
  String get tafsirMuyassar {
    return Intl.message(
      'Tafsir (Al-Muyassar, Arabic)',
      name: 'tafsirMuyassar',
      desc: '',
      args: [],
    );
  }

  /// `Tafsir is not available for this ayah`
  String get tafsirUnavailable {
    return Intl.message(
      'Tafsir is not available for this ayah',
      name: 'tafsirUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Add bookmark`
  String get addBookmark {
    return Intl.message(
      'Add bookmark',
      name: 'addBookmark',
      desc: '',
      args: [],
    );
  }

  /// `Remove bookmark`
  String get removeBookmark {
    return Intl.message(
      'Remove bookmark',
      name: 'removeBookmark',
      desc: '',
      args: [],
    );
  }

  /// `Copy ayah`
  String get copyAyah {
    return Intl.message(
      'Copy ayah',
      name: 'copyAyah',
      desc: '',
      args: [],
    );
  }

  /// `Hadiths`
  String get hadiths {
    return Intl.message(
      'Hadiths',
      name: 'hadiths',
      desc: '',
      args: [],
    );
  }

  /// `Favorite hadiths`
  String get favoriteHadiths {
    return Intl.message(
      'Favorite hadiths',
      name: 'favoriteHadiths',
      desc: '',
      args: [],
    );
  }

  /// `Couldn’t load the hadiths, check your internet connection`
  String get hadithLoadError {
    return Intl.message(
      'Couldn’t load the hadiths, check your internet connection',
      name: 'hadithLoadError',
      desc: '',
      args: [],
    );
  }

  /// `Tap ♡ on any hadith to add it here`
  String get favoritesEmpty {
    return Intl.message(
      'Tap ♡ on any hadith to add it here',
      name: 'favoritesEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Hadith {number}`
  String hadithNumber(Object number) {
    return Intl.message(
      'Hadith $number',
      name: 'hadithNumber',
      desc: '',
      args: [number],
    );
  }

  /// `Hadiths {first} - {last}`
  String hadithRange(Object first, Object last) {
    return Intl.message(
      'Hadiths $first - $last',
      name: 'hadithRange',
      desc: '',
      args: [first, last],
    );
  }

  /// `Added to favorites`
  String get addedToFavorites {
    return Intl.message(
      'Added to favorites',
      name: 'addedToFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Removed from favorites`
  String get removedFromFavorites {
    return Intl.message(
      'Removed from favorites',
      name: 'removedFromFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Hadith copied`
  String get hadithCopied {
    return Intl.message(
      'Hadith copied',
      name: 'hadithCopied',
      desc: '',
      args: [],
    );
  }

  /// `Add to favorites`
  String get addToFavorites {
    return Intl.message(
      'Add to favorites',
      name: 'addToFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Remove from favorites`
  String get removeFromFavorites {
    return Intl.message(
      'Remove from favorites',
      name: 'removeFromFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Qibla direction`
  String get qiblaDirection {
    return Intl.message(
      'Qibla direction',
      name: 'qiblaDirection',
      desc: '',
      args: [],
    );
  }

  /// `Couldn’t find your location, please try again`
  String get locationFailed {
    return Intl.message(
      'Couldn’t find your location, please try again',
      name: 'locationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Rotate your device to find the Qibla`
  String get rotateDeviceForQibla {
    return Intl.message(
      'Rotate your device to find the Qibla',
      name: 'rotateDeviceForQibla',
      desc: '',
      args: [],
    );
  }

  /// `Your device doesn’t have a compass sensor`
  String get noCompassSensor {
    return Intl.message(
      'Your device doesn’t have a compass sensor',
      name: 'noCompassSensor',
      desc: '',
      args: [],
    );
  }

  /// `Turn on location (GPS) to find the Qibla`
  String get turnOnGpsForQibla {
    return Intl.message(
      'Turn on location (GPS) to find the Qibla',
      name: 'turnOnGpsForQibla',
      desc: '',
      args: [],
    );
  }

  /// `Location permission is denied, enable it from the app settings`
  String get locationDeniedForever {
    return Intl.message(
      'Location permission is denied, enable it from the app settings',
      name: 'locationDeniedForever',
      desc: '',
      args: [],
    );
  }

  /// `We need your location to find the Qibla direction`
  String get locationNeededForQibla {
    return Intl.message(
      'We need your location to find the Qibla direction',
      name: 'locationNeededForQibla',
      desc: '',
      args: [],
    );
  }

  /// `Allow location`
  String get allowLocation {
    return Intl.message(
      'Allow location',
      name: 'allowLocation',
      desc: '',
      args: [],
    );
  }

  /// `Radio & Recitations`
  String get radioAndRecitations {
    return Intl.message(
      'Radio & Recitations',
      name: 'radioAndRecitations',
      desc: '',
      args: [],
    );
  }

  /// `Audio library`
  String get audioLibrary {
    return Intl.message(
      'Audio library',
      name: 'audioLibrary',
      desc: '',
      args: [],
    );
  }

  /// `Choose a reciter`
  String get chooseReciter {
    return Intl.message(
      'Choose a reciter',
      name: 'chooseReciter',
      desc: '',
      args: [],
    );
  }

  /// `Pick your favorite reciter`
  String get chooseReciterSubtitle {
    return Intl.message(
      'Pick your favorite reciter',
      name: 'chooseReciterSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Choose a recitation`
  String get chooseRecitation {
    return Intl.message(
      'Choose a recitation',
      name: 'chooseRecitation',
      desc: '',
      args: [],
    );
  }

  /// `Surahs recited by {name}`
  String surahsByReciter(Object name) {
    return Intl.message(
      'Surahs recited by $name',
      name: 'surahsByReciter',
      desc: '',
      args: [name],
    );
  }

  /// `Abdulbari Mohammed Radio`
  String get radioAbdulbari {
    return Intl.message(
      'Abdulbari Mohammed Radio',
      name: 'radioAbdulbari',
      desc: '',
      args: [],
    );
  }

  /// `Abdullah Basfar Radio`
  String get radioBasfar {
    return Intl.message(
      'Abdullah Basfar Radio',
      name: 'radioBasfar',
      desc: '',
      args: [],
    );
  }

  /// `Abdullah Khayat Radio`
  String get radioKhayat {
    return Intl.message(
      'Abdullah Khayat Radio',
      name: 'radioKhayat',
      desc: '',
      args: [],
    );
  }

  /// `Live`
  String get liveBroadcast {
    return Intl.message(
      'Live',
      name: 'liveBroadcast',
      desc: '',
      args: [],
    );
  }

  /// `Search for a reciter`
  String get searchReciter {
    return Intl.message(
      'Search for a reciter',
      name: 'searchReciter',
      desc: '',
      args: [],
    );
  }

  /// `No reciter matches this name`
  String get noReciterFound {
    return Intl.message(
      'No reciter matches this name',
      name: 'noReciterFound',
      desc: '',
      args: [],
    );
  }

  /// `{count} narrations`
  String rewayatCount(Object count) {
    return Intl.message(
      '$count narrations',
      name: 'rewayatCount',
      desc: '',
      args: [count],
    );
  }

  /// `Choose a narration`
  String get chooseRewaya {
    return Intl.message(
      'Choose a narration',
      name: 'chooseRewaya',
      desc: '',
      args: [],
    );
  }

  /// `{count} surahs`
  String surahCount(Object count) {
    return Intl.message(
      '$count surahs',
      name: 'surahCount',
      desc: '',
      args: [count],
    );
  }

  /// `Recitations`
  String get recitations {
    return Intl.message(
      'Recitations',
      name: 'recitations',
      desc: '',
      args: [],
    );
  }

  /// `Play all`
  String get playAll {
    return Intl.message(
      'Play all',
      name: 'playAll',
      desc: '',
      args: [],
    );
  }

  /// `Change reciter`
  String get changeReciter {
    return Intl.message(
      'Change reciter',
      name: 'changeReciter',
      desc: '',
      args: [],
    );
  }

  /// `Couldn’t load the reciters, check your internet connection`
  String get recitersLoadError {
    return Intl.message(
      'Couldn’t load the reciters, check your internet connection',
      name: 'recitersLoadError',
      desc: '',
      args: [],
    );
  }

  /// `Islami app`
  String get appSubtitle {
    return Intl.message(
      'Islami app',
      name: 'appSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Total: {count}`
  String total(Object count) {
    return Intl.message(
      'Total: $count',
      name: 'total',
      desc: '',
      args: [count],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Azkar`
  String get azkar {
    return Intl.message(
      'Azkar',
      name: 'azkar',
      desc: '',
      args: [],
    );
  }

  /// `Morning azkar`
  String get azkarMorning {
    return Intl.message(
      'Morning azkar',
      name: 'azkarMorning',
      desc: '',
      args: [],
    );
  }

  /// `Evening azkar`
  String get azkarEvening {
    return Intl.message(
      'Evening azkar',
      name: 'azkarEvening',
      desc: '',
      args: [],
    );
  }

  /// `Prayer azkar`
  String get azkarPrayer {
    return Intl.message(
      'Prayer azkar',
      name: 'azkarPrayer',
      desc: '',
      args: [],
    );
  }

  /// `Mosque azkar`
  String get azkarMosque {
    return Intl.message(
      'Mosque azkar',
      name: 'azkarMosque',
      desc: '',
      args: [],
    );
  }

  /// `After prayer azkar`
  String get azkarAfterPrayer {
    return Intl.message(
      'After prayer azkar',
      name: 'azkarAfterPrayer',
      desc: '',
      args: [],
    );
  }

  /// `Waking up azkar`
  String get azkarWakingUp {
    return Intl.message(
      'Waking up azkar',
      name: 'azkarWakingUp',
      desc: '',
      args: [],
    );
  }

  /// `Food azkar`
  String get azkarFood {
    return Intl.message(
      'Food azkar',
      name: 'azkarFood',
      desc: '',
      args: [],
    );
  }

  /// `Sleep azkar`
  String get azkarSleep {
    return Intl.message(
      'Sleep azkar',
      name: 'azkarSleep',
      desc: '',
      args: [],
    );
  }

  /// `Enable notifications`
  String get enableNotifications {
    return Intl.message(
      'Enable notifications',
      name: 'enableNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Notification time: {time}`
  String notificationTime(Object time) {
    return Intl.message(
      'Notification time: $time',
      name: 'notificationTime',
      desc: '',
      args: [time],
    );
  }

  /// `Prayer times`
  String get prayerTimes {
    return Intl.message(
      'Prayer times',
      name: 'prayerTimes',
      desc: '',
      args: [],
    );
  }

  /// `Fajr`
  String get fajr {
    return Intl.message(
      'Fajr',
      name: 'fajr',
      desc: '',
      args: [],
    );
  }

  /// `Sunrise`
  String get sunrise {
    return Intl.message(
      'Sunrise',
      name: 'sunrise',
      desc: '',
      args: [],
    );
  }

  /// `Dhuhr`
  String get dhuhr {
    return Intl.message(
      'Dhuhr',
      name: 'dhuhr',
      desc: '',
      args: [],
    );
  }

  /// `Asr`
  String get asr {
    return Intl.message(
      'Asr',
      name: 'asr',
      desc: '',
      args: [],
    );
  }

  /// `Maghrib`
  String get maghrib {
    return Intl.message(
      'Maghrib',
      name: 'maghrib',
      desc: '',
      args: [],
    );
  }

  /// `Isha`
  String get isha {
    return Intl.message(
      'Isha',
      name: 'isha',
      desc: '',
      args: [],
    );
  }

  /// `Prayer times updated for your location`
  String get timesUpdatedForLocation {
    return Intl.message(
      'Prayer times updated for your location',
      name: 'timesUpdatedForLocation',
      desc: '',
      args: [],
    );
  }

  /// `Turn on location and allow access to update the prayer times`
  String get enableLocationForTimes {
    return Intl.message(
      'Turn on location and allow access to update the prayer times',
      name: 'enableLocationForTimes',
      desc: '',
      args: [],
    );
  }

  /// `Adhan turned on`
  String get adhanTurnedOn {
    return Intl.message(
      'Adhan turned on',
      name: 'adhanTurnedOn',
      desc: '',
      args: [],
    );
  }

  /// `Adhan turned off`
  String get adhanTurnedOff {
    return Intl.message(
      'Adhan turned off',
      name: 'adhanTurnedOff',
      desc: '',
      args: [],
    );
  }

  /// `Turn on adhan`
  String get enableAdhan {
    return Intl.message(
      'Turn on adhan',
      name: 'enableAdhan',
      desc: '',
      args: [],
    );
  }

  /// `Turn off adhan`
  String get disableAdhan {
    return Intl.message(
      'Turn off adhan',
      name: 'disableAdhan',
      desc: '',
      args: [],
    );
  }

  /// `Times for your location - tap to refresh`
  String get timesForMyLocation {
    return Intl.message(
      'Times for your location - tap to refresh',
      name: 'timesForMyLocation',
      desc: '',
      args: [],
    );
  }

  /// `Times for {city} - tap to use your location`
  String timesForCity(Object city) {
    return Intl.message(
      'Times for $city - tap to use your location',
      name: 'timesForCity',
      desc: '',
      args: [city],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Adhan sound`
  String get adhanSound {
    return Intl.message(
      'Adhan sound',
      name: 'adhanSound',
      desc: '',
      args: [],
    );
  }

  /// `Full adhan`
  String get adhanFull {
    return Intl.message(
      'Full adhan',
      name: 'adhanFull',
      desc: '',
      args: [],
    );
  }

  /// `Short adhan (first 30 seconds)`
  String get adhanShort {
    return Intl.message(
      'Short adhan (first 30 seconds)',
      name: 'adhanShort',
      desc: '',
      args: [],
    );
  }

  /// `Short tone`
  String get adhanTone {
    return Intl.message(
      'Short tone',
      name: 'adhanTone',
      desc: '',
      args: [],
    );
  }

  /// `Silent (notification only)`
  String get adhanSilent {
    return Intl.message(
      'Silent (notification only)',
      name: 'adhanSilent',
      desc: '',
      args: [],
    );
  }

  /// `Calculation method`
  String get calculationMethod {
    return Intl.message(
      'Calculation method',
      name: 'calculationMethod',
      desc: '',
      args: [],
    );
  }

  /// `Prayer times calculation method`
  String get prayerCalculationMethod {
    return Intl.message(
      'Prayer times calculation method',
      name: 'prayerCalculationMethod',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Use my current location (GPS)`
  String get useMyLocation {
    return Intl.message(
      'Use my current location (GPS)',
      name: 'useMyLocation',
      desc: '',
      args: [],
    );
  }

  /// `My current location (GPS)`
  String get myLocation {
    return Intl.message(
      'My current location (GPS)',
      name: 'myLocation',
      desc: '',
      args: [],
    );
  }

  /// `{city} (default)`
  String defaultCity(Object city) {
    return Intl.message(
      '$city (default)',
      name: 'defaultCity',
      desc: '',
      args: [city],
    );
  }

  /// `Turn on location and allow the app to access it`
  String get enableLocationHint {
    return Intl.message(
      'Turn on location and allow the app to access it',
      name: 'enableLocationHint',
      desc: '',
      args: [],
    );
  }

  /// `Asr: Shafi’i`
  String get asrShafi {
    return Intl.message(
      'Asr: Shafi’i',
      name: 'asrShafi',
      desc: '',
      args: [],
    );
  }

  /// `Asr: Hanafi`
  String get asrHanafi {
    return Intl.message(
      'Asr: Hanafi',
      name: 'asrHanafi',
      desc: '',
      args: [],
    );
  }

  /// `Adhan for each prayer`
  String get adhanPerPrayer {
    return Intl.message(
      'Adhan for each prayer',
      name: 'adhanPerPrayer',
      desc: '',
      args: [],
    );
  }

  /// `{name}`
  String prayerName(Object name) {
    return Intl.message(
      '$name',
      name: 'prayerName',
      desc: '',
      args: [name],
    );
  }

  /// `Reminder before prayer`
  String get reminderBeforePrayer {
    return Intl.message(
      'Reminder before prayer',
      name: 'reminderBeforePrayer',
      desc: '',
      args: [],
    );
  }

  /// `Off`
  String get off {
    return Intl.message(
      'Off',
      name: 'off',
      desc: '',
      args: [],
    );
  }

  /// `{count} min`
  String minutesCount(Object count) {
    return Intl.message(
      '$count min',
      name: 'minutesCount',
      desc: '',
      args: [count],
    );
  }

  /// `Reading`
  String get reading {
    return Intl.message(
      'Reading',
      name: 'reading',
      desc: '',
      args: [],
    );
  }

  /// `Quran font size`
  String get quranFontSize {
    return Intl.message(
      'Quran font size',
      name: 'quranFontSize',
      desc: '',
      args: [],
    );
  }

  /// `Default ayah reciter`
  String get defaultAyahReciter {
    return Intl.message(
      'Default ayah reciter',
      name: 'defaultAyahReciter',
      desc: '',
      args: [],
    );
  }

  /// `Show English translation`
  String get showEnglishTranslation {
    return Intl.message(
      'Show English translation',
      name: 'showEnglishTranslation',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get aboutApp {
    return Intl.message(
      'About',
      name: 'aboutApp',
      desc: '',
      args: [],
    );
  }

  /// `Share the app`
  String get shareApp {
    return Intl.message(
      'Share the app',
      name: 'shareApp',
      desc: '',
      args: [],
    );
  }

  /// `Islami: the Holy Quran, prayer times, azkar and hadiths\n{url}`
  String shareAppText(Object url) {
    return Intl.message(
      'Islami: the Holy Quran, prayer times, azkar and hadiths\n$url',
      name: 'shareAppText',
      desc: '',
      args: [url],
    );
  }

  /// `Rate the app`
  String get rateApp {
    return Intl.message(
      'Rate the app',
      name: 'rateApp',
      desc: '',
      args: [],
    );
  }

  /// `Couldn’t open the store`
  String get storeOpenFailed {
    return Intl.message(
      'Couldn’t open the store',
      name: 'storeOpenFailed',
      desc: '',
      args: [],
    );
  }

  /// `Version {version} ({build})`
  String appVersion(Object version, Object build) {
    return Intl.message(
      'Version $version ($build)',
      name: 'appVersion',
      desc: '',
      args: [version, build],
    );
  }

  /// `Menofia`
  String get defaultCityName {
    return Intl.message(
      'Menofia',
      name: 'defaultCityName',
      desc: '',
      args: [],
    );
  }

  /// `Next: {name} - {time}`
  String nextPrayer(Object name, Object time) {
    return Intl.message(
      'Next: $name - $time',
      name: 'nextPrayer',
      desc: '',
      args: [name, time],
    );
  }

  /// `Total:`
  String get totalLabel {
    return Intl.message(
      'Total:',
      name: 'totalLabel',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
