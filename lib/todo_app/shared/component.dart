import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/shared/cubit/cubit.dart';

Widget defaultFormField(
        {@required TextEditingController controller,
        @required TextInputType type,
        Function onChane,
        Function onTap,
        Function onSubmitted,
        @required Function validate,
        @required String label,
        @required String hint,
        @required IconData prefix,
        IconData suffix,
        bool isPassword = false,
        bool isClickable = true,
        Function suffixPressed,
        bool readOnly = false}) =>
    TextFormField(
      readOnly: readOnly,
      obscureText: isPassword,
      controller: controller,
      keyboardType: type,
      onChanged: onChane,
      onTap: onTap,
      enabled: isClickable,
      onFieldSubmitted: onSubmitted,
      validator: validate,
      decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(prefix),
          suffixIcon: suffix != null
              ? IconButton(
                  icon: Icon(suffix),
                  onPressed: suffixPressed,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

Widget buildTaskItem(Map model, context) {
  return Dismissible(
    key: Key(model['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text('${model['time']}'),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model['title']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${model['date']}',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 15,
          ),
          IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: 'done', id: model['id']);
              },
              icon: Icon(
                Icons.check_box,
                color: Colors.green,
              )),
          IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: 'archive', id: model['id']);
              },
              icon: Icon(
                Icons.archive,
                color: Colors.black26,
              )),
        ],
      ),
    ),
    onDismissed: (direction) {
      AppCubit.get(context).deleteData(id: model['id']);
    },
  );
}

Widget tasksBuilder({
  @required List<Map> tasks,
}) =>
    ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) => ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
          separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsetsDirectional.only(start: 20),
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey[300],
                ),
              ),
          itemCount: tasks.length),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 100,
              color: Colors.grey,
            ),
            Text(
              'No Tasks Yet , Please Add Some Tasks',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
