class EmployeeListResponse {
  String? message;
  int? status;
  List<Employee>? employees;

  EmployeeListResponse({this.message, this.status, this.employees});

  EmployeeListResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['response'] != null) {
      employees = <Employee>[];
      json['response'].forEach((v) {
        employees!.add(Employee.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    if (employees != null) {
      data['response'] = employees!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Employee {
  String? id;
  String? firstName;
  String? lastName;
  String? role;
  int? isSaved = 0;

  Employee({
    this.id,
    this.firstName,
    this.lastName,
    this.role,
    this.isSaved,
  });

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['employee_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    role = json['role'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['role'] = role;
    return data;
  }
}
