import 'package:flutter/material.dart';
import 'screens/splash_screen.dart'; // L'import fonctionnera car le fichier existe maintenant
import 'package:get/get.dart';
import 'routes/app_pages.dart';
void main() {
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
