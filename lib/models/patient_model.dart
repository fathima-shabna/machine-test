class PatientModel {
  final int id;
  final String name;
  final String phone;
  final String address;
  final String dateNdTime;
  final String user;
  final List<PatientDetail> patientDetails;

  PatientModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.dateNdTime,
    required this.user,
    required this.patientDetails,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      dateNdTime: json['date_nd_time'] ?? '',
      user: json['user'] ?? '',
      patientDetails: (json['patientdetails_set'] as List? ?? [])
          .map((i) => PatientDetail.fromJson(i))
          .toList(),
    );
  }
}

class PatientDetail {
  final int id;
  final int male;
  final int female;
  final String treatmentName;

  PatientDetail({
    required this.id,
    required this.male,
    required this.female,
    required this.treatmentName,
  });

  factory PatientDetail.fromJson(Map<String, dynamic> json) {
    return PatientDetail(
      id: json['id'] ?? 0,
      male: json['male'] is int
          ? json['male']
          : int.tryParse(json['male']?.toString() ?? '0') ?? 0,
      female: json['female'] is int
          ? json['female']
          : int.tryParse(json['female']?.toString() ?? '0') ?? 0,
      treatmentName: json['treatment_name'] ?? '',
    );
  }
}

class PatientListResponse {
  final bool status;
  final String message;
  final List<PatientModel> patient;

  PatientListResponse({
    required this.status,
    required this.message,
    required this.patient,
  });

  factory PatientListResponse.fromJson(Map<String, dynamic> json) {
    return PatientListResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      patient: (json['patient'] as List? ?? [])
          .map((i) => PatientModel.fromJson(i))
          .toList(),
    );
  }
}
