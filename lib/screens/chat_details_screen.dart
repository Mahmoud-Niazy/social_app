import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data_models/message_data_model.dart';
import '../data_models/user_data_model.dart';
import '../social_cubit/social_cubit.dart';
import '../social_cubit/social_states.dart';

class ChatDetailsScreen extends StatelessWidget {
  var text_controller = TextEditingController();
  late UserModel user;
  ChatDetailsScreen(this.user);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).GetAllMessages(id: user.uId);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22.0,
                        backgroundImage: NetworkImage(
                          user.image,
                        ),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Text(
                        user.name,
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: Column(
                children: [
                  ConditionalBuilder(
                    condition: SocialCubit.get(context).messages.length > 0,
                    builder: (context) => Expanded(
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (SocialCubit.get(context).user!.uId ==
                              SocialCubit.get(context)
                                  .messages[index]
                                  .senderId) {
                            return BuildMyMessage(
                                SocialCubit.get(context).messages[index]);
                          } else {
                            return BuildMessage(
                                SocialCubit.get(context).messages[index]);
                          }
                        },
                        separatorBuilder: (context, index) => SizedBox(
                          height: 5.0,
                        ),
                        itemCount: SocialCubit.get(context).messages.length,
                      ),
                    ),
                    fallback: (context) =>
                        Center(child: CircularProgressIndicator()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 15.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: text_controller,
                            decoration: InputDecoration(
                              label: Text('Write message here'),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            SocialCubit.get(context).SendMessage(
                              recieverId: user.uId,
                              text: text_controller.text,
                              date: DateTime.now().toString(),
                            );
                            text_controller.text = '';
                          },
                          icon: Icon(
                            Icons.send,
                            size: 35,
                          ),
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  BuildMessage(MessageModel message) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 25.0,
          top: 25.0,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          child: Text(
            message.text!,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(5.0),
                topLeft: Radius.circular(5.0),
                bottomRight: Radius.circular(5.0)),
          ),
        ),
      ),
    );
  }

  BuildMyMessage(MessageModel message) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 25.0,
          right: 25.0,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          child: Text(
            message.text!,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(.5),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(5.0),
                topLeft: Radius.circular(5.0),
                bottomLeft: Radius.circular(5.0)),
          ),
        ),
      ),
    );
  }
}
