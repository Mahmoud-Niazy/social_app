class UserModel{
  late String name ;
  late String email ;
  late String phone ;
  late String uId ;
  late String image ;
  late String cover ;
  late String bio ;

  UserModel({
    required this.phone,
    required this.name,
    required this.email,
    required this.image,
    required this.cover,
    required this.uId,
    required this.bio,
});

  Map<String,dynamic>ToMap (){
    return {
      'name' : name ,
      'phone' : phone ,
      'email' : email ,
      'image' : image ,
      'cover' : cover ,
      'uId' : uId ,
      'bio' : bio ,
    };
  }

  UserModel.fromJson(Map<String,dynamic> json){
    name = json['name'];
    image = json['image'];
    phone = json['phone'];
    email = json['email'];
    cover = json['cover'];
    uId = json['uId'];
    bio = json['bio'];
  }
}