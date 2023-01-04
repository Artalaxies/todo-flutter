import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:server_storage_todos_api_impl/server_storage_todos_api_impl.dart';
import 'package:todos/app/tabs_cubit/general_tabs_cubit.dart';
import 'package:todos/app/todos_sync_bloc/todos_sync_bloc.dart';
import 'package:todos/app/todos_sync_bloc/todos_sync_event.dart';
import 'package:todos/app/user_bloc/general_user_bloc.dart';
import 'package:todos_repository/todos_repository.dart';

MultiBlocProvider appBlocProviders(Widget child) => MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GeneralTabsCubit(),
        ),
        BlocProvider(
          create: (context) => GeneralUserBloc(
            authenticationRepository: context.read<AuthenticationRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => TodosSyncBloc(
            todosRepository: context.read<TodosRepository>(),
          )..add(const TodosSyncStarted(sec: 60)),
        ),
      ],
      child: child,
    );
