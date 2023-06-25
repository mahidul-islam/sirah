// ignore_for_file: constant_identifier_names

import 'package:firebase_analytics/firebase_analytics.dart';

enum CustomUserEventsAnalytics {
  CUSTOM_EVENT,
  TAP_ON_RUNNING,
  WEEKLY_STATS_HELP_BUTTON,
  PRS_HELP_BUTTON,
  FRESHNESS_HELP_BUTTON,
  TRAINING_LOAD_HELP_BUTTON,
}

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  void sendPageAnalytics(String? pageName) {
    getAnalyticsObserver().analytics.setCurrentScreen(
          screenName: '$pageName',
        );
  }

  Future<void> sendCustomUserEvents(
      {CustomUserEventsAnalytics eventName =
          CustomUserEventsAnalytics.CUSTOM_EVENT,
      required Map<String, dynamic> params}) async {
    final Map<String, dynamic>? userParams = params;
    userParams?.removeWhere((String? key, dynamic value) => value == null);
    await getAnalyticsObserver().analytics.logEvent(
        name: eventName.toString().split('.').last.toUpperCase(),
        parameters: userParams);
  }

  Future<void> sendNamedUserEvents(
      {required String eventName, Map<String, dynamic>? params}) async {
    final Map<String, dynamic> userParams = params ?? <String, dynamic>{};
    userParams.removeWhere((String key, dynamic value) => value == null);
    await getAnalyticsObserver().analytics.logEvent(
        name: eventName.toString().split('.').last.toUpperCase(),
        parameters: userParams);
  }
}
