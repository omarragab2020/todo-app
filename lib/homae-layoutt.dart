import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/shared/cubit/cubit.dart';
import 'package:flutter_app7/shared/cubit/states.dart';
import 'package:flutter_app7/todo_app/shared/component.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class BottomNavigation extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDataBaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDataBaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
                child: Icon(cubit.fabIcon),
                onPressed: () {
                  if (cubit.isBottomSheet) {
                    if (formKey.currentState.validate()) {
                      cubit.insertToDatabase(
                          title: titleController.text,
                          time: timeController.text,
                          date: dateController.text);
                    }
                  } else {
                    scaffoldKey.currentState
                        .showBottomSheet(
                            (context) => Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.all(20),
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        defaultFormField(
                                            readOnly: false,
                                            controller: titleController,
                                            type: TextInputType.text,
                                            validate: (String value) {
                                              if (value.isEmpty) {
                                                return 'title must be not empty';
                                              }
                                              return null;
                                            },
                                            label: 'task title',
                                            prefix: Icons.title),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        defaultFormField(
                                            readOnly: true,
                                            controller: timeController,
                                            type: TextInputType.datetime,
                                            onTap: () {
                                              showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                              ).then((value) {
                                                timeController.text =
                                                    value.format(context);
                                                print(value.format(context));
                                              });
                                            },
                                            validate: (String value) {
                                              if (value.isEmpty) {
                                                return 'time must be not empty';
                                              }
                                              return null;
                                            },
                                            label: 'time task',
                                            prefix: Icons.watch_later_outlined),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        defaultFormField(
                                            readOnly: true,
                                            controller: dateController,
                                            type: TextInputType.datetime,
                                            onTap: () {
                                              showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime.now(),
                                                      lastDate: DateTime.parse(
                                                          '2022-01-06'))
                                                  .then((value) {
                                                print(DateFormat.yMMMd()
                                                    .format(value));
                                                dateController.text =
                                                    DateFormat.yMMMd()
                                                        .format(value);
                                              });
                                            },
                                            validate: (String value) {
                                              if (value.isEmpty) {
                                                return 'date must be not empty';
                                              }
                                              return null;
                                            },
                                            label: 'date task',
                                            prefix: Icons.calendar_today),
                                      ],
                                    ),
                                  ),
                                ),
                            elevation: 20)
                        .closed
                        .then((value) {
                      cubit.changeBottomSheetState(
                          isShow: false, icon: Icons.edit);
                    });

                    cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                  }
                }),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                AppCubit.get(context).changeIndex(index);
              },
              selectedFontSize: 15,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Task',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline_outlined),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
