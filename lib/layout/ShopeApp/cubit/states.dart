import 'package:learn_section8/models/change_favorites_model.dart';
import 'package:learn_section8/models/login_model.dart';

abstract class ShopeStates{}

class ShopeInitialStates extends ShopeStates{}

class ShopeChangeBottomNavStates extends ShopeStates{}

class ShopeLoadingHomeDataStates extends ShopeStates{}

class ShopeSuccesHomeDataStates extends ShopeStates{}

class ShopeErrorHomeDataStates extends ShopeStates{}

class ShopeLoadingCategoriesStates extends ShopeStates{}

class ShopeSuccesCategoriesStates extends ShopeStates{}

class ShopeErrorCategoriesStates extends ShopeStates{}

class ShopeChangeFavoritesStates extends ShopeStates{}

class ShopeSuccesChangeFavoritesStates extends ShopeStates{
  final ChangeFavoritesModel model;
  ShopeSuccesChangeFavoritesStates(this.model);
}

class ShopeErrorChangeFavoritesStates extends ShopeStates{}

class ShopeLoadingGetFavoritesStates extends ShopeStates{}

class ShopeSuccesGetFavoritesStates extends ShopeStates{}

class ShopeErrorGetFavoritesStates extends ShopeStates{}

class ShopeLoadingUserDataStates extends ShopeStates{}

class ShopeSuccesUserDataStates extends ShopeStates{
  final ShopLoginModel loginModel;

  ShopeSuccesUserDataStates(this.loginModel);
}

class ShopeErrorUserDataStates extends ShopeStates{}

class ShopeLoadingUpdateUserStates extends ShopeStates{}

class ShopeSuccesUpdateUserStates extends ShopeStates{
  final ShopLoginModel updateUserModel;

  ShopeSuccesUpdateUserStates(this.updateUserModel);
}

class ShopeErrorUpdateUserStates extends ShopeStates{}