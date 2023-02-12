import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data_models/new_post_data_model.dart';
import '../social_cubit/social_cubit.dart';
import '../social_cubit/social_states.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is GetUserDataSuccessfullyState) {
          // SocialCubit.get(context).GetAllUsers() ;
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: SocialCubit.get(context).posts.length> 0 ,
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
          fallback: (context) => Center(child: Column(
            children: [
              Icon(
                Icons.hourglass_empty,
                size: 150,
              ),
              Text(
                'No posts',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )),
        );
      },
    );
  }

  Widget BuildPostItem(context, PostModel post, index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    post.image!,
                  ),
                  radius: 25.0,
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
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_horiz,
                  ),
                ),
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
                Padding(
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
                      Text(
                        '200',
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
                Text(
                  'Write a comment',
                  style: Theme.of(context).textTheme.caption,
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

                    PostModel newPost = PostModel(
                      image: post.image,
                      name: post.name,
                      text: post.text,
                      date: post.date,
                      postId: post.postId,
                      postImage: post.postImage,
                      likes: (post.likes!)+1,
                    );
                    FirebaseFirestore.instance.collection('posts').doc(post.postId)
                        .update(newPost.ToMap()).then((value){
                          print('Like successfully');
                          SocialCubit.get(context).GetAllPosts();
                    })
                    .catchError((error){
                      print(error);
                    });
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
  }
}
