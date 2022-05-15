import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:sirah/shared/analytics.dart';

import 'navigation_services.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  await Firebase.initializeApp();
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => AnalyticsService());
}
