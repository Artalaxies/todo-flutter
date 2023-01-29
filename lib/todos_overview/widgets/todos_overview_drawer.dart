/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todos/app/user_bloc/general_user_bloc.dart';



class TodosOverviewDrawer extends StatelessWidget {
  const TodosOverviewDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(child: Text('header'),),
          ListTile(
            title: const Text('sign in'),
            onTap: (){
              if(context.read<GeneralUserBloc>().state.user.isEmpty){
                context.go('/login');
              }
            },
          ),
          ListTile(
            title: const Text('Change Log'),
            onTap: (){
              if(context.read<GeneralUserBloc>().state.user.isEmpty){
                context.go('/changelog');
              }
            },
          ),
        ],
      ),
    );
}
}
