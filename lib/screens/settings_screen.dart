import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cashe_helper/cashe_helper.dart';
import '../reusable_components/reusable_components.dart';
import '../social_cubit/social_cubit.dart';
import '../social_cubit/social_states.dart';
import 'edit_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var user = SocialCubit.get(context).user;
        return ConditionalBuilder(
          condition: user != null,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    height: 300,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          child: Container(
                            height: 250,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  user!.cover,
                                ),
                              ),
                            ),
                          ),
                          alignment: AlignmentDirectional.topStart,
                        ),
                        CircleAvatar(
                          radius: 60.0,
                          backgroundImage: NetworkImage(
                            user.image,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 20.0,
                        ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    user.bio,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  BuildMaterialButton(
                      onPressed: () {
                        NavigateWithName(
                          context: context,
                          route: EditProfileScreen.route,
                        );
                      },
                      label: 'Edit Profile'),
                  SizedBox(
                    height: 15.0,
                  ),
                  BuildMaterialButton(
                    onPressed: () {
                      SocialCubit.get(context).user = null;
                      SocialCubit.get(context).users= [] ;
                      SocialCubit.get(context).messages= [];
                      // SocialCubit.get(context).likes= [] ;
                      SocialCubit.get(context).posts = [] ;
                      SocialCubit.get(context).profileImage=null;
                      SocialCubit.get(context).coverImage=null;
                      SocialCubit.get(context).postImage=null;
                      CasheHelper.RemoveData(key: 'uId').then((value) {
                        NavigateAndRemove(
                          context: context,
                          route: '/',
                        );
                      });
                    },
                    label: 'Logout',
                  ),
                ],
              ),
            ),
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
