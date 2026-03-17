import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nafa_gaz_app/routes/app_routes.dart';
import '../controllers/dashboard_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../wallet/wallet_screen.dart';
import '../../services/recharge_screen.dart';
import '../../services/swap_screen.dart';
import '../../services/pay_gas_screen.dart';
import '../../services/subscription_screen.dart';
import '../../services/sos_screen.dart';
import '../../services/new_bottle_screen.dart';
import '../../services/pro_screen.dart';
import '../../../appColors/appColors.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildPromoSlider(),
            const SizedBox(height: 30),
            _buildServicesSection(context),
            const SizedBox(height: 30),
            
            // Slogan en bas
            _buildSlogan(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- APP BAR AVEC CAMION ET LOGO SPLITÉ ---
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          // Icône de camion de transport de gaz
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.generalColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              PhosphorIcons.truck(PhosphorIconsStyle.bold),
              color: AppColors.generalColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 8),
          // Texte NAFAGAZ splité
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "NAFA",
                  style: TextStyle(
                    fontSize: 22,
                    color: AppColors.generalColor,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                TextSpan(
                  text: "GAZ",
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.orange,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF1A1F36),
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        _buildWalletAction(context),
        _buildNotificationAction(context),
      ],
    );
  }

  // --- SLOGAN EN BAS ---
  Widget _buildSlogan() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Container(
            height: 2,
            width: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.generalColor.withOpacity(0.3),
                  Colors.orange.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
       
        ],
      ),
    );
  }

  Widget _buildNotificationAction(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          IconButton(
            icon: Icon(
              PhosphorIcons.bell(PhosphorIconsStyle.regular),
              size: 24,
              color: const Color(0xFF1A1F36),
            ),
            onPressed: () => Get.toNamed(Routes.NOTIFICATION),
          ),
          Obx(() {
            int count = int.tryParse(controller.notificationCount.value) ?? 0;
            return count > 0
                ? Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE53E3E),
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildWalletAction(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (c) => const WalletScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F3F8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              PhosphorIcons.wallet(PhosphorIconsStyle.regular),
              color: const Color(0xFF4A5568),
              size: 16,
            ),
            const SizedBox(width: 6),
            Obx(() => Text(
              controller.walletBalance.value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF1A1F36),
              ),
            )),
          ],
        ),
      ),
    );
  }

  // --- HEADER ÉPURÉ ---
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Text(
            "Bonjour, ${controller.userName.value}",
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1F36),
            ),
          )),
          const SizedBox(height: 4),
          Text(
            "Comment pouvons-nous vous aider ?",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoSlider() {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: controller.pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              controller.currentIndex.value = index % controller.promoImages.length;
            },
            itemCount: DashboardController.infiniteRange, 
            itemBuilder: (context, index) {
              int realIndex = index % controller.promoImages.length;
              
              return Obx(() {
                double relativePosition = controller.currentPageValue.value - index;
                double scale = (1 - (relativePosition.abs() * 0.15)).clamp(0.85, 1.0);

                return Transform.scale(
                  scale: scale,
                  child: _buildAdImageBanner(controller.promoImages[realIndex]),
                );
              });
            },
          ),
        ),
        const SizedBox(height: 12),
        Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            controller.promoImages.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 7,
              width: controller.currentIndex.value == index ? 20 : 7,
              decoration: BoxDecoration(
                color: controller.currentIndex.value == index
                    ? AppColors.generalColor 
                    : AppColors.generalColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        )),
      ],
    );
  }
  
  Widget _buildAdImageBanner(String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child:const Text(
                  "Promo",
                  style: TextStyle(
                    color: AppColors.generalColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- SERVICES SECTION ---
  Widget _buildServicesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Services",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1F36),
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 20,
            childAspectRatio: 0.9,
            children: [
              _buildServiceCard(context, PhosphorIcons.arrowsClockwise(PhosphorIconsStyle.regular), "Recharger", () => Get.toNamed(Routes.RECHARGE)),
              _buildServiceCard(context, PhosphorIcons.repeat(PhosphorIconsStyle.regular), "Échanger", () => Get.toNamed(Routes.CHANGE)),
              _buildServiceCard(context, PhosphorIcons.plusCircle(PhosphorIconsStyle.regular), "Nouvelle", () => Get.toNamed(Routes.BUY)),
              _buildServiceCard(context, PhosphorIcons.handCoins(PhosphorIconsStyle.regular), "Payer tiers", () => Navigator.push(context, MaterialPageRoute(builder: (c) => const PayGasScreen()))),
              _buildServiceCard(context, PhosphorIcons.calendarCheck(PhosphorIconsStyle.regular), "Planifier", () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SubscriptionScreen()))),
              _buildServiceCard(context, PhosphorIcons.wrench(PhosphorIconsStyle.regular), "SOS", () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SosScreen()))),
              _buildServiceCard(context, PhosphorIcons.storefront(PhosphorIconsStyle.regular), "Espace Pro", () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ProScreen()))),
              _buildServiceCard(context, PhosphorIcons.gift(PhosphorIconsStyle.regular), "Gagner", () => Navigator.push(context, MaterialPageRoute(builder: (c) => const WalletScreen()))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:  AppColors.generalColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon, 
              color: AppColors.generalColor, 
              size: 22,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.generalColor,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nafa_gaz_app/routes/app_routes.dart';
// import '../controllers/dashboard_controller.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
// // Tes imports d'écrans
// import '../../wallet/wallet_screen.dart';
// import '../../services/recharge_screen.dart';
// import '../../services/swap_screen.dart';
// import '../../services/pay_gas_screen.dart';
// import '../../services/subscription_screen.dart';
// import '../../services/sos_screen.dart';
// import '../../services/new_bottle_screen.dart';
// import '../../services/pro_screen.dart';
// import '../../../appColors/appColors.dart';

// class DashboardView extends GetView<DashboardController> {
//   const DashboardView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FD),
//       appBar: AppBar(
//         title: const Text("NAFAGAZ", style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: AppColors.generalColor,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         actions: [
//           _buildWalletAction(context),
//           _buildNotificationAction(context),
//         ],
//       ),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Obx(() => Text(
//                 "Bonjour, ${controller.userName.value} 👋", 
//                 style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
//               )),
//             ),

//             _buildPromoSlider(),

//             const SizedBox(height: 25),

//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text("Nos Services", 
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 15),
                  
