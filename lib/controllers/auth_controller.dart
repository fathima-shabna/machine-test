import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/login_model.dart';
import '../treatment_list_screen.dart';

class AuthController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> login(
    BuildContext context,
    String username,
    String password,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.post(
        '/Login',
        data: {'username': username, 'password': password},
      );

      final loginResponse = LoginResponse.fromJson(response.data);

      if (loginResponse.status) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', loginResponse.token ?? '');

        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => TreatmentListScreen()),
            (route) => false,
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loginResponse.message),
              backgroundColor: Colors.red.withOpacity(0.8),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Something went wrong. Please try again.'),
            backgroundColor: Colors.red.withOpacity(0.8),
          ),
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    notifyListeners();
  }
}
