import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/login_model.dart';
import '../treatment_list_screen.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();
  var isLoading = false.obs;

  Future<void> login(String username, String password) async {
    try {
      isLoading.value = true;
      final response = await _apiService.post(
        '/Login',
        data: {'username': username, 'password': password},
      );

      final loginResponse = LoginResponse.fromJson(response.data);

      if (loginResponse.status) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', loginResponse.token ?? '');

        Get.offAll(() => TreatmentListScreen());
      } else {
        Get.snackbar(
          'Error',
          loginResponse.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    // Navigate to Login screen (needs to be implemented in main or as a named route)
  }
}
