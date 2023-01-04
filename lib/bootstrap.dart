import 'dart:async';
import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/app/app.dart';
import 'package:todos/app/app_bloc_observer.dart';
import 'package:todos_api/todos_api.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

void bootstrap({required TodosApi todosApi, FirebaseAuth? auth}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = AppBlocObserver();

  final authenticationRepository = AuthenticationRepository(firebaseAuth: auth);
  runZonedGuarded(
    () => runApp(
      App(
        repositoryProviders: [
          RepositoryProvider.value(
            value: TodosRepository(todosApi: todosApi),
          ),
          RepositoryProvider.value(
            value: authenticationRepository,
          )
        ],
      ),
    ),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
