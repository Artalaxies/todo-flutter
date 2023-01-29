/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

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
