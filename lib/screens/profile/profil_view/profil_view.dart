import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../profil_controller/profil_controller.dart';
import '../../../appColors/appColors.dart';
import '../../../routes/app_routes.dart';
import '../../wallet/wallet_screen.dart';
import '../language_screen.dart';
import '../support_screen.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.generalColor,
        title: const Text(
          "MON COMPTE",
          style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontSize: 16,
              letterSpacing: 1.5),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => Get.toNamed(Routes.EDITPROFILE),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("MES INFORMATIONS"),
                  _buildMenuContainer([
                    _buildMenuItemWithRoute(
                        PhosphorIcons.mapPin(PhosphorIconsStyle.fill),
                        "Mes Adresses",
                        Routes.ADDRESSLIST),
                  ]),
                  
                  const SizedBox(height: 25),
                  _buildSectionTitle("PRÉFÉRENCES & AIDE"),
                  _buildMenuContainer([
                    _buildMenuItemWithNav(
                        context,
                        PhosphorIcons.wallet(PhosphorIconsStyle.fill),
                        "Portefeuille & Parrainage",
                        const WalletScreen()),
                    _buildMenuItemWithNav(
                        context,
                        PhosphorIcons.translate(PhosphorIconsStyle.fill),
                        "Langue (Français)",
                        const LanguageScreen()),
                    _buildMenuItemWithNav(
                        context,
                        PhosphorIcons.info(PhosphorIconsStyle.fill),
                        "Aide & Support",
                        const SupportScreen()),
                  ]),
                  
                  const SizedBox(height: 25),
                  _buildSectionTitle("SÉCURITÉ"),
                  _buildMenuContainer([
                    _buildLogoutItem(),
                  ]),
                  
                  const SizedBox(height: 30),
                  Center(
                    child: Column(
                      children: [
                        Text("Version ${controller.version}",
                            style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1)),
                        const SizedBox(height: 5),
                        const Text("NAFAGAZ - ELITE IT PARTNERS",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 8,
                                fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header avec fond coloré et bord arrondi
  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        color: AppColors.generalColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.grey.shade100,
                    child: Text(
                      controller.userName.isNotEmpty
                          ? controller.userName.substring(0, 1).toUpperCase()
                          : "U",
                      style: TextStyle(
                          fontSize: 32,
                          color: AppColors.generalColor,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.Orange,
                  child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              controller.userName.toUpperCase(),
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                controller.userPhone,
                style: const TextStyle(
                    color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Éléments de structure réutilisables
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 10),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: Colors.grey.shade500,
            letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildMenuContainer(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 8)),
        ],
      ),
      child: Column(children: items),
    );
  }

  Widget _buildMenuItemWithRoute(IconData icon, String title, String routeName) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: AppColors.generalColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppColors.generalColor, size: 22),
      ),
      title: Text(title,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2D3436))),
      trailing:
          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade300),
      onTap: () => Get.toNamed(routeName),
    );
  }

  Widget _buildMenuItemWithNav(
      BuildContext context, IconData icon, String title, Widget targetPage) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: AppColors.generalColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppColors.generalColor, size: 22),
      ),
      title: Text(title,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2D3436))),
      trailing:
          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade300),
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => targetPage)),
    );
  }

  Widget _buildLogoutItem() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10)),
        child: Icon(PhosphorIcons.power(PhosphorIconsStyle.bold),
            color: Colors.red, size: 22),
      ),
      title: const Text("Déconnexion",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700, color: Colors.red)),
      onTap: () => controller.confirmLogout(),
    );
  }
}