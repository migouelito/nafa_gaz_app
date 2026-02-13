import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
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
  final RxDouble currentPageValue = 5000.0.obs;
  
  late PageController pageController;
  Timer? _timer;
  final int _initialPage = 5000; 

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(
      viewportFraction: 0.8, 
      initialPage: _initialPage,
    );
    
    currentIndex.value = _initialPage % promoImages.length;

    pageController.addListener(_handleScroll);

    _startAutoScroll();
  }

  void _handleScroll() {
    if (pageController.hasClients) {
      currentPageValue.value = pageController.page!;
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) { 
      if (pageController.hasClients) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 1000), 
          curve: Curves.easeOutCubic, 
        );
      }
    });
  }

  void onPageChanged(int index) {
    currentIndex.value = index % promoImages.length;
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.removeListener(_handleScroll); 
    pageController.dispose();
    super.onClose();
  }
}