import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/treatment_model.dart';
import '../models/branch_model.dart';

class BookingController extends GetxController {
  final ApiService _apiService = ApiService();

  var treatments = <TreatmentModel>[].obs;
  var branches = <BranchModel>[].obs;
  var isLoading = false.obs;

  // Selected data for registration
  var selectedTreatments = <int>[].obs;
  var maleTreatments = <int>[].obs;
  var femaleTreatments = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    try {
      isLoading.value = true;
      await Future.wait([fetchTreatments(), fetchBranches()]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTreatments() async {
    final response = await _apiService.get('/TreatmentList');
    final res = TreatmentListResponse.fromJson(response.data);
    if (res.status) {
      treatments.value = res.treatments;
    }
  }

  Future<void> fetchBranches() async {
    final response = await _apiService.get('/BranchList');
    final res = BranchListResponse.fromJson(response.data);
    if (res.status) {
      branches.value = res.branches;
    }
  }

  Future<bool> registerPatient({
    required String name,
    required String executive,
    required String payment,
    required String phone,
    required String address,
    required double total,
    required double discount,
    required double advance,
    required double balance,
    required DateTime dateTime,
    required int branchId,
  }) async {
    try {
      isLoading.value = true;

      final dateStr = DateFormat('dd/MM/yyyy-hh:mm a').format(dateTime);

      final formData = {
        'name': name,
        'excecutive': executive,
        'payment': payment,
        'phone': phone,
        'address': address,
        'total_amount': total.toString(),
        'discount_amount': discount.toString(),
        'advance_amount': advance.toString(),
        'balance_amount': balance.toString(),
        'date_nd_time': dateStr,
        'id': '',
        'male': maleTreatments.join(','),
        'female': femaleTreatments.join(','),
        'branch': branchId.toString(),
        'treatments': selectedTreatments.join(','),
      };

      final response = await _apiService.post('/PatientUpdate', data: formData);

      return response.data['status'] ?? false;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
