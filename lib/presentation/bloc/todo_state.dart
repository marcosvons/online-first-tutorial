part of 'todo_bloc.dart';

@immutable
sealed class TodoState {}

final class TodosInitial extends TodoState {}

final class TodosLoading extends TodoState {}

final class TodosLoaded extends TodoState {
  final List<ToDo> todos;

  TodosLoaded(this.todos);
}

final class TodosError extends TodoState {
  final Failure failure;

  TodosError(this.failure);
}
