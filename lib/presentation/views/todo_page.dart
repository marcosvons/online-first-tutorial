import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_offline_first_tutorial/lib.dart';
import 'package:todo_offline_first_tutorial/presentation/bloc/connection_monitoring_bloc.dart';

class ToDoPage extends StatelessWidget {
  const ToDoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectionMonitoringBloc, ConnectionMonitoringState>(
      listener: (context, state) {
        return switch (state) {
          ConnectionMonitoringSynchronized() =>
            context.read<TodoBloc>().add(LoadToDos()),
          ConnectionMonitoringNoConnection() =>
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'No internet connection',
                  style: TextStyle(color: Colors.red),
                ),
                backgroundColor: Colors.grey.shade800,
              ),
            ),
          ConnectionMonitoringSynchronizing() =>
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Synchronizing data',
                    style: TextStyle(color: Colors.yellow)),
                backgroundColor: Colors.grey.shade800,
              ),
            ),
          ConnectionMonitoringSynchronizationFailed() =>
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Failed to synchronize data',
                    style: TextStyle(color: Colors.red)),
                backgroundColor: Colors.grey.shade800,
              ),
            ),
          ConnectionMonitoringInitial() => null,
        };
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Offline First Tutorial'),
            backgroundColor: Colors.deepPurple,
          ),
          body: const TodosBody(),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: FloatingActionButton(
              onPressed: () => showAdaptiveDialog(
                context: context,
                builder: (context) => ToDoDialog(
                  onPressed: (title) {
                    context.read<TodoBloc>().add(
                          AddToDo(
                            ToDo(
                              id: UniqueKey().toString(),
                              title: title,
                              isCompleted: false,
                            ),
                          ),
                        );
                    Navigator.of(context).pop();
                  },
                ),
              ),
              child: const Icon(Icons.add),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }
}
