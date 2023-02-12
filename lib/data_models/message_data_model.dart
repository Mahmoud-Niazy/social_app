class MessageModel{
  String? text ;
  String? date ;
  String? recieverId ;
  String? senderId ;

  MessageModel({
    this.text ,
    this.date ,
    this.recieverId ,
    this.senderId ,
  });

  MessageModel.fromJson(Map<String,dynamic> json){
    text = json['text'] ;
    date = json['date'] ;
    recieverId = json['recieverId'] ;
    senderId = json['senderId'];
  }

  ToMap(){
    return {
      'text' : text ,
      'date' : date ,
      'recieverId' : recieverId ,
      'senderId' : senderId ,
    };
  }
}