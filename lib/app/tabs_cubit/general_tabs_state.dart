part of 'general_tabs_cubit.dart';

enum BottomTab { todos, stats }

class GeneralTabsState extends Equatable {
  const GeneralTabsState({
    this.tab = BottomTab.todos,
  });

  final BottomTab tab;

  @override
  List<Object> get props => [tab];
}
