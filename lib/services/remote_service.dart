import 'package:todo_offline_first_tutorial/lib.dart';
import 'package:dio/dio.dart';

class RemoteService {
  const RemoteService(Dio dio) : _dio = dio;

  final Dio _dio;

  Future<void> createTodo(ToDo toDo) async {
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.todos,
      data: toDo.toJson(),
    );

    if (response.statusCode != 201) {
      parseErrorCodeToException(response.statusCode ?? 0);
    }
  }

  Future<void> updateTodo(ToDo toDo) async {
    final response =
        await _dio.put<Map<String, dynamic>>('${Endpoints.todos}${toDo.id}',
            data: toDo.toJson(),
            options: Options(
              contentType: 'application/json',
            ));

    if (response.statusCode != 200) {
      parseErrorCodeToException(response.statusCode ?? 0);
    }
  }

  Future<void> deleteTodo(String id) async {
    final response = await _dio.delete<Map<String, dynamic>>(
      '${Endpoints.todos}$id',
    );

    if (response.statusCode != 200) {
      parseErrorCodeToException(response.statusCode ?? 0);
    }
  }

  Future<List<ToDo>> getTodos() async {
    final response = await _dio.get<List<dynamic>>(
      Endpoints.todos,
    );

    if (response.statusCode != 200) {
      parseErrorCodeToException(response.statusCode ?? 0);
    }

    return response.data!
        .map((json) => ToDo.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> synchronize(RemoteOperation remoteOperation) async {
    Response<dynamic> response;
    try {
      final methods = {
        HTTPMethod.get: _dio.get<Map<String, dynamic>>,
        HTTPMethod.post: _dio.post<Map<String, dynamic>>,
        HTTPMethod.put: _dio.put<Map<String, dynamic>>,
        HTTPMethod.delete: _dio.delete<Map<String, dynamic>>,
      };

      var method = methods[remoteOperation.method];
      if (method != null) {
        response = await method(
          remoteOperation.endpoint,
          data: remoteOperation.body,
        );
      } else {
        throw UnknownNetworkException();
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw TimeoutException();
      } else if (e.type == DioExceptionType.connectionError) {
        throw ConnectionErrorException();
      } else {
        throw UnknownNetworkException();
      }
    } catch (e) {
      throw UnknownNetworkException();
    }

    if (response.statusCode != 200) {
      parseErrorCodeToException(response.statusCode ?? 0);
    }
  }
}

void parseErrorCodeToException(int statusCode) {
  switch (statusCode) {
    case 401:
      throw UnauthorizedException();
    default:
      throw UnknownException();
  }
}
