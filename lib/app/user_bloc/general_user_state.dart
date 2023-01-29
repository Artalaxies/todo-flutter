


/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

part of '../user_bloc/general_user_bloc.dart';



class GeneralUserState extends Equatable {
  const GeneralUserState({
    this.user = User.empty,
  });

  final User user;

  @override
  List<Object> get props => [user];
}
