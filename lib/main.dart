import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'src/feature/app/presentation/app_root.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const AppRoot());
}
