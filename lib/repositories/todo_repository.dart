import 'package:dartz/dartz.dart';
import 'package:todo_offline_first_tutorial/lib.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ToDoRepository {
  const ToDoRepository({
    required this.localStorageService,
    required this.remoteService,
    required this.internetConnectionChecker,
  });

  final LocalStorageService localStorageService;
  final RemoteService remoteService;
  final InternetConnectionChecker internetConnectionChecker;

  Stream<List<ToDo>> get todoList => localStorageService.todoList;

  Future<Either<Failure, Unit>> getTodos() async {
    try {
      final hasInternetConnection =
          await internetConnectionChecker.hasConnection;
      if (hasInternetConnection) {
        final todos = await remoteService.getTodos();
        await localStorageService.setCacheToDoList(todos);
      }
      return const Right(unit);
    } catch (e) {
      return Left(ParseYourErrorHere());
    }
  }

  Future<Either<Failure, Unit>> createToDo(
    ToDo todo,
  ) async {
    try {
      await localStorageService.addToDoToCacheList(todo);
      final hasInternetConnection =
          await internetConnectionChecker.hasConnection;
      if (hasInternetConnection) {
        await remoteService.createTodo(todo);
      } else {
        await localStorageService.addCacheRemoteOperation(
          RemoteOperation(
            endpoint: Endpoints.todos,
            method: HTTPMethod.post,
            body: todo.toJson(),
          ),
        );
      }
      return const Right(unit);
    } catch (e) {
      return Left(ParseYourErrorHere());
    }
  }

  Future<Either<Failure, Unit>> deleteTodo(
    String id,
  ) async {
    try {
      await localStorageService.removeCacheToDoListById(id);
      final hasInternetConnection =
          await internetConnectionChecker.hasConnection;
      if (hasInternetConnection) {
        await remoteService.deleteTodo(id);
      } else {
        await localStorageService.addCacheRemoteOperation(
          RemoteOperation(
            endpoint: '${Endpoints.todos}/$id',
            method: HTTPMethod.delete,
            body: {},
          ),
        );
      }
      return const Right(unit);
    } catch (e) {
      return Left(ParseYourErrorHere());
    }
  }

  Future<Either<Failure, Unit>> updateToDo({
    required ToDo toDo,
  }) async {
    try {
      await localStorageService.updateToDoInCacheList(toDo);
      final hasInternetConnection =
          await internetConnectionChecker.hasConnection;
      if (hasInternetConnection) {
        await remoteService.updateTodo(toDo);
      } else {
        await localStorageService.addCacheRemoteOperation(
          RemoteOperation(
            endpoint: '${Endpoints.todos}/${toDo.id}',
            method: HTTPMethod.put,
            body: toDo.toJson(),
          ),
        );
      }
      return const Right(unit);
    } catch (e) {
      return Left(ParseYourErrorHere());
    }
  }
}
