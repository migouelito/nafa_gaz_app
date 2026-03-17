import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../appColors/appColors.dart';
import 'main_layout_controller.dart';
import 'package:nafa_gaz_app/screens/profile/profil_controller/profil_controller.dart';
import 'package:nafa_gaz_app/screens/profile/profil_view/profil_view.dart';
import 'package:nafa_gaz_app/screens/history/activity/controllers/activity_controller.dart';
import 'package:nafa_gaz_app/screens/history/activity/views/activity_views.dart';
import 'package:nafa_gaz_app/screens/home/controllers/dashboard_controller.dart';
import 'package:nafa_gaz_app/screens/home/views/dashboard_view.dart';

class HomePage extends GetView<HomeController> {
  HomePage({Key? key}) : super(key: key);

  final List<String> _titles = ["Accueil", "Commandes", "Profil"];

  

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.generalColor;

    return Obx(() {
      final index = controller.currentIndex.value;
      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : const Color(0xFFF8F9FD),
        appBar: null, 
        body: _buildPage(index),
        bottomNavigationBar: _buildBottomNavigationBar(index, isDarkMode, primaryColor),
      );
    });
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        Get.lazyPut<DashboardController>(() => DashboardController());
        return const DashboardView();
      case 1:
        Get.lazyPut<ActivityController>(() => ActivityController());
        return const ActivityScreen();
      case 2:
        Get.lazyPut<ProfileController>(() => ProfileController());
        return const ProfileView();
      default:
        return const Center(child: Text("Page Inconnue"));
    }
  }

 Widget _buildBottomNavigationBar(int index, bool isDarkMode, Color primaryColor) {
  return Container(
    decoration: BoxDecoration(
      color: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      // boxShadow: [
      //   BoxShadow(
      //     color: Colors.black.withOpacity(0.08),
      //     blurRadius: 20,
      //     offset: const Offset(0, -5),
      //     spreadRadius: 2,
      //   ),
      // ],
    ),
    child: ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        currentIndex: index,
        onTap: (i) => controller.changeIndex(i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey.shade400,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 0,
        items: List.generate(_titles.length, (i) => _buildNavItem(i, index, isDarkMode, primaryColor)),
      ),
    ),
  );
}

BottomNavigationBarItem _buildNavItem(int i, int currentIndex, bool isDarkMode, Color primaryColor) {
  bool isSelected = i == currentIndex;
  
  return BottomNavigationBarItem(
    icon: AnimatedContainer(
      duration: const Duration(milliseconds: 0),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected 
            ? primaryColor.withOpacity(0.15) 
            : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Icon(
        _getIcon(i),
        size: 24,
        color: isSelected ? primaryColor : Colors.grey.shade400,
      ),
    ),
    label: _titles[i],
    activeIcon: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _getIcon(i),
        size: 24,
        color: primaryColor,
      ),
    ),
  );
}

IconData _getIcon(int index) {
  switch (index) {
    case 0:
      return PhosphorIcons.house(PhosphorIconsStyle.regular);
    case 1:
      return PhosphorIcons.shoppingCart(PhosphorIconsStyle.regular);
    case 2:
      return PhosphorIcons.user(PhosphorIconsStyle.regular);
    case 3:
      return PhosphorIcons.user(PhosphorIconsStyle.regular);
    default:
      return PhosphorIcons.circle(PhosphorIconsStyle.regular);
  }
}

}

 // BottomNavigationBarItem _buildNavItem(int itemIndex, int selectedIndex, bool isDarkMode, Color primaryColor) {
  //   final bool isSelected = itemIndex == selectedIndex;
  //   return BottomNavigationBarItem(
  //     icon: Container(
  //       padding: const EdgeInsets.all(10),
  //       decoration: BoxDecoration(
  //         color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
  //         borderRadius: BorderRadius.circular(15),
  //       ),
  //       child: Icon(
  //         isSelected ? _activeIcons[itemIndex] : _inactiveIcons[itemIndex],
  //         size: 24,
  //       ),
  //     ),
  //     label: _titles[itemIndex],
  //   );
  // }