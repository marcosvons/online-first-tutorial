import 'package:todo_offline_first_tutorial/lib.dart';
import 'package:dartz/dartz.dart';

class DataSynchronizationRepository {
  const DataSynchronizationRepository({
    required this.localStorageService,
    required this.remoteService,
  });

  final LocalStorageService localStorageService;
  final RemoteService remoteService;

  Future<bool> doNeedToSynchronize() async {
    try {
      final remoteOperations = localStorageService.getCacheRemoteOperations();
      return remoteOperations.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<Either<Failure, Unit>> synchronizeData() async {
    try {
      final remoteOperations = localStorageService.getCacheRemoteOperations();
      for (final remoteOperation in remoteOperations) {
        await remoteService.synchronize(remoteOperation);
        await localStorageService.removeCacheRemoteOperation(remoteOperation);
      }
      return const Right(unit);
    } catch (e) {
      return Left(ParseYourErrorHere());
    }
  }
}
