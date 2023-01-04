import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'general_user_state.dart';

part 'general_user_event.dart';

class GeneralUserBloc extends Bloc<GeneralUserEvent, GeneralUserState> {
  GeneralUserBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(
          GeneralUserState(user: authenticationRepository.currentUser),
        ) {
    on<_GeneralUserChanged>(_onUserChanged);
    on<GeneralUserLogoutRequested>(_onLogoutRequested);
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(_GeneralUserChanged(user)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;

  void _onUserChanged(
      _GeneralUserChanged event, Emitter<GeneralUserState> emit) {
    emit(GeneralUserState(user: event.user));
  }

  void _onLogoutRequested(
      GeneralUserLogoutRequested event, Emitter<GeneralUserState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
