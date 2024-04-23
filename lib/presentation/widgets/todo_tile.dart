import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_offline_first_tutorial/lib.dart';

class ToDoTile extends StatelessWidget {
  const ToDoTile({
    required this.todo,
    super.key,
  });

  final ToDo todo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(todo.title),
      leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (value) => context.read<TodoBloc>().add(
                EditToDo(
                  todo.copyWith(isCompleted: value),
                ),
              )),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            iconSize: 20,
            onPressed: () => showAdaptiveDialog(
              context: context,
              builder: (context) => ToDoDialog(
                initialValue: todo.title,
                onPressed: (title) {
                  context.read<TodoBloc>().add(
                        EditToDo(
                          todo.copyWith(
                            title: title,
                          ),
                        ),
                      );
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          IconButton(
              icon: const Icon(Icons.delete),
              iconSize: 20,
              onPressed: () => context.read<TodoBloc>().add(
                    DeleteToDo(
                      todo.id,
                    ),
                  )),
        ],
      ),
    );
  }
}
