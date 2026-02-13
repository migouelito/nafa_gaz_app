import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';
import 'package:intl/date_symbol_data_local.dart'; 
void main() async{
  await initializeDateFormatting('fr_FR', null);
  runApp(const NafaGazApp());
}

class NafaGazApp extends StatelessWidget {
  const NafaGazApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Nafa Gaz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00A86B),
        ),
      ),
      getPages: AppPages.routes,   
      home: const SplashScreen(),
    );
  }
}
