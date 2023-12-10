import 'package:dartz/dartz.dart';
import 'package:wteq_demo/src/employee/data/models/employee_model.dart';

import '../../../../core/common/models/failure.dart';
import '../../../../core/util/network/network_info.dart';
import '../../domain/repository/employee_reposatory.dart';
import '../datasources/employee_remote_data_source.dart';

class EmployeeRepositoryImp implements EmployeeRepository {
  final EmployeeRemoteDataSource dataSource;
  final NetworkInfo networkInfo;

  EmployeeRepositoryImp({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Employee>>> getEmployeeList(
      {required String role}) async {
    // if (await networkInfo.isConnected) {
    return await dataSource.getEmployeeList(role: role);
    // } else {
    //   throw Exception('No Internet Connection');
    // }
  }
}
