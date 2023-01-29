import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/app/schedule_bloc/schedule_bloc.dart';
import 'package:todos/app/tabs_cubit/general_tabs_cubit.dart';
import 'package:todos/app/user_bloc/general_user_bloc.dart';

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
          create: (context) => ScheduleBloc(),
        ),
      ],
      child: child,
    );
