import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_final/screens/comments_screen.dart';
import '../constants.dart';
import '../data_models/new_post_data_model.dart';
import '../data_models/user_data_model.dart';
import '../reusable_components/reusable_components.dart';
import '../social_cubit/social_cubit.dart';
import '../social_cubit/social_states.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context){
      SocialCubit.get(context).GetAllPosts();
      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {
          if (state is GetUserDataSuccessfullyState) {
            // SocialCubit.get(context).GetAllUsers() ;

          }
        },
        builder: (context, state) {
          return ConditionalBuilder(
            condition: SocialCubit.get(context).posts.length > 0,
            builder: (context) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Card(
                          child: Image(
                            image: NetworkImage(
                              'https://img.freepik.com/free-photo/excited-happy-young-pretty-woman_171337-2005.jpg?size=626&ext=jpg&ga=GA1.2.190088039.1657057581',
                            ),
                          ),
                          elevation: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Communicate with your friends',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => BuildPostItem(
                          context, SocialCubit.get(context).posts[index], index),
                      separatorBuilder: (context, index) => SizedBox(
                        height: 15.0,
                      ),
                      itemCount: SocialCubit.get(context).posts.length,
                    ),
                  ],
                ),
              );
            },
            fallback: (context) => Center(child: CircularProgressIndicator()),
            //     Center(
            //     child: Column(
            //   children: [
            //     Icon(
            //       Icons.hourglass_empty,
            //       size: 150,
            //     ),
            //     Text(
            //       'No posts',
            //       style: TextStyle(
            //         fontSize: 50,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ],
            // )),
          );
        },
      );
    },);

  }

  Widget BuildPostItem(context, PostModel post, index) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        // if(state is GetPeopleWhoLikeSuccessfullyState){
        //   NavigateWithName(
        //       context: context,
        //       route: PeopleWhoLikeScreen.route,
        //       data: {
        //         'id' : post.postId,
        //       }
        //   );
        //
        // }
      },
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    //////////////////////////////////////////////////////////////////////

                    InkWell(
                      onTap: () {
                        // NavigateWithName(
                        //     context: context,
                        //     route: AnotherUserScreen.route,
                        //     data: {
                        //       'id' : post.userId,
                        //     }
                        // );
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          post.image!,
                        ),
                        radius: 25.0,
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              post.name!,
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                            SizedBox(
                              width: 2.0,
                            ),
                            Icon(
                              Icons.check_circle,
                              size: 13.0,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        Text(
                          post.date!,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                    Spacer(),
                    if (post.userId == SocialCubit.get(context).user!.uId)
                      PopupMenuButton(
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: Text('Delete'),
                                  onTap: () {
                                    SocialCubit.get(context)
                                        .DeletePost(postId: post.postId!);
                                  },
                                ),
                              ]),
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: Icon(
                    //     Icons.more_horiz,
                    //   ),
                    // ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                  ),
                  child: Container(
                    height: 1.0,
                    color: Colors.grey[300],
                  ),
                ),
                Text(
                  post.text!,
                  style: TextStyle(
                    height: 1.4,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                if (post.postImage != null)
                  Image(
                    image: NetworkImage(
                      post.postImage!,
                    ),
                  ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        scaffoldKey.currentState!.showBottomSheet((context) {
                          SocialCubit.get(context)
                              .PeopleWhoLike(postId: post.postId!);
                          return BlocConsumer<SocialCubit, SocialStates>(
                            listener: (context, state) {
                              print(state);
                            },
                            builder: (context, state) {
                              // var recievedData = ModalRoute
                              //     .of(context)!
                              //     .settings
                              //     .arguments as Map<String, dynamic>;
                              // id = recievedData['id'];
                              // SocialCubit.get(context).PeopleWhoLike(postId: this.id!);

                              return SafeArea(
                                child: Scaffold(
                                  // appBar: AppBar(
                                  //   title: Text(
                                  //     'People who make like',
                                  //   ),
                                  //   leading: IconButton(
                                  //     onPressed: () {
                                  //       Navigator.pop(context);
                                  //       // SocialCubit.get(context).peopleWhoLike=[];
                                  //     },
                                  //     icon: Icon(Icons.arrow_back),
                                  //   ),
                                  // ),
                                  body:
                                      // ListView.separated(
                                      //   itemBuilder: (context, index) {
                                      //     return PeopleWhoLikeModel(
                                      //         SocialCubit.get(context).peopleWhoLike[index]);
                                      //   },
                                      //   separatorBuilder: (context, index) => SizedBox(
                                      //     height: 0,
                                      //   ),
                                      //   itemCount: SocialCubit.get(context).peopleWhoLike.length,
                                      // ),

                                      ConditionalBuilder(
                                    condition:
                                        state is! GetPeopleWhoLikeLoadingState,
                                    // SocialCubit
                                    //     .get(context)
                                    //     .peopleWhoLike
                                    //     .length > 0,
                                    builder: (context) => ListView.separated(
                                      itemBuilder: (context, index) {
                                        return PeopleWhoLikeModel(
                                            SocialCubit.get(context)
                                                .peopleWhoLike[index]);
                                      },
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                        height: 0,
                                      ),
                                      itemCount: SocialCubit.get(context)
                                          .peopleWhoLike
                                          .length,
                                    ),
                                    fallback: (context) => Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                ),
                              );
                            },
                          );
                        });
                        // NavigateWithName(
                        //     context: context,
                        //     route: PeopleWhoLikeScreen.route,
                        //     data: {
                        //       'id' : post.postId,
                        //     }
                        // );
                        // var recievedData = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
                        // String id = recievedData['id'];
                        // SocialCubit.get(context).PeopleWhoLike(postId: post.postId!);
                        // if(state is GetPeopleWhoLikeSuccessfullyState)
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '${post.likes}',
                              // '${SocialCubit.get(context).likes[index]}',
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 20.0,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.comment,
                            color: Colors.amberAccent,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('${post.numOfComments}'
                              // "${SocialCubit.get(context).GetNumOfcomments(post.postId)}",
                              ),
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: Container(
                    height: 1.0,
                    color: Colors.grey[300],
                  ),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        SocialCubit.get(context).user!.image,
                      ),
                      radius: 20.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    InkWell(
                      onTap: () {
                        NavigateWithName(
                          context: context,
                          route: CommentsScreen.route,
                          data: {
                            'id': post.postId,
                          },
                        );
                        // scaffoldKey2.currentState!.showBottomSheet((context) {
                        //   return Column(
                        //
                        //   );
                        // });
                      },
                      child: Text(
                        'Write a comment',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 15.0,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'like',
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        if (post.userWhoLike
                                .contains(SocialCubit.get(context).user!.uId) ==
                            false) {
                          post.userWhoLike
                              .add(SocialCubit.get(context).user!.uId);
                          PostModel newPost = PostModel(
                            image: post.image,
                            name: post.name,
                            text: post.text,
                            date: post.date,
                            postId: post.postId,
                            postImage: post.postImage,
                            likes: (post.likes!) + 1,
                            numOfComments: post.numOfComments,
                            userWhoLike: post.userWhoLike,
                            userId: SocialCubit.get(context).user!.uId,
                          );
                          FirebaseFirestore.instance
                              .collection('posts')
                              .doc(post.postId)
                              .update(newPost.ToMap())
                              .then((value) {
                            print('Like successfully');
                            SocialCubit.get(context).GetAllPosts();
                          }).catchError((error) {
                            print(error);
                          });
                        } else {
                          post.userWhoLike
                              .remove(SocialCubit.get(context).user!.uId);
                          PostModel newPost = PostModel(
                            image: post.image,
                            name: post.name,
                            text: post.text,
                            date: post.date,
                            postId: post.postId,
                            postImage: post.postImage,
                            likes: (post.likes!) - 1,
                            userWhoLike: post.userWhoLike,
                            numOfComments: post.numOfComments,
                            userId: SocialCubit.get(context).user!.uId,
                          );
                          FirebaseFirestore.instance
                              .collection('posts')
                              .doc(post.postId)
                              .update(newPost.ToMap())
                              .then((value) {
                            print('Like successfully');
                            SocialCubit.get(context).GetAllPosts();
                          }).catchError((error) {
                            print(error);
                          });
                        }
                        // PostModel newPost = PostModel(
                        //   image: post.image,
                        //   name: post.name,
                        //   text: post.text,
                        //   date: post.date,
                        //   postId: post.postId,
                        //   postImage: post.postImage,
                        //   likes: (post.likes!)+1,
                        //   userWhoLike: [],
                        // );
                        // FirebaseFirestore.instance.collection('posts').doc(post.postId)
                        //     .update(newPost.ToMap()).then((value){
                        //       print('Like successfully');
                        //       SocialCubit.get(context).GetAllPosts();
                        // })
                        // .catchError((error){
                        //   print(error);
                        // });
                        // SocialCubit.get(context).Like(postId: post.postId!);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          elevation: 15.0,
        );
      },
    );
  }
}

PeopleWhoLikeModel(UserModel user) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 20,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   'People who make like',
        //   style: TextStyle(
        //     fontSize: 20
        //   ),
        // ),
        SizedBox(
          height: 30,
        ),
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(user.image
                  // 'https://img.freepik.com/premium-photo/tiny-cute-adorable-animal_727939-188.jpg?size=338&ext=jpg&ga=GA1.2.190088039.1657057581'),
                  ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                user.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ],
        ),
      ],
    ),
  );
}
