class ChangeFavoritesModel{
  late bool state;
  late String message;

  ChangeFavoritesModel.fromJson(Map<String,dynamic> json){
    state = json['status'];
    message = json['message'];
  }

}