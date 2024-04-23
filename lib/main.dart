import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_offline_first_tutorial/lib.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_offline_first_tutorial/presentation/bloc/connection_monitoring_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await injectDependencies();
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ConnectionMonitoringBloc(
            dataSynchronizationRepository: sl(),
            connectivity: sl(),
            internetConnectionChecker: sl(),
          )..add(
              MonitorConnectionChanges(),
            ),
        ),
        BlocProvider(
          create: (context) => TodoBloc(sl())
            ..add(LoadToDos())
            ..add(ListenToToDosInCache()),
        ),
      ],
      child: MaterialApp(
        title: 'ToDo Offline First Tutorial',
        theme: ThemeData.dark(),
        home: const ToDoPage(),
      ),
    );
  }
}
