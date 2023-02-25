
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:social_final/screens/search_screen.dart';
import 'package:social_final/social_cubit/social_cubit.dart';

import '../constants.dart';
import '../social_cubit/social_states.dart';

class SocialLayout extends StatelessWidget {
  static String route = 'SocialLayout';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        print(state);
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(
              'Social',
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchScreen()),
                  );
                },
                icon: Icon(
                  Icons.search,
                ),
              ),
            ],
          ),
          bottomNavigationBar: SalomonBottomBar(
            currentIndex:cubit.currentIndex,
            onTap: (i) => cubit.BottomNavigation(i),

            items: [
              SalomonBottomBarItem(
                icon: Icon(Icons.home),
                title: Text("Home"),
                // selectedColor: Colors.purple,
              ),

              SalomonBottomBarItem(
                icon: Icon(Icons.chat_outlined),
                title: Text("Chats"),
                // selectedColor: Colors.pink,
              ),

              SalomonBottomBarItem(
                icon: Icon(Icons.upload_file),
                title: Text("Post"),
                // selectedColor: Colors.orange,
              ),

              SalomonBottomBarItem(
                icon: Icon(Icons.settings_outlined),
                title: Text("Settings"),
                // selectedColor: Colors.teal,
              ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
        );

          // BottomNavigationBar(
          //   items: [
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.home_outlined),
          //       label: 'Home',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.chat_outlined),
          //       label: 'Chats',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.upload_file),
          //       label: 'Post',
          //     ),
          //     BottomNavigationBarItem(
          //         icon: Icon(Icons.settings_outlined), label: 'Settings'),
          //   ],
          //   currentIndex: cubit.currentIndex,
          //   onTap: (index) {
          //     if (index == 1) {
          //       SocialCubit.get(context).GetAllUsers();
          //     }
          //     cubit.BottomNavigation(index);
          //   },
          // ),


      },
    );
  }
}
