import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_final/screens/chat_details_screen.dart';

import '../data_models/user_data_model.dart';
import '../social_cubit/social_cubit.dart';
import '../social_cubit/social_states.dart';

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: SocialCubit.get(context).users.length > 0,
          builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) =>
                BuildChatItem(context, SocialCubit.get(context).users[index]),
            separatorBuilder: (context, index) => Container(
              height: 1,
              color: Colors.grey[300],
            ),
            itemCount: SocialCubit.get(context).users.length,
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget BuildChatItem(context, UserModel user) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              backgroundImage: NetworkImage(
                user.image,
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              user.name,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 20.0,
                  ),
            ),
          ],
        ),
      ),
      onTap: () {
        // NavigateWithName(context: context, route: route)
        // // Navigate(context, ChatScreen(user));
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailsScreen(user),
            ));
      },
    );
  }
}
