part of 'connection_monitoring_bloc.dart';

@immutable
sealed class ConnectionMonitoringState {}

final class ConnectionMonitoringInitial extends ConnectionMonitoringState {}

final class ConnectionMonitoringSynchronizing
    extends ConnectionMonitoringState {}

final class ConnectionMonitoringSynchronized
    extends ConnectionMonitoringState {}

final class ConnectionMonitoringSynchronizationFailed
    extends ConnectionMonitoringState {}

final class ConnectionMonitoringNoConnection
    extends ConnectionMonitoringState {}
