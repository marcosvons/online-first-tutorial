part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent {}

final class AddToDo extends TodoEvent {
  final ToDo todo;

  AddToDo(this.todo);
}

final class DeleteToDo extends TodoEvent {
  final String id;

  DeleteToDo(this.id);
}

final class EditToDo extends TodoEvent {
  final ToDo todo;

  EditToDo(this.todo);
}

final class ListenToToDosInCache extends TodoEvent {}

final class LoadToDos extends TodoEvent {}
