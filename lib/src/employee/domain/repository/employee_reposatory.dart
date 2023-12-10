import 'package:dartz/dartz.dart';

import '../../../../core/common/models/failure.dart';
import '../../data/models/employee_model.dart';

abstract class EmployeeRepository {
  Future<Either<Failure, List<Employee>>> getEmployeeList({
    required String role,
  });
}
