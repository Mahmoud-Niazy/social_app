import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_final/screens/add_post_screen.dart';
import 'package:social_final/screens/chat_screen.dart';
import 'package:social_final/screens/settings_screen.dart';
import 'package:social_final/social_cubit/social_states.dart';

import '../constants.dart';
import '../data_models/message_data_model.dart';
import '../data_models/new_post_data_model.dart';
import '../data_models/user_data_model.dart';
import '../screens/home_screen.dart';

class SocialCubit extends Cubit<SocialStates>{
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0 ;
  BottomNavigation(index){
    currentIndex = index ;
    emit(BottomNavigationState());
  }

  List<Widget> screens = [
    HomeScreen(),
    ChatsScreen(),
    AddPostScreen(),
    SettingsScreen(),
  ];


  UserModel? user ;
  GetUserData(){
    emit(GetUserDataLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId)
        .get().then((value) {
      user = UserModel.fromJson(value.data()!);

      emit(GetUserDataSuccessfullyState());
    })
        .catchError((error){
      emit(GetUserDataErrorState());
    });
  }

  final ImagePicker picker = ImagePicker() ;
  File? profileImage ;
  GetProfileImage()async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      profileImage = File(pickedFile.path);
      emit(GetProfileImageSuccessfullyState());
    }
    else{
      emit(GetProfileImageErrorState());
      print('No item Selected');
    }
  }

  File? coverImage ;
  GetCoverImage()async{
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if(pickedFile != null ){
      coverImage = File(pickedFile.path);
      emit(GetCoverImageSuccessfullyState());
    }
    else{
      emit(GetCoverImageErrorState());
      print('No item Selected');
    }
  }


  UploadProfileImage({
    required String name ,
    required String email ,
    required String bio ,
    required String phone ,

  }){
    emit(UploadProfileImageLoadingState());
    FirebaseStorage.instance.ref()
        .child('images/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!).then((value) {
      value.ref.getDownloadURL().then((value){
        UpdateUserData(name: name, email: email, bio: bio, phone: phone,image: value);
        emit(UploadProfileImageSuccessfullyState());
      }).catchError((error){
        emit(UploadProfileImageErrorState());
      });
    }).catchError((error){
      emit(UploadProfileImageErrorState());
    });
  }

  UploadCoverImage({
    required String name ,
    required String email ,
    required String bio ,
    required String phone ,
  }){
    emit(UploadCoverImageLoadingState());
    FirebaseStorage.instance
        .ref()
        .child('image/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value){
        UpdateUserData(
          name: name,
          email: email,
          bio: bio,
          phone: phone,
          cover: value,
        );
        emit(UploadCoverImageSuccessfullyState());
      })
          .catchError((error){
        emit(UploadCoverImageErrorState());
      });
    })
        .catchError((error){
      emit(UploadCoverImageErrorState());
    });
  }

  UpdateUserData({
    required String name ,
    required String email ,
    required String bio ,
    required String phone ,
    String? image ,
    String? cover ,
  }){
    emit(UpdateUserDataLoadingState());
    UserModel newUser = UserModel(
      image: image?? user!.image,
      name: name  ,
      phone:phone ,
      uId: user!.uId ,
      email: email ,
      cover: cover?? user!.cover ,
      bio: bio,
    );
    FirebaseFirestore.instance.collection('users')
        .doc(uId).update(newUser.ToMap())
        .then((value){
      GetUserData();
      emit(UpdateUserDataSuccessfullyState());
    })
        .catchError((error){
      emit(UpdateUserDataErrorState());
    });
  }


  // int postId = CasheHelper.GetData(key: 'postId') != null ? CasheHelper.GetData(key: 'postId') : 0;

  CreateNewPost({
    required String date ,
    required String text ,
    String? postImage ,
  }){
    emit(CreateNewPostLoadingState());
    PostModel newPost = PostModel(
      image: user!.image ,
      name: user!.name ,
      date: date ,
      postImage: postImage ,
      text: text ,
    );
    FirebaseFirestore.instance
        .collection('posts')

        .add(newPost.ToMap())

        .then((value){
          // CasheHelper.SaveData(key: "postId", value: postId);
      emit(CreateNewPostSuccessfullyState());
      newPost = PostModel(
        postImage: postImage ,
        text: text ,
        date: date ,
        name: user!.name,
        image: user!.image,
        postId: value.id,
      );
      FirebaseFirestore.instance.collection('posts')
          .doc(value.id)
          .update(newPost.ToMap()).then((value){
        emit(CreateNewPostSuccessfullyState());
      });
    })
        .catchError((error){
      emit(CreateNewPostErrorState());
    });
  }

  File? postImage ;
  GetPostImage()async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      postImage = File(pickedFile.path);
      emit(GetPostImageSuccessfullyState());
    }
    else{
      emit(GetPostImageErrorState());
      print('No item Selected');
    }
  }
  RemovePostImage(){
    postImage = null ;
    emit(RemovePostImageState());
  }

  UploadPostImage({
    required String date ,
    required String text ,
  }){
    emit(UploadPostImageLoadingState());
    FirebaseStorage.instance
        .ref().child('image/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!).then((value) => {
      value.ref.getDownloadURL().then((value){
        emit(UploadPostImageSuccessfullyState());
        CreateNewPost(
          date: date,
          text: text,
          postImage: value ,
        );
      })
          .catchError((error){
        emit(UploadPostImageErrorState());
      })
    })
        .catchError((error){
      emit(UploadPostImageErrorState());
    });
  }


  // List likes = [] ;
  List<PostModel> posts = [] ;

  GetAllPosts(){
    posts = [];
    // likes = [] ;
    emit(GetAllPostsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('date')
        .get().then((value) {
      // GetAllLikes();
      value.docs.forEach((element) {
        posts.add(PostModel.fromJson(element.data()));

        // CasheHelper.SaveData(key: "postId", value: posts.length);
        emit(GetPostState());
      });

      emit(GetAllPostsSuccessfullyState());
      // print(likes);
    }).catchError((error){
      emit(GetAllPostsErrorState());
    });
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
    required String postId ,
  }){
    emit(AddLikeLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(user!.uId)
        .set({
      'like' : true ,
    }).then((value){
      // GetAllLikes();
      emit(AddLikeSuccessfullyState());
    })
        .catchError((error){
      emit(AddLikeErrorState());
    });

  }

  List<UserModel> users = [];
  GetAllUsers(){
    users= [] ;
    emit(GetAllUsersLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value){
      value.docs.forEach((element) {
        GetUserData();
        if(element.reference.id != user!.uId)
          users.add(UserModel.fromJson(element.data()));
      });
      emit(GetAllUsersSuccessfullyState());
    })
        .catchError((error){
      print(error);
      emit(GetAllUsersErrorState());
    });

  }

  SendMessage({
    required String recieverId ,
    required String text ,
    required String date,

  }){
    emit(SendMessageLoadingState());
    MessageModel message = MessageModel(
      date: date ,
      text: text ,
      recieverId: recieverId,
      senderId: user!.uId,

    );
    FirebaseFirestore.instance
        .collection
      ('users')
        .doc(user!.uId)
        .collection('chats')
        .doc(recieverId)
        .collection('message')
        .add(message.ToMap())
        .then((value){
      emit(SendMessageSuccessfullyState());
    })
        .catchError((error){
      emit(SendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(recieverId)
        .collection('chats')
        .doc(user!.uId)
        .collection('message')
        .add(message.ToMap())
        .then((value){
      emit(SendMessageSuccessfullyState());
    })
        .catchError((error){
      emit(SendMessageErrorState());
    });
  }

  List<MessageModel> messages = [] ;
  GetAllMessages({
    required String id
  }) {
    emit(GetAllMessagesLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uId)
        .collection('chats')
        .doc(id)
        .collection('message')
        .orderBy('date')
        .snapshots().listen((event) {
      messages = [] ;
      event.docs.forEach((element){
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(GetAllMessagesSuccessfullyState());
    });
  }

}