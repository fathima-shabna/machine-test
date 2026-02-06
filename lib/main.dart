import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'splash_screen.dart';
import 'controllers/auth_controller.dart';
import 'controllers/patient_controller.dart';
import 'controllers/booking_controller.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(
          create: (_) => PatientController()..fetchPatients(),
        ),
        ChangeNotifierProvider(
          create: (_) => BookingController()..fetchInitialData(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noviindus Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF006837),
      ),
      home: const SplashScreen(),
    );
  }
}
