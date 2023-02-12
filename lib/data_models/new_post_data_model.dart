class PostModel {
  String? name ;
  String? image ;
  String? date ;
  String? text ;
  String? postImage ;
  String? postId ;
  int? likes  ;

  PostModel({
    this.text,
    this.image,
    this.name,
    this.date,
    this.postImage,
    this.postId ,
    this.likes =0
  });

  PostModel.fromJson(Map<String,dynamic>json){
    name = json['name'] ;
    image = json['image'] ;
    date = json['date'] ;
    text = json['text'] ;
    postImage = json['postImage'] ;
    postId = json['postId'];
    likes =json['likes'] ;
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
    };
  }
}

