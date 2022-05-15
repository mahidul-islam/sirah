import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sirah/app/history_app.dart';
import 'package:sirah/app/observer/bloc_observer.dart';
import 'package:sirah/firebase_options.dart';
import 'package:sirah/shared/locator.dart';

// import 'main_menu/main_menu.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: const FirebaseOptions(
  //       apiKey: "AIzaSyDzHsngze_XrAdzTvhukDBttfK8i_swMGc",
  //       appId: "1:869608716212:web:1763652215ac5ad6d0e4e1",
  //       messagingSenderId: "869608716212",
  //       projectId: "sirah-muhammad-s"),
  // );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupLocator();
  BlocOverrides.runZoned(
    () => runApp(const SirahApp()),
    blocObserver: AppBlocObserver(),
  );
}
