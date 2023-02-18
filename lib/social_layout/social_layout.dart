import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_final/social_cubit/social_cubit.dart';

import '../constants.dart';
import '../social_cubit/social_states.dart';

class SocialLayout extends StatelessWidget {
  static String route = 'SocialLayout';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){
        print(state);
      },
      builder: (context,state){
        var cubit = SocialCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(
              'Social',
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_outlined),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.upload_file),
                label: 'Post',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined), label: 'Settings'),
            ],
            currentIndex: cubit.currentIndex,
            onTap: (index){
              if(index ==1){
                SocialCubit.get(context).GetAllUsers();
              }
              cubit.BottomNavigation(index);
            },
          ),
          body: cubit.screens[cubit.currentIndex],
        ) ;
      },
    );
  }
}
