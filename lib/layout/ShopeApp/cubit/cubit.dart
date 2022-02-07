import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_section8/layout/ShopeApp/cubit/states.dart';
import 'package:learn_section8/models/categories_model.dart';
import 'package:learn_section8/models/change_favorites_model.dart';
import 'package:learn_section8/models/favorites_model.dart';
import 'package:learn_section8/models/home_model.dart';
import 'package:learn_section8/models/login_model.dart';
import 'package:learn_section8/modules/cateogries/cateogries_screen.dart';
import 'package:learn_section8/modules/favorites/favorites_screen.dart';
import 'package:learn_section8/modules/products/products_screen.dart';
import 'package:learn_section8/modules/settings/settinges_screen.dart';
import 'package:learn_section8/shared/components/constanses.dart';
import 'package:learn_section8/shared/network/end_points.dart';
import 'package:learn_section8/shared/network/remote/dio_helper.dart';

class ShopeCubit extends Cubit<ShopeStates> {
  ShopeCubit() : super(ShopeInitialStates());

  static ShopeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreen = [
    ProductsScreen(),
    CateogriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void ChangeCurrentIndex(int index) {
    currentIndex = index;
    emit(ShopeChangeBottomNavStates());
  }

  HomeModel? homeModel;

  Map<int, bool> favorite = {};

  void getHomeData() {
    emit(ShopeLoadingHomeDataStates());

    DioHelper.getData(url: HOME, token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);

      // printFullText(homeModel!.data!.banners[0].image);
      // print('Hello Boy');
      // print(homeModel!.status);
      // printFullText(homeModel!.data!.products[0].name);

      homeModel!.data!.products.forEach((element) {
        favorite.addAll({element.id: element.inFavorites});
      });
      //print(favorite);

      emit(ShopeSuccesHomeDataStates());
    }).catchError((error) {
      //print(error.toString());
      emit(ShopeErrorHomeDataStates());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategories() {
    DioHelper.getData(url: GET_CATEGORIES, token: token).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);

      // print('Vary Good Category');
      // print(' Hahahah = ${categoriesModel!.status}');
      // print(categoriesModel!.data!.data[0].name);
      emit(ShopeSuccesCategoriesStates());
    }).catchError((error) {
      //print('Error Categ = ${error.toString()}');
      emit(ShopeErrorCategoriesStates());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int product_id) {
    favorite[product_id] = !favorite[product_id]!;

    emit(ShopeChangeFavoritesStates());

    DioHelper.postData(
            url: FAVORITES, data: {'product_id': product_id}, token: token)
        .then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      // print('Favorites');
      // print(value.data);

      if (!changeFavoritesModel!.state) {
        favorite[product_id] = !favorite[product_id]!;
      } else {
        getFavorites();
      }

      emit(ShopeSuccesChangeFavoritesStates(changeFavoritesModel!));
    }).catchError((error) {
      favorite[product_id] = !favorite[product_id]!;
      emit(ShopeErrorChangeFavoritesStates());
    });
  }

  FavoritesModel? favoritesModel;

  void getFavorites() {
    emit(ShopeLoadingGetFavoritesStates());

    DioHelper.getData(url: FAVORITES, token: token).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);

      // print('Vary Good Favorite');
      // print(' Favorite = ${favoritesModel!.status}');
      // print(favoritesModel!.data!.data);
      emit(ShopeSuccesGetFavoritesStates());
    }).catchError((error) {
      //print('Error Favorite = ${error.toString()}');
      emit(ShopeErrorGetFavoritesStates());
    });
  }

  late ShopLoginModel userModel;

  void getUserData() {
    emit(ShopeLoadingUserDataStates());

    DioHelper.getData(
        url: PROFILE,
        token: token
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);

      print('Vary Good userData');
      printFullText(userModel.data!.name!);

      emit(ShopeSuccesUserDataStates(userModel));
    }).catchError((error) {
      print(error.toString());
      emit(ShopeErrorUserDataStates());
    });
  }

  void updateUserData({
  required String name,
    required String phone,
    required String email,
}) {
    emit(ShopeLoadingUpdateUserStates());

    DioHelper.putData(
        url: UPDATE_PROFILE,
        token: token,
        data: {
          'name' : name,
          'phone' : phone,
          'email' : email
        }
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);

      print('Vary Good Update userData');
      printFullText(userModel.status.toString());

      emit(ShopeSuccesUpdateUserStates(userModel));
    }).catchError((error) {
      print(error.toString());
      emit(ShopeErrorUpdateUserStates());
    });

  }

}
