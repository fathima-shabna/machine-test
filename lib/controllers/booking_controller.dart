import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as dio;
import '../services/api_service.dart';
import '../models/treatment_model.dart';
import '../models/branch_model.dart';

class BookingController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<TreatmentModel> _treatments = [];
  List<TreatmentModel> get treatments => _treatments;

  List<BranchModel> _branches = [];
  List<BranchModel> get branches => _branches;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Selected data for registration
  final List<int> _selectedTreatments = [];
  List<int> get selectedTreatments => _selectedTreatments;

  final List<int> _maleTreatments = [];
  List<int> get maleTreatments => _maleTreatments;

  final List<int> _femaleTreatments = [];
  List<int> get femaleTreatments => _femaleTreatments;

  Future<void> fetchInitialData() async {
    try {
      _isLoading = true;
      notifyListeners();
      await Future.wait([fetchTreatments(), fetchBranches()]);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTreatments() async {
    final response = await _apiService.get('/TreatmentList');
    final res = TreatmentListResponse.fromJson(response.data);
    if (res.status) {
      _treatments = res.treatments;
      notifyListeners();
    }
  }

  Future<void> fetchBranches() async {
    final response = await _apiService.get('/BranchList');
    final res = BranchListResponse.fromJson(response.data);
    if (res.status) {
      _branches = res.branches;
      notifyListeners();
    }
  }

  void addTreatment(int treatmentId, int male, int female) {
    _selectedTreatments.add(treatmentId);
    _maleTreatments.add(male);
    _femaleTreatments.add(female);
    notifyListeners();
  }

  void removeTreatmentAt(int index) {
    _selectedTreatments.removeAt(index);
    _maleTreatments.removeAt(index);
    _femaleTreatments.removeAt(index);
    notifyListeners();
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
      _isLoading = true;
      notifyListeners();

      final dateStr = DateFormat(
        'dd/MM/yyyy-hh:mm a',
      ).format(dateTime).toUpperCase();

      // The API expects male/female to be lists of treatment IDs, not counts.
      // We repeat the treatment ID for each patient of that gender.
      final List<int> maleList = [];
      final List<int> femaleList = [];

      for (int i = 0; i < _selectedTreatments.length; i++) {
        final tId = _selectedTreatments[i];
        final mc = _maleTreatments[i];
        final fc = _femaleTreatments[i];

        for (int j = 0; j < mc; j++) {
          maleList.add(tId);
        }
        for (int j = 0; j < fc; j++) {
          femaleList.add(tId);
        }
      }

      final formData = dio.FormData.fromMap({
        'name': name,
        'excecutive': executive,
        'payment': payment,
        'phone': phone,
        'address': address,
        'total_amount': total.toInt().toString(),
        'discount_amount': discount.toInt().toString(),
        'advance_amount': advance.toInt().toString(),
        'balance_amount': balance.toInt().toString(),
        'date_nd_time': dateStr,
        'id': '',
        'male': maleList.join(','),
        'female': femaleList.join(','),
        'branch': branchId.toString(),
        'treatments': _selectedTreatments.join(','),
      });

      print('Sending FormData: ${formData.fields}');
      final response = await _apiService.post('/PatientUpdate', data: formData);
      print(response.data);

      return response.data['status'] ?? false;
    } catch (e) {
      print(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearBookingData() {
    _selectedTreatments.clear();
    _maleTreatments.clear();
    _femaleTreatments.clear();
    notifyListeners();
  }
}
