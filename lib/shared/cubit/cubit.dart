import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/shared/cubit/states.dart';
import '../../todo_app/archieve/archived_screen.dart';
import '../../todo_app/done/done_screen.dart';
import '../../todo_app/task/task_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [
    TaskScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];

  List<String> titles = [
    'New Task',
    'Done Task',
    'Archived Task',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavState());
  }

  Database database;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('DataBase Created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY ,title TEXT ,date TEXT ,time TEXT ,status TEXT  )')
            .then((value) {
          print('Inserted Created');
        }).catchError((error) {
          print('Error when creating table $error.toString()');
        });
      },
      onOpen: (database) {
        // ببعت الداتا بيز عشان بيبقي لسه مكتملش
        getDataFromDataBase(database);
        print('DataBase Opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDataBaseState());
    });
  }

  insertToDatabase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks (title,time,date,status) VALUES ("$title","$time","$date","new")')
          .then((value) {
        print('Inserted to db');
        emit(AppInsertDataBaseState());

        getDataFromDataBase(database);
      }).catchError((error) {
        print('Error when Insert  db $error.toString()');
      });
      return null;
    });
  }

  void getDataFromDataBase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDataBaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
      emit(AppGetDataBaseState());
    });
  }

  void updateData({
    @required String status,
    @required int id,
  }) async {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDataBase(database);
      emit(AppUpdateDataBaseLoadingState());
    });
  }

  void deleteData({
    @required int id,
  }) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDataBase(database);
      emit(AppDeleteDataBaseLoadingState());
    });
  }

  bool isBottomSheet = false;
  IconData fabIcon = Icons.add;

  void changeBottomSheetState({
    @required bool isShow,
    @required IconData icon,
  }) {
    isBottomSheet = isShow;
    fabIcon = icon;

    emit(AppChangeBottomSheetState());
  }
}
