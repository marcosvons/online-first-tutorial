import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_offline_first_tutorial/lib.dart';

class TodosBody extends StatelessWidget {
  const TodosBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: RefreshIndicator(
        onRefresh: () async => context.read<TodoBloc>().add(LoadToDos()),
        child: ListView(
          children: [
            const Text(
              'ToDo\'s',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                return switch (state) {
                  TodosInitial() =>
                    const Center(child: CircularProgressIndicator()),
                  TodosLoading() =>
                    const Center(child: CircularProgressIndicator()),
                  TodosLoaded(:List<ToDo> todos) => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: todos.length,
                      itemBuilder: (context, index) => ToDoTile(
                        todo: todos[index],
                      ),
                    ),
                  TodosError(:Failure failure) =>
                    Center(child: Text(parseFailureToString(failure))),
                };
              },
            ),
          ],
        ),
      ),
    );
  }
}

String parseFailureToString(Failure failure) {
  return switch (failure) {
    CacheFailure() => 'Cache Failure',
    ServerFailure() => 'Server Failure',
    UnknownFailure() => 'Unknown Failure',
    TimeoutFailure() => 'Timeout Failure',
    NoInternetFailure() => 'No Internet Failure',
    JsonDeserializationFailure() => 'Json Deserialization Failure',
    UnauthorizedFailure() => 'Unauthorized Failure',
    ParseYourErrorHere() => 'Parse Your Error Here',
  };
}
