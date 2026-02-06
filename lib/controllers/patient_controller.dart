import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/patient_model.dart';

class PatientController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<PatientModel> _patients = [];
  List<PatientModel> get patients => _patients;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isEmpty = false;
  bool get isEmpty => _isEmpty;

  Future<void> fetchPatients() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.get('/PatientList');
      print(response.data);
      final patientListResponse = PatientListResponse.fromJson(response.data);

      if (patientListResponse.status) {
        _patients = patientListResponse.patient;
        _isEmpty = _patients.isEmpty;
      }
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshPatients() async {
    await fetchPatients();
  }
}
