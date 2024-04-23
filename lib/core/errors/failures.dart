sealed class Failure {
  final String message;

  Failure({this.message = ''});
}

final class ServerFailure extends Failure {
  ServerFailure({String message = 'Something in our servers went wrong'})
      : super(message: message);
}

final class CacheFailure extends Failure {
  CacheFailure({String message = 'We couldn\'t save the changes locally'})
      : super(message: message);
}

final class UnknownFailure extends Failure {
  UnknownFailure({String message = 'We have no idea what happened'})
      : super(message: message);
}

final class TimeoutFailure extends Failure {
  TimeoutFailure({String message = 'The request took too long to complete'})
      : super(message: message);
}

final class NoInternetFailure extends Failure {
  NoInternetFailure({String message = 'You are not connected to the internet'})
      : super(message: message);
}

final class JsonDeserializationFailure extends Failure {
  JsonDeserializationFailure({String message = 'We couldn\'t parse the data'})
      : super(message: message);
}

final class UnauthorizedFailure extends Failure {
  UnauthorizedFailure({String message = 'You are not authorized to do this'})
      : super(message: message);
}

final class ParseYourErrorHere extends Failure {}
