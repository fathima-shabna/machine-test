class BranchModel {
  final int id;
  final String name;
  final String address;
  final String phone;
  final String location;

  BranchModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.location,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] ?? '',
    );
  }
}

class BranchListResponse {
  final bool status;
  final String message;
  final List<BranchModel> branches;

  BranchListResponse({
    required this.status,
    required this.message,
    required this.branches,
  });

  factory BranchListResponse.fromJson(Map<String, dynamic> json) {
    return BranchListResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      branches: (json['branches'] as List? ?? [])
          .map((i) => BranchModel.fromJson(i))
          .toList(),
    );
  }
}
