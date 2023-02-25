import 'package:social_final/data_models/user_data_model.dart';

class PostModel {
  String? name ;
  String? image ;
  String? date ;
  String? text ;
  String? postImage ;
  String? postId ;
  int? likes  ;
  List userWhoLike=[] ;
  int numOfComments=0 ;
   String? userId ;
   String? postVideo ;
   UserModel? user ;

  PostModel({
    this.text,
    this.image,
    this.name,
    this.date,
    this.postImage,
    this.postId ,
    this.likes =0,
    this.userWhoLike =const [] ,
    this.numOfComments=0,
     this.userId,
    this.postVideo,
    this.user,
  });

  PostModel.fromJson(Map<String,dynamic>json){
    name = json['name'] ;
    image = json['image'] ;
    date = json['date'] ;
    text = json['text'] ;
    postImage = json['postImage'] ;
    postId = json['postId'];
    likes =json['likes'] ;
    userWhoLike = json['userWhoLike'];
    numOfComments = json['numOfComments'];
    userId = json['userId'];
    postVideo = json['postVideo'];
    user = json['user'];




  }

  Map<String,dynamic> ToMap(){
    return {
      'name' : name ,
      'image' : image ,
      'date' : date ,
      'text' : text ,
      'postImage' : postImage ,
      'postId' : postId ,
      'likes' : likes,
      'userWhoLike' : userWhoLike,
      'numOfComments' : numOfComments,
      'userId' : userId,
      'postVideo' : postVideo,
      'user' : user,

    };
  }
}

