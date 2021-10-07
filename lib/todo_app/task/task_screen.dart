import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/shared/cubit/cubit.dart';
import 'package:flutter_app7/shared/cubit/states.dart';
import 'package:flutter_app7/todo_app/shared/component.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).newTasks;
        return tasksBuilder(tasks: tasks);
      },
    );
  }
}
