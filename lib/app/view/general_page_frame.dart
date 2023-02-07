/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todos/app/tabs_cubit/general_tabs_cubit.dart';
import 'package:todos/app/user_bloc/general_user_bloc.dart';

class GeneralPageFrame extends StatelessWidget {
  const GeneralPageFrame({
    super.key,
    this.page,
  });

  final Widget? page;

  @override
  Widget build(BuildContext context) {
    return GeneralPageFrameView(page: page);
  }
}

class GeneralPageFrameView extends StatelessWidget {
  const GeneralPageFrameView({
    super.key,
    this.page,
  });

  final Widget? page;

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select(
      (GeneralTabsCubit cubit) => cubit.state.tab,
    );
    final authUser = context.read<GeneralUserBloc>().state.user;

    return Scaffold(
      body: ColoredBox(
        color: const Color(0xFFE8E0C2),
        child: page,
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      // floatingActionButton: FloatingActionButton(
      //   key: const Key('homeView_addTodo_floatingActionButton'),
      //   onPressed: () => Navigator.of(context).push(EditTodoPage.route()),
      //   // child: const Icon(Icons.add),
      //   backgroundColor: Colors.transparent,
      //   child: Avatar(photo: authUser.photo),
      // ),
      // bottomNavigationBar: BottomAppBar(
      //   shape: const CircularNotchedRectangle(),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: [
      //       _HomeTabButton(
      //         groupValue: selectedTab,
      //         value: BottomTab.todos,
      //         icon: const Icon(Icons.list_rounded),
      //       ),
      //       _HomeTabButton(
      //         groupValue: selectedTab,
      //         value: BottomTab.stats,
      //         icon: const Icon(Icons.show_chart_rounded),
      //       ),
      //       BackButton(
      //         onPressed: ()=> context.go('/login'),
      //       ),
      //       Avatar(photo: authUser.photo)
      //     ],
      //   ),
      // ),
    );
  }
}

class _HomeTabButton extends StatelessWidget {
  const _HomeTabButton({
    required this.groupValue,
    required this.value,
    required this.icon,
  });

  final BottomTab groupValue;
  final BottomTab value;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<GeneralTabsCubit>().setTab(value);
        context.go('/${value.name}');
      },
      iconSize: 32,
      color:
          groupValue != value ? null : Theme.of(context).colorScheme.secondary,
      icon: icon,
    );
  }
}
