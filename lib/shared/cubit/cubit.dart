import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_section8/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';


class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);




  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  Future<void> ChangeBottomSheetState({required bool isSheet, required IconData icon}) async {
    isBottomSheetShown = isSheet;
    fabIcon = icon;
    emit(AppChangeBottomSheetStates());
  }
/*
  bool isDark = false;
  void changeAppMode({bool? fromShared}){
    if(fromShared != null) {
      isDark = fromShared;
      emit(AppChangeModeStates());
    } else {
      isDark = !isDark;
      CacheHelper.putDataBool(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeModeStates());
      });
    }
  }

 */

}
