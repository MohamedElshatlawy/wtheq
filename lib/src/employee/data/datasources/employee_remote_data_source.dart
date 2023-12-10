import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

import '../../../../core/common/models/failure.dart';
import '../../../../core/util/network_service.dart';
import '../models/employee_model.dart';

abstract class EmployeeRemoteDataSource {
  Future<Either<Failure, List<Employee>>> getEmployeeList({
    required String role,
  });
}

class EmployeeRemoteDataSourceImpl implements EmployeeRemoteDataSource {
  final NetworkService networkService;

  EmployeeRemoteDataSourceImpl(this.networkService);
  @override
  Future<Either<Failure, List<Employee>>> getEmployeeList({
    required String role,
  }) async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/json/employee_info.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      final response = EmployeeListResponse.fromJson(jsonMap);
      List<Employee> employeeList = [];
      for (var v in response.employees!) {
        if (v.role == role) {
          employeeList.add(v);
        }
      }
      return Right(employeeList);
    } catch (e) {
      return Left(Failure('Something went wrong'));
    }
  }
}
