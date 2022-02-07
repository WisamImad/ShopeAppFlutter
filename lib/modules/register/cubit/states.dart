import 'package:learn_section8/models/login_model.dart';

abstract class ShopeRegisterStates{}

class ShopeRegisterInitialStates extends ShopeRegisterStates{}

class ShopeRegisterLoadingStates extends ShopeRegisterStates{}

class ShopeRegisterSucessStates extends ShopeRegisterStates{
  final ShopLoginModel registerModel;

  ShopeRegisterSucessStates(this.registerModel);
}

class ShopeRegisterErrorStates extends ShopeRegisterStates{}

class ShopChangePasswordVisibilityState extends ShopeRegisterStates{}