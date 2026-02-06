class TreatmentModel {
  final int id;
  final String name;
  final String duration;
  final String price;
  final String? branch;

  TreatmentModel({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
    this.branch,
  });

  factory TreatmentModel.fromJson(Map<String, dynamic> json) {
    return TreatmentModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      duration: json['duration'] ?? '',
      price: json['price'] ?? '0',
      branch: json['branch'],
    );
  }
}

class TreatmentListResponse {
  final bool status;
  final String message;
  final List<TreatmentModel> treatments;

  TreatmentListResponse({
    required this.status,
    required this.message,
    required this.treatments,
  });

  factory TreatmentListResponse.fromJson(Map<String, dynamic> json) {
    return TreatmentListResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      treatments: (json['treatments'] as List? ?? [])
          .map((i) => TreatmentModel.fromJson(i))
          .toList(),
    );
  }
}
