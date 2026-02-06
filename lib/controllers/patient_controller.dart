import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/patient_model.dart';

class PatientController extends GetxController {
  final ApiService _apiService = ApiService();
  var patients = <PatientModel>[].obs;
  var isLoading = false.obs;
  var isEmpty = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    try {
      isLoading.value = true;
      final response = await _apiService.get('/PatientList');
      print(response.data);
      final patientListResponse = PatientListResponse.fromJson(response.data);

      if (patientListResponse.status) {
        patients.value = patientListResponse.patient;
        isEmpty.value = patients.isEmpty;
      }
    } catch (e) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshPatients() async {
    await fetchPatients();
  }
}
