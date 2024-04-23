import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_offline_first_tutorial/lib.dart';

class LocalStorageService {
  const LocalStorageService({
    required Box<String> hiveBox,
  }) : _hiveBox = hiveBox;

  final Box<String> _hiveBox;

  Stream<List<ToDo>> get todoList =>
      _hiveBox.watch(key: 'ToDoList').map<List<ToDo>>(
        (event) {
          try {
            final jsonStr = event.value as String?;

            if (jsonStr == null) return [];

            final result = jsonDecode(jsonStr) as List<dynamic>;

            return result
                .map((json) => ToDo.fromJson(json as Map<String, dynamic>))
                .toList();
          } catch (e) {
            throw CacheException();
          }
        },
      ).startWith(getCacheToDoList());

  Future<void> addToDoToCacheList(ToDo toDo) {
    try {
      final toDoList = getCacheToDoList()..add(toDo);
      return setCacheToDoList(toDoList);
    } catch (e) {
      throw CacheException();
    }
  }

  List<ToDo> getCacheToDoList() {
    try {
      final jsonStr = _hiveBox.get('ToDoList');

      if (jsonStr == null) return [];

      final result = jsonDecode(jsonStr) as List<dynamic>;

      return result
          .map((json) => ToDo.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException();
    }
  }

  Future<void> removeCacheToDoList() async {
    try {
      return await _hiveBox.delete('ToDoList');
    } catch (e) {
      throw CacheException();
    }
  }

  Future<void> updateToDoInCacheList(ToDo toDo) {
    try {
      final toDoList = getCacheToDoList();
      final index =
          toDoList.indexWhere((cachedToDo) => cachedToDo.id == toDo.id);
      toDoList[index] = toDo;

      return setCacheToDoList(toDoList);
    } catch (e) {
      throw CacheException();
    }
  }

  Future<void> removeCacheToDoListById(String id) {
    try {
      final toDoList = getCacheToDoList();
      final index = toDoList.indexWhere((toDo) => toDo.id == id);
      toDoList.removeAt(index);

      return setCacheToDoList(toDoList);
    } catch (e) {
      throw CacheException();
    }
  }

  Future<void> setCacheToDoList(List<ToDo> toDoList) async {
    try {
      await _hiveBox.put(
        'ToDoList',
        jsonEncode(toDoList),
      );
    } catch (e) {
      throw CacheException();
    }
  }

  Future<void> addCacheRemoteOperation(RemoteOperation remoteOperation) async {
    try {
      final remoteOperations = getCacheRemoteOperations()..add(remoteOperation);
      return await setCacheRemoteOperations(remoteOperations);
    } catch (e) {
      throw CacheException();
    }
  }

  List<RemoteOperation> getCacheRemoteOperations() {
    try {
      final jsonStr = _hiveBox.get('CachedRemoteOperations');

      if (jsonStr == null) return [];

      final result = jsonDecode(jsonStr) as List<dynamic>;

      return result
          .map((json) => RemoteOperation.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException();
    }
  }

  Future<void> removeCacheRemoteOperations() async {
    try {
      return await _hiveBox.delete('CachedRemoteOperations');
    } catch (e) {
      throw CacheException();
    }
  }

  Future<void> removeCacheRemoteOperation(RemoteOperation remoteOperation) {
    try {
      final remoteOperations = getCacheRemoteOperations();
      final index = remoteOperations.indexWhere(
          (cacheRemoteOperation) => cacheRemoteOperation == remoteOperation);
      remoteOperations.removeAt(index);

      return setCacheRemoteOperations(remoteOperations);
    } catch (e) {
      throw CacheException();
    }
  }

  Future<void> setCacheRemoteOperations(
      List<RemoteOperation> remoteOperations) async {
    try {
      await _hiveBox.put(
        'CachedRemoteOperations',
        jsonEncode(remoteOperations),
      );
    } catch (e) {
      throw CacheException();
    }
  }
}