//                   GridView.count(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     crossAxisCount: 3,
//                     crossAxisSpacing: 15,
//                     mainAxisSpacing: 15,
//                     childAspectRatio: 0.82, 
//                     children: [
//                       _buildServiceCard(context, Icons.sync, "Recharger\nGaz", const Color(0xFFE8F5E9), 
//                         () => Navigator.push(context, MaterialPageRoute(builder: (c) => const RechargeScreen()))),
                      
//                       _buildServiceCard(context, Icons.swap_horiz, "Échanger\nGaz", const Color(0xFFE8F5E9), 
//                         () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SwapScreen()))),
                      
//                       _buildServiceCard(context, Icons.add_circle, "Nouvelle\nBouteille", const Color(0xFFE8F5E9), 
//                         () => Navigator.push(context, MaterialPageRoute(builder: (c) => const NewBottleScreen()))),

//                       _buildServiceCard(context, Icons.payment, "Payer pour\nun tiers", const Color(0xFFE8F5E9), 
//                         () => Navigator.push(context, MaterialPageRoute(builder: (c) => const PayGasScreen()))),
                      
//                       _buildServiceCard(context, Icons.calendar_month, "Planifier\nLivraison", const Color(0xFFE8F5E9), 
//                         () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SubscriptionScreen()))),
                      
//                       _buildServiceCard(context, Icons.build, "SOS &\nOutils", const Color(0xFFE8F5E9), 
//                         () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SosScreen()))),
                      
//                       _buildServiceCard(context, Icons.storefront, "Espace\nPro", Colors.blueGrey.shade50, 
//                         () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ProScreen()))),
                        
//                       _buildServiceCard(context, Icons.card_giftcard, "Gagner\nde l'argent", const Color(0xFFE8F5E9), 
//                         () => Navigator.push(context, MaterialPageRoute(builder: (c) => const WalletScreen()))),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 35),
                  
//                   const Text("Raccourci", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
//                   const SizedBox(height: 12),
//                   _buildExpressButton(),
//                   const SizedBox(height: 40),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // --- WIDGETS DE L'APPBAR ---

// Widget _buildNotificationAction(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         IconButton(
//           // Utilisation de Phosphor pour une icône de cloche plus propre
//           icon: Icon(PhosphorIcons.bell(), size: 28), 
//           onPressed: () => Get.toNamed(Routes.NOTIFICATION),
//         ),
//         Positioned(
//           right: 8, top: 12,
//           child: Container(
//             padding: const EdgeInsets.all(4),
//             decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
//             constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
//             child: Obx(() => Text(
//               controller.notificationCount.value, 
//               textAlign: TextAlign.center,
//               style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)
//             )),
//           ),
//         )
//       ],
//     );
//   }

// Widget _buildWalletAction(BuildContext context) {
//     return GestureDetector(
//       onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const WalletScreen())),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.15),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: Colors.white30),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Obx(() => Text(
//               controller.walletBalance.value, 
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)
//             )),
//             const SizedBox(width: 20),
//             const Icon(Icons.add_circle, color: Colors.white, size: 20),

//           ],
//         ),
//       ),
//     );
//   }
//   Widget _buildPromoSlider() {
//     return SizedBox(
//       height: 160,
//       child: PageView(
//         controller: PageController(viewportFraction: 0.9),
//         padEnds: false,
//         children: [
//           _buildAdBanner(Colors.blue.shade800, "Sodigaz", "Promo -15% sur les échanges", Icons.local_fire_department),
//           _buildAdBanner(AppColors.generalColor, "TotalEnergies", "Gagnez une lampe solaire !", Icons.lightbulb),
//         ],
//       ),
//     );
//   }

//   Widget _buildAdBanner(Color color, String title, String subtitle, IconData icon) {
//     return Container(
//       margin: const EdgeInsets.only(right: 15, left: 10),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: color, 
//         borderRadius: BorderRadius.circular(25),
//         boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
//       ),
//       child: Row(children: [
//         Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
//           Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
//           Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
//         ])),
//         Icon(icon, color: Colors.white.withOpacity(0.2), size: 60),
//       ]),
//     );
//   }

//   Widget _buildServiceCard(BuildContext context, IconData icon, String label, Color bgColor, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(20),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white, 
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))]
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
//               child: Icon(icon, color: AppColors.generalColor, size: 26),
//             ),
//             const SizedBox(height: 10),
//             Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.black87))
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildExpressButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 55,
//       child: ElevatedButton.icon(
//         onPressed: () => Get.toNamed(Routes.CALALOG),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.generalColor, 
//           foregroundColor: Colors.white, 
//           elevation: 4,
//           shadowColor: AppColors.generalColor.withOpacity(0.4),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         ),
//         icon: const Icon(Icons.flash_on, size: 20),
//         label: const Text("COMMANDE EXPRESS (1-CLIC)", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
//       ),
//     );
//   }
// }