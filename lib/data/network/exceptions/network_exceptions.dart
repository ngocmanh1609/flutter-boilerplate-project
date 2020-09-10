import 'package:equatable/equatable.dart';

class NetworkException extends Equatable implements Exception {
  String message;
  int statusCode;

  NetworkException({this.message, this.statusCode});

  @override
  List<Object> get props => [message, statusCode];
}

class AuthException extends NetworkException {
  AuthException({message, statusCode})
      : super(message: message, statusCode: statusCode);
}
