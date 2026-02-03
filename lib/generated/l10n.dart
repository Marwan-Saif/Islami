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

  /// `Bearish`
  String get onboarding3_title {
    return Intl.message(
      'Bearish',
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

  /// `Verse`
  String get Verse {
    return Intl.message(
      'Verse',
      name: 'Verse',
      desc: '',
      args: [],
    );
  }

  /// `Quran`
  String get onboarding_title_1 {
    return Intl.message(
      'Quran',
      name: 'onboarding_title_1',
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
