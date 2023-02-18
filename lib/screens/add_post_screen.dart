import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../reusable_components/reusable_components.dart';
import '../social_cubit/social_cubit.dart';
import '../social_cubit/social_states.dart';

class AddPostScreen extends StatelessWidget {
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is CreateNewPostSuccessfullyState) {
          SocialCubit.get(context).GetAllPosts();
          SocialCubit.get(context).RemovePostImage();
          textController.text = '';
          SocialCubit.get(context).currentIndex = 0;
        }
        print(state);
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: SocialCubit.get(context).user != null,
          builder: (context) {
            var user = SocialCubit.get(context).user;
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30.0,
                          backgroundImage: NetworkImage(
                            user!.image,
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          user.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: 17.0),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: textController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          label: Text(
                            'What\'s in your mind ? ',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    if (SocialCubit.get(context).postImage != null)
                      Expanded(
                        child: Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Image(
                              width: double.infinity,
                              image: FileImage(
                                  SocialCubit.get(context).postImage!),
                            ),
                            InkWell(
                              child: CircleAvatar(
                                radius: 12.0,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.black,
                                  size: 15,
                                ),
                              ),
                              onTap: () {
                                SocialCubit.get(context).RemovePostImage();
                              },
                            ),
                          ],
                        ),
                      ),
                    if(SocialCubit.get(context).controller!= null)
                    if (SocialCubit.get(context).controller!.value.isInitialized)
                      Center(
                          child: Container(
                            height: 200,
                              width: double.infinity,
                              child: VideoPlayer(
                                  SocialCubit.get(context).controller!))),
                    SizedBox(
                      height: 25,
                    ),
                    BuildMaterialButton(
                      onPressed: () {
                        SocialCubit.get(context).GetPostImage();
                      },
                      label: 'Add photo',
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    BuildMaterialButton(
                      onPressed: () {
                        SocialCubit.get(context).GetPostVideo();
                      },
                      label: 'Add video',
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    ConditionalBuilder(
                      condition: state is! UploadPostImageLoadingState,
                      builder: (context) => BuildMaterialButton(
                        onPressed: () {
                          // if (textController.text.isNotEmpty ||
                          //     SocialCubit.get(context).postImage != null) {
                          //   if (SocialCubit.get(context).postImage != null) {
                          //     SocialCubit.get(context).UploadPostImage(
                          //       date: DateTime.now().toString(),
                          //       text: textController.text,
                          //     );
                          //   } else {
                          //     SocialCubit.get(context).CreateNewPost(
                          //       date: DateTime.now().toString(),
                          //       text: textController.text,
                          //     );
                          //   }
                          // }

                          SocialCubit.get(context).UploadPostVideo(
                            date: DateTime.now().toString(),
                            text: textController.text,
                          );
                        },
                        label: 'Post',
                      ),
                      fallback: (context) =>
                          Center(child: CircularProgressIndicator()),
                    ),
                  ],
                ),
              ),
            );
          },
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
