class RemoteOperation {
  final String endpoint;
  final HTTPMethod method;
  final Map<String, dynamic> body;

  RemoteOperation({
    required this.endpoint,
    required this.method,
    required this.body,
  });

  RemoteOperation copyWith({
    String? endpoint,
    HTTPMethod? method,
    Map<String, dynamic>? body,
  }) {
    return RemoteOperation(
      endpoint: endpoint ?? this.endpoint,
      method: method ?? this.method,
      body: body ?? this.body,
    );
  }

  factory RemoteOperation.fromJson(Map<String, dynamic> json) {
    return RemoteOperation(
      endpoint: json['endpoint'] as String,
      method: HTTPMethod.fromJson(json['method']),
      body: json['body'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'endpoint': endpoint,
      'method': HTTPMethod.toJson(method),
      'body': body,
    };
  }
}

enum HTTPMethod {
  get,
  post,
  put,
  delete;

  static String toJson(HTTPMethod method) {
    switch (method) {
      case HTTPMethod.get:
        return 'GET';
      case HTTPMethod.post:
        return 'POST';
      case HTTPMethod.put:
        return 'PUT';
      case HTTPMethod.delete:
        return 'DELETE';
    }
  }

  static HTTPMethod fromJson(String method) {
    switch (method) {
      case 'GET':
        return HTTPMethod.get;
      case 'POST':
        return HTTPMethod.post;
      case 'PUT':
        return HTTPMethod.put;
      case 'DELETE':
        return HTTPMethod.delete;
      default:
        throw Exception('Invalid HTTPMethod');
    }
  }
}
