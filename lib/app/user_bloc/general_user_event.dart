part of 'general_user_bloc.dart';

abstract class GeneralUserEvent {
  const GeneralUserEvent();
}

class GeneralUserLogoutRequested extends GeneralUserEvent {
  const GeneralUserLogoutRequested();
}

class _GeneralUserChanged extends GeneralUserEvent {
  const _GeneralUserChanged(this.user);

  final User user;
}
