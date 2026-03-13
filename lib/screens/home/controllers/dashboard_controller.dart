import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class DashboardController extends GetxController {
  // On utilise la même constante que AccueilPage pour la cohérence
  static const int infiniteRange = 100000000;

  final userName = "Migouël".obs;
  final walletBalance = "12 500 F".obs;
  final notificationCount = "3".obs;

  final List<String> promoImages = [
    'assets/images/pub1.jpg',
    'assets/images/pub2.jpg',
    'assets/images/pub3.jpg',
    'assets/images/pub4.jpg',
  ];

  final RxInt currentIndex = 0.obs;
  final RxDouble currentPageValue = 0.0.obs;
  
  late PageController pageController;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    
    // Calcul de la page du milieu comme dans AccueilPage
    int midImage = (infiniteRange ~/ 2) - ((infiniteRange ~/ 2) % promoImages.length);
    
    pageController = PageController(
      viewportFraction: 0.8, 
      initialPage: midImage,
    );
    
    currentIndex.value = midImage % promoImages.length;
    currentPageValue.value = midImage.toDouble();

    pageController.addListener(_handleScroll);
    _startAutoScroll();
  }

  void _handleScroll() {
    if (pageController.hasClients) {
      currentPageValue.value = pageController.page!;
    }
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) { // 3 secondes comme Accueil
      if (pageController.hasClients) {
        final int nextStep = (pageController.page?.toInt() ?? 0) + 1;
        
        pageController.animateToPage(
          nextStep,
          duration: const Duration(milliseconds: 800), // Même vitesse : 800ms
          curve: Curves.easeInOut, // Même courbe
        );
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.removeListener(_handleScroll); 
    pageController.dispose();
    super.onClose();
  }
}