import 'package:dartz/dartz.dart';

import '../../../../core/common/models/failure.dart';
import '../../data/models/employee_model.dart';
import '../repository/employee_reposatory.dart';

class EmployeeUseCase {
  final EmployeeRepository _employeeRepository;

  EmployeeUseCase(this._employeeRepository);

  Future<Either<Failure, List<Employee>>> call({
    required String role,
  }) async {
    return await _employeeRepository.getEmployeeList(
      role: role,
    );
  }
}
