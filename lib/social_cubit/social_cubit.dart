import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_final/data_models/comment_data_model.dart';
import 'package:social_final/screens/add_post_screen.dart';
import 'package:social_final/screens/chat_screen.dart';
import 'package:social_final/screens/settings_screen.dart';
import 'package:social_final/social_cubit/social_states.dart';
import 'package:video_player/video_player.dart';
import '../constants.dart';
import '../data_models/message_data_model.dart';
import '../data_models/new_post_data_model.dart';
import '../data_models/user_data_model.dart';
import '../dio_helper/dio.dart';
import '../screens/home_screen.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  BottomNavigation(index) {
    currentIndex = index;
    emit(BottomNavigationState());
  }

  List<Widget> screens = [
    HomeScreen(),
    ChatsScreen(),
    AddPostScreen(),
    SettingsScreen(),
  ];

  UserModel? user;

  GetUserData() {
    emit(GetUserDataLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      user = UserModel.fromJson(value.data()!);
      FirebaseMessaging.instance.getToken().then((value) {
        user = UserModel(
            phone: user!.phone,
          name: user!.name,
          email: user!.email,
          image: user!.image,
          cover: user!.cover,
          uId: user!.uId,
          bio: user!.bio,
          fcmToken: value
        );
        FirebaseFirestore.instance.collection('users')
            .doc(user!.uId).update(user!.ToMap());
      });
      print(user!.uId);
      emit(GetUserDataSuccessfullyState());
    }).catchError((error) {
      emit(GetUserDataErrorState());
    });
  }

  final ImagePicker picker = ImagePicker();

  File? profileImage;

  GetProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(GetProfileImageSuccessfullyState());
    } else {
      emit(GetProfileImageErrorState());
      print('No item Selected');
    }
  }

  File? coverImage;

  GetCoverImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(GetCoverImageSuccessfullyState());
    } else {
      emit(GetCoverImageErrorState());
      print('No item Selected');
    }
  }

  UploadProfileImage({
    required String name,
    required String email,
    required String bio,
    required String phone,
  }) {
    emit(UploadProfileImageLoadingState());
    FirebaseStorage.instance
        .ref()
        .child('images/${Uri
        .file(profileImage!.path)
        .pathSegments
        .last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        UpdateUserData(
            name: name,
            email: email,
            bio: bio,
            phone: phone,
            image: value);
        emit(UploadProfileImageSuccessfullyState());
      }).catchError((error) {
        emit(UploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(UploadProfileImageErrorState());
    });
  }

  UploadCoverImage({
    required String name,
    required String email,
    required String bio,
    required String phone,
  }) {
    emit(UploadCoverImageLoadingState());
    FirebaseStorage.instance
        .ref()
        .child('image/${Uri
        .file(coverImage!.path)
        .pathSegments
        .last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        UpdateUserData(
          name: name,
          email: email,
          bio: bio,
          phone: phone,
          cover: value,
        );
        emit(UploadCoverImageSuccessfullyState());
      }).catchError((error) {
        emit(UploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(UploadCoverImageErrorState());
    });
  }

  UpdateUserData({
    required String name,
    required String email,
    required String bio,
    required String phone,
    String? image,
    String? cover,
  }) {
    emit(UpdateUserDataLoadingState());
    UserModel newUser = UserModel(
      image: image ?? user!.image,
      name: name,
      phone: phone,
      uId: user!.uId,
      email: email,
      cover: cover ?? user!.cover,
      bio: bio,
      fcmToken: user!.fcmToken,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(newUser.ToMap())
        .then((value) {
      GetUserData();
      emit(UpdateUserDataSuccessfullyState());
    }).catchError((error) {
      emit(UpdateUserDataErrorState());
    });
  }

  // int postId = CasheHelper.GetData(key: 'postId') != null ? CasheHelper.GetData(key: 'postId') : 0;

  CreateNewPost({
    required String date,
    required String text,
    String? postImage,
    String? postVideo,
  }) {
    emit(CreateNewPostLoadingState());
    PostModel newPost = PostModel(
      image: user!.image,
      name: user!.name,
      date: date,
      postImage: postImage,
      text: text,
      userId: user!.uId,
      postVideo: postVideo,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(newPost.ToMap())
        .then((value) {
      // CasheHelper.SaveData(key: "postId", value: postId);
      emit(CreateNewPostSuccessfullyState());
      newPost = PostModel(
        postImage: postImage,
        text: text,
        date: date,
        name: user!.name,
        image: user!.image,
        postId: value.id,
        userId: user!.uId,
        postVideo: postVideo,
      );
      FirebaseFirestore.instance
          .collection('posts')
          .doc(value.id)
          .update(newPost.ToMap())
          .then((value) {
        emit(CreateNewPostSuccessfullyState());
      });
    }).catchError((error) {
      emit(CreateNewPostErrorState());
    });
  }

  File? postImage;

  GetPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(GetPostImageSuccessfullyState());
    } else {
      emit(GetPostImageErrorState());
      print('No item Selected');
    }
  }

  RemovePostImage() {
    postImage = null;
    emit(RemovePostImageState());
  }

  UploadPostImage({
    required String date,
    required String text,
  }) {
    emit(UploadPostImageLoadingState());
    FirebaseStorage.instance
        .ref()
        .child('image/${Uri
        .file(postImage!.path)
        .pathSegments
        .last}')
        .putFile(postImage!)
        .then((value) =>
    {
      value.ref.getDownloadURL().then((value) {
        emit(UploadPostImageSuccessfullyState());
        CreateNewPost(
          date: date,
          text: text,
          postImage: value,
        );
      }).catchError((error) {
        emit(UploadPostImageErrorState());
      })
    })
        .catchError((error) {
      emit(UploadPostImageErrorState());
    });
  }

  // List likes = [] ;
  List<PostModel> posts = [];

  GetAllPosts() {
    // posts = [];
    // likes = [] ;
    emit(GetAllPostsLoadingState());
    FirebaseFirestore.instance.collection('posts').orderBy('date').snapshots()

    // .get()
        .listen((value) {
      posts = [];

      // GetAllLikes();
      value.docs.forEach((element) {
        posts.add(PostModel.fromJson(element.data()));

        // CasheHelper.SaveData(key: "postId", value: posts.length);
        emit(GetPostState());
      });

      emit(GetAllPostsSuccessfullyState());
      // print(likes);
    });
    //     .catchError((error) {
    //   print(error);
    //   emit(GetAllPostsErrorState());
    // });
  }

  // GetAllLikes(){
  //   likes = [] ;
  //   FirebaseFirestore.instance
  //       .collection('posts')
  //       .orderBy('postId')
  //       .get().then((value) {
  //     value.docs.forEach((element) {
  //       element.reference.collection('likes').get().then((value){
  //         likes.add(value.docs.length);
  //         emit(GetLikesStates());
  //       } );
  //     });
  //   });
  // }
  Like({
    required String postId,
  }) {
    emit(AddLikeLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(user!.uId)
        .set({
      'like': true,
    }).then((value) {
      // GetAllLikes();
      emit(AddLikeSuccessfullyState());
    }).catchError((error) {
      emit(AddLikeErrorState());
    });
  }

  List<UserModel> users = [];

  GetAllUsers() {
    users = [];
    emit(GetAllUsersLoadingState());
    FirebaseFirestore.instance.collection('users')
        .snapshots().listen((value) {
      users = [];
      value.docs.forEach((element) {
        GetUserData();
        if (element.reference.id != user!.uId)
          users.add(UserModel.fromJson(element.data()));
      });
      emit(GetAllUsersSuccessfullyState());
    });
    //     .catchError((error) {
    //   print(error);
    //   emit(GetAllUsersErrorState());
    // });
  }

  SendMessage({
    required String recieverId,
    required String text,
    required String date,
  }) {
    emit(SendMessageLoadingState());
    MessageModel message = MessageModel(
      date: date,
      text: text,
      recieverId: recieverId,
      senderId: user!.uId,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uId)
        .collection('chats')
        .doc(recieverId)
        .collection('message')
        .add(message.ToMap())
        .then((value) {
      emit(SendMessageSuccessfullyState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(recieverId)
        .collection('chats')
        .doc(user!.uId)
        .collection('message')
        .add(message.ToMap())
        .then((value) {
      emit(SendMessageSuccessfullyState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];

  GetAllMessages({required String id}) {
    emit(GetAllMessagesLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uId)
        .collection('chats')
        .doc(id)
        .collection('message')
        .orderBy('date')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(GetAllMessagesSuccessfullyState());
    });
  }

  List peopleWhoLike = [];

  PeopleWhoLike({
    required String postId,
  }) {
    peopleWhoLike = [];
    emit(GetPeopleWhoLikeLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .get()
        .then((value) {
      value.data()!['userWhoLike'].forEach((element) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(element)
            .get()
            .then((value) {
          if (peopleWhoLike.contains(UserModel.fromJson(value.data()!)) ==
              false) peopleWhoLike.add(UserModel.fromJson(value.data()!));
          emit(GetPeopleWhoLikeSuccessfullyState());
        }).catchError((error) {
          emit(GetPeopleWhoLikeErrorState());
        });
        emit(GetPeopleWhoLikeSuccessfullyState());
      });
      emit(GetPeopleWhoLikeSuccessfullyState());
    }).catchError((error) {
      emit(GetPeopleWhoLikeErrorState());
    });
  }

  AddComment({required String postId,
    required String text,
    required String userImage,
    required String name,
    required String date,
    String? commentImage,
    required String time}) {
    emit(AddCommentLoadingState());
    CommentsDataModel comment = CommentsDataModel(
      text: text,
      userImage: userImage,
      date: date,
      name: name,
      commentImage: commentImage,
      time: time,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(comment.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .get()
          .then((value) {
        value.data()!["numOfComments"] += 1;
      });
      emit(AddCommentSuccessfullyState());
    }).catchError((error) {
      emit(AddCommentErrorState());
    });
  }

  File? commentImage;

  GetCommentImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      commentImage = File(pickedFile.path);
      emit(GetCommentImageSuccessfullyState());
    } else {
      emit(GetCommentImageErrorState());
      print('No item Selected');
    }
  }

  UploadCommentImage({
    required String date,
    required String text,
    required String name,
    required String userImage,
    required String postId,
    required String time,
  }) {
    emit(UploadCommentImageLoadingState());
    FirebaseStorage.instance
        .ref()
        .child('comments/${Uri
        .file(commentImage!.path)
        .pathSegments
        .last}')
        .putFile(commentImage!)
        .then((value) =>
    {
      value.ref.getDownloadURL().then((value) {
        emit(UploadCommentImageSuccessfullyState());
        AddComment(
          date: date,
          text: text,
          commentImage: value,
          name: name,
          postId: postId,
          userImage: userImage,
          time: time,
        );
      }).catchError((error) {
        emit(UploadCommentImageErrorState());
      })
    })
        .catchError((error) {
      emit(UploadCommentImageErrorState());
    });
  }

  List<CommentsDataModel> comments = [];

  GetComments({
    required String postId,
  }) {
    emit(GetCommentLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy("time")
        .snapshots()

    // .get()

        .listen((value) {
      comments = [];
      value.docs.forEach((element) {
        comments.add(CommentsDataModel.fromJson(element.data()));
      });
      emit(GetCommentSuccessfullyState());
    });
    // .catchError((error){});
  }

  RemoveCommentImage() {
    commentImage = null;
    emit(RemoveCommentImageState());
  }

  GetNumOfcomments(postId) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .get()
        .then((value) async {
      return await value.docs.length.toInt();
    });
  }

  DeletePost({
    required String postId,
  }) {
    emit(DeletePostLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .delete()
        .then((value) {
      emit(DeletePostSuccessfullyState());
      GetAllPosts();
    }).catchError((error) {
      emit(DeletePostErrorState());
    });
  }

  File? postVideo;

  GetPostVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      postVideo = File(pickedFile.path);
      emit(GetPostVideoSuccessfullyState());
    } else {
      emit(GetPostVideoErrorState());
      print('No item Selected');
    }
  }

  VideoPlayerController? controller;

  UploadPostVideo({
    required String date,
    required String text,
  }) {
    emit(UploadPostVideoLoadingState());
    FirebaseStorage.instance
        .ref()
        .child('videos/${Uri
        .file(postVideo!.path)
        .pathSegments
        .last}')
        .putFile(postVideo!)
        .then((value) =>
    {
      value.ref.getDownloadURL().then((value) async {
        // controller = VideoPlayerController.network(
        //   value,
        // );
        //   await controller!.initialize().then((_) {
        //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        //
        //   });
        // emit(UploadPostVideoSuccessfullyState());
        CreateNewPost(
          date: date,
          text: text,
          postVideo: value,
        );
        emit(UploadPostVideoSuccessfullyState());
      }).catchError((error) {
        emit(UploadPostVideoErrorState());
      })
    })
        .catchError((error) {
      emit(UploadPostVideoErrorState());
    });
  }

  List<UserModel> searchResult = [];

  Search(name) {
    searchResult = users.where((element) {
      return element.name.contains(name);
    }

    ).toList();
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .get()
    //     .then((value) {
    //       value.docs.forEach(( element) {
    //         if(element['name']==name){
    //           searchResult.add(UserModel.fromJson(element.data()));
    //           emit(SearchSuccessfully());
    //         }
    //       });
    // });
    emit(SearchSuccessfully());
  }


  Notification({
    required String to,
    required String body,
    required String title,


  }){
    DioHelper.PostData(
      url: 'send',
      data: {
        'to' : to,
        "notification": {
          "body": body,
          "title": title,
          "subtitle": "new message",
        }
      },
    ).then((value){
      print(value.data['success']);
      emit(NotificationSuccessfullytstate());
    }).catchError((error){
      emit(NotificationErrortstate());
      print(error);
    });
  }

// List<PostModel> userPosts =[];
// GetUserPosts(context){
//   emit(GetUserPostsLoadingState());
//    userPosts =
//   SocialCubit.get(context).posts.where((element) {
//     return element.userId == user!.uId;
//   }).toList();
//    emit(GetUserPostsSuccessfullyState());
// }
}
