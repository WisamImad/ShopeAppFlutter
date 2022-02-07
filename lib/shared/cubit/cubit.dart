import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_section8/shared/cubit/states.dart';
import 'package:learn_section8/shared/network/local/cache_helper.dart';
import 'package:sqflite/sqflite.dart';


class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [

  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarStates());
  }

  // Instance of 'Future<String>'

  // Future<String> getName() async {
  //   return 'Ahmed Ali';
  // }

  Database? database;
  List<Map> newTask = [];
  List<Map> doneTask = [];
  List<Map> archivedTask = [];

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        // id integer
        // title String
        // date String
        // time String
        // status String

        print('database created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFormDatabase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseStates());
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database!.transaction((txn) async {
      txn.rawInsert(
        'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
      ).then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseStates());
        getDataFormDatabase(database);
      }).catchError((error) {
        print('Error When Inserting New Record ${error.toString()}');
      });
    });
  }

  getDataFormDatabase(database){

    newTask = [];
    doneTask = [];
    archivedTask = [];

    emit(AppGetDatabaseLoadingStates());
    database.rawQuery('SELECT * FROM tasks').then((value) {

      value.forEach((element){
        if(element['status'] == 'new'){
          newTask.add(element);
        }else if(element['status'] == 'done'){
          doneTask.add(element);
        }else archivedTask.add(element);
      });

      emit(AppGetDatabaseStates());
    });
  }

  void updateData({
  required String states,
  required int id,
})async{
    database!.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$states', id]
    ).then((value) {
      getDataFormDatabase(database);
      emit(AppUpdateDatabaseStates());
    });

  }

  void deleteData({
    required int id,
  })async{
    database!.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id]
    ).then((value) {
      getDataFormDatabase(database);
      emit(AppDeleteDatabaseStates());
    });

  }


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
