import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_offline_first_tutorial/lib.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc(this.todoRepository) : super(TodosInitial()) {
    on<AddToDo>(_onAddToDo);
    on<DeleteToDo>(_onDeleteToDo);
    on<EditToDo>(_onEditToDo);
    on<ListenToToDosInCache>(_onListenToToDosInCache);
    on<LoadToDos>(_onLoadTodos);
  }

  final ToDoRepository todoRepository;

  FutureOr<void> _onListenToToDosInCache(
    ListenToToDosInCache event,
    Emitter<TodoState> emit,
  ) async {
    await emit
        .forEach(todoRepository.todoList, onData: (todos) => TodosLoaded(todos))
        .onError((error, stackTrace) => TodosError(CacheFailure()));
  }

  FutureOr<void> _onAddToDo(
    AddToDo event,
    Emitter<TodoState> emit,
  ) async {
    final possibleSuccessOrFailure =
        await todoRepository.createToDo(event.todo);
    possibleSuccessOrFailure.fold(
      (failure) => emit(TodosError(failure)),
      (_) {},
    );
  }

  FutureOr<void> _onDeleteToDo(
      DeleteToDo event, Emitter<TodoState> emit) async {
    final possibleSuccessOrFailure = await todoRepository.deleteTodo(event.id);
    possibleSuccessOrFailure.fold(
      (failure) => emit(TodosError(failure)),
      (_) {},
    );
  }

  FutureOr<void> _onEditToDo(EditToDo event, Emitter<TodoState> emit) async {
    final possibleSuccessOrFailure =
        await todoRepository.updateToDo(toDo: event.todo);
    possibleSuccessOrFailure.fold(
      (failure) => emit(TodosError(failure)),
      (_) {},
    );
  }

  FutureOr<void> _onLoadTodos(LoadToDos event, Emitter<TodoState> emit) async {
    emit(TodosLoading());
    final possibleSuccesOrFailure = await todoRepository.getTodos();
    possibleSuccesOrFailure.fold(
      (failure) => emit(TodosError(failure)),
      (_) {},
    );
  }
}
