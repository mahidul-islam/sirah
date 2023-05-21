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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupLocator();
  BlocOverrides.runZoned(
    () => runApp(const SirahApp()),
    blocObserver: AppBlocObserver(),
  );
}
