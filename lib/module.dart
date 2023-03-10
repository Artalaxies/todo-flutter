import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Modularization {
  static final List<BlocProvider> _blocProviders = [];
  static final List<RepositoryProvider<dynamic>> _repositoryProviders = [];

  static MultiRepositoryProvider build(Widget child) => MultiRepositoryProvider(
        providers: _repositoryProviders,
        child: MultiBlocProvider(providers: _blocProviders, child: child),
      );

  static void addGlobalBloc<T extends StateStreamableSource<Object?>>(
    T Function(BuildContext context) bloc,
  ) =>
      _blocProviders.add(
        BlocProvider<T>(
          create: bloc,
        ),
      );

  static void addGlobalRepository<T>(
    T Function(BuildContext context) repository,
  ) =>
      _repositoryProviders.add(RepositoryProvider<T>(create: repository));
}
