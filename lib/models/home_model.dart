class HomeModel
{
  late bool status;
  HomeDataModel? data;

  HomeModel.fromJson(Map<String, dynamic> json)
  {
    status = json['status'];
    data = json['data'] != null ?  HomeDataModel.fromJson(json['data']):null;
  }
}

class HomeDataModel
{
  List<BannerModel> banners = [];
  List<ProductModel> products = [];

  HomeDataModel.fromJson(Map<String, dynamic> json)
  {
    json['banners'].forEach((element)
    {
      banners.add(BannerModel.fromJson(element));
    });

    json['products'].forEach((element)
    {
      products.add(ProductModel.fromJson(element));
    });
  }
}

class BannerModel
{
  late int id;
  late String image;

  BannerModel.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    image = json['image'];
  }
}

class ProductModel
{
  late int id;
  late dynamic price;
  late dynamic oldPrice;
  late dynamic discount;
  late String image;
  late String name;
  late bool inFavorites;
  late bool inCart;

  ProductModel.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }
}







/*class HomeModel{
  late bool status;
  HomeDataModel? data;

  HomeModel.fromJson(Map<String,dynamic> json){
    status = json['status'];
    data = json['data'] != null ? HomeDataModel.fromJson(json['data']): null;
    //data = json['data'] != null ? HomeDataModel.fromJson(json['data']) : null;
  }

}

class HomeDataModel{
  List<BannersModel?> banners = [];
  List<ProductsModel?> products = [];
  HomeDataModel.fromJson(Map<String,dynamic> json){
    json['banners'].forEach((element){
      banners.add(element);
    });
    json['products'].forEach((element){
      products.add(element);
    });
  }
}

class BannersModel{
  late int id;
  late String image;

  BannersModel.fromJson(Map<String,dynamic> json){
    id = json['id'];
    image = json['image'];
  }

}
class ProductsModel{

  late int id;
  late dynamic price;
  late dynamic oldPrice;
  late dynamic discount;
  late String image;
  late String name;
  late bool inFavorites;
  late bool inCart;

  ProductsModel.fromJson(Map<String,dynamic> json){
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }

}

 */