import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_section8/models/login_model.dart';
import 'package:learn_section8/modules/register/cubit/states.dart';
import 'package:learn_section8/shared/network/end_points.dart';
import 'package:learn_section8/shared/network/remote/dio_helper.dart';

class ShopeRegisterCubit extends Cubit<ShopeRegisterStates> {
  ShopeRegisterCubit() : super(ShopeRegisterInitialStates());

  static ShopeRegisterCubit get(context) => BlocProvider.of(context);

  late ShopLoginModel model;

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(ShopeRegisterLoadingStates());

    DioHelper.postData(
        url: REGISTER,
        data: {
          'name' : name,
          'email' : email,
          'password' : password,
          'phone' : phone
        }
        ).then((value) {
          model = ShopLoginModel.fromJson(value.data);
          print('Register True');
          emit(ShopeRegisterSucessStates(model));
    }).catchError((error){
      print(error.toString());
      emit(ShopeRegisterErrorStates());
    });

  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility()
  {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined ;

    emit(ShopChangePasswordVisibilityState());
  }

}
