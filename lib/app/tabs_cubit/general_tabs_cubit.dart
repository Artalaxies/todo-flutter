import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'general_tabs_state.dart';

class GeneralTabsCubit extends Cubit<GeneralTabsState> {
  GeneralTabsCubit()
      : super(const GeneralTabsState());

  void setTab(BottomTab tab) => emit(GeneralTabsState(tab: tab));

}
