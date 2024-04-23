part of 'connection_monitoring_bloc.dart';

@immutable
sealed class ConnectionMonitoringEvent {}

final class MonitorConnectionChanges extends ConnectionMonitoringEvent {}

final class CheckConnection extends ConnectionMonitoringEvent {}

