/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:server_storage_todos_api_impl/server_storage_todos_api_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos/bootstrap.dart';
import 'package:todos/firebase_options.dart';

import 'package:todos/platforms/web_plugins_locator.dart'
if (dart.library.js) 'package:flutter_web_plugins/flutter_web_plugins.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final auth = FirebaseAuth.instance;
  final functions = FirebaseFunctions.instance;

  await auth.useAuthEmulator('localhost', 9099);
  functions.useFunctionsEmulator('localhost', 5001);

  final todosApi = ServerStorageTodosApiImpl(
    plugin: await SharedPreferences.getInstance(),
    functions: functions,
  );

  bootstrap(todosApi: todosApi, auth:  auth);
}
