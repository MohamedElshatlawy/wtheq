import 'package:dio/dio.dart';

class Failure extends DioError {
  final String code;

  Failure(this.code) : super(requestOptions: RequestOptions(path: ''));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Failure && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;
}
