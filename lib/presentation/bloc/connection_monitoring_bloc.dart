// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:todo_offline_first_tutorial/lib.dart';

part 'connection_monitoring_event.dart';
part 'connection_monitoring_state.dart';

class ConnectionMonitoringBloc
    extends Bloc<ConnectionMonitoringEvent, ConnectionMonitoringState> {
  ConnectionMonitoringBloc({
    required DataSynchronizationRepository dataSynchronizationRepository,
    required Connectivity connectivity,
    required InternetConnectionChecker internetConnectionChecker,
  })  : _dataSynchronizationRepository = dataSynchronizationRepository,
        _connectivity = connectivity,
        _internetConnectionChecker = internetConnectionChecker,
        super(ConnectionMonitoringInitial()) {
    on<MonitorConnectionChanges>(_onMonitorConnectionChanges);
    on<CheckConnection>(_onCheckConnection);
  }
  final DataSynchronizationRepository _dataSynchronizationRepository;
  final Connectivity _connectivity;
  final InternetConnectionChecker _internetConnectionChecker;

  FutureOr<void> _onMonitorConnectionChanges(
    MonitorConnectionChanges event,
    Emitter<ConnectionMonitoringState> emit,
  ) async {
    final connectionStream = _connectivity.onConnectivityChanged;
    await emit.onEach(
      connectionStream,
      onData: (value) {
        add(CheckConnection());
      },
    );
  }

  FutureOr<void> _onCheckConnection(
    CheckConnection event,
    Emitter<ConnectionMonitoringState> emit,
  ) async {
    final hasInternetConnection =
        await _internetConnectionChecker.hasConnection;
    if (hasInternetConnection) {
      final needToSynchronize =
          await _dataSynchronizationRepository.doNeedToSynchronize();
      if (needToSynchronize) {
        emit(ConnectionMonitoringSynchronizing());
        final result = await _dataSynchronizationRepository.synchronizeData();
        result.fold(
          (failure) {
            return emit(ConnectionMonitoringSynchronizationFailed());
          },
          (_) {
            return emit(ConnectionMonitoringSynchronized());
          },
        );
      } else {
        return emit(ConnectionMonitoringSynchronized());
      }
    } else {
      return emit(
        ConnectionMonitoringNoConnection(),
      );
    }
  }
}
