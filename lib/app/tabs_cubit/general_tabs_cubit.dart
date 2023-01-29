/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'general_tabs_state.dart';

class GeneralTabsCubit extends Cubit<GeneralTabsState> {
  GeneralTabsCubit()
      : super(const GeneralTabsState());

  void setTab(BottomTab tab) => emit(GeneralTabsState(tab: tab));

}
