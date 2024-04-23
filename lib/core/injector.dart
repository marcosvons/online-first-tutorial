// ignore_for_file: public_member_api_docs

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:todo_offline_first_tutorial/lib.dart';

GetIt sl = GetIt.instance;

Future<void> injectDependencies() async {
  final hiveBox = await Hive.openBox<String>('LOCAL_STORAGE');

  sl
    ..registerLazySingleton(() => Dio())
    ..registerLazySingleton(() => hiveBox)
    ..registerLazySingleton(() => Connectivity())
    ..registerLazySingleton(() => InternetConnectionChecker())
    ..registerLazySingleton(() => LocalStorageService(hiveBox: sl()))
    ..registerLazySingleton(() => RemoteService(sl()))
    ..registerLazySingleton(() => ToDoRepository(
          internetConnectionChecker: sl(),
          localStorageService: sl(),
          remoteService: sl(),
        ))
    ..registerLazySingleton(() => DataSynchronizationRepository(
          localStorageService: sl(),
          remoteService: sl(),
        ));
}
