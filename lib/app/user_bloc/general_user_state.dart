


part of '../user_bloc/general_user_bloc.dart';



class GeneralUserState extends Equatable {
  const GeneralUserState({
    this.user = User.empty,
  });

  final User user;

  @override
  List<Object> get props => [user];
}
