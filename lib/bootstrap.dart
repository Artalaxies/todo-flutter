/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'dart:async';
import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/app/app.dart';
import 'package:todos/app/app_bloc_observer.dart';
import 'package:todos/module.dart';
import 'package:todos_api/todos_api.dart';
import 'package:todos_repository/todos_repository.dart';

import 'app/tabs_cubit/general_tabs_cubit.dart';
import 'app/user_bloc/general_user_bloc.dart';

void bootstrap({required TodosApi todosApi, FirebaseAuth? auth}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = AppBlocObserver();

  final authenticationRepository = AuthenticationRepository(firebaseAuth: auth);
  final todosRepository = TodosRepository(todosApi: todosApi);

  Modularization.addGlobalRepository((context) => authenticationRepository);
  Modularization.addGlobalRepository((context) => todosRepository);
  Modularization.addGlobalBloc((context) => GeneralTabsCubit());
  Modularization.addGlobalBloc(
    (context) => GeneralUserBloc(
      authenticationRepository: authenticationRepository,
    ),
  );
  runZonedGuarded(
    () => runApp(const App()),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
