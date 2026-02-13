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
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildPromoSlider(),
            const SizedBox(height: 10),
            _buildServicesSection(context),
            // _buildExpressSection(),
            // const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- APP BAR ---
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
         
          const Text(
            "NAFAGAZ",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1),
          ),
        ],
      ),
      backgroundColor: AppColors.generalColor,
      foregroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        _buildWalletAction(context),
        _buildNotificationAction(context),
      ],
    );
  }

  Widget _buildNotificationAction(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(PhosphorIcons.bell(PhosphorIconsStyle.bold), size: 24),
              onPressed: () => Get.toNamed(Routes.NOTIFICATION),
            ),
          ),
          Positioned(
            right: 6,
            top: 6,
            child: Obx(() {
              int count = int.tryParse(controller.notificationCount.value) ?? 0;
              return count > 0
                  ? Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.generalColor, width: 2),
                      ),
                      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Center(
                        child: Text(
                          count > 9 ? '9+' : count.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            }),
          )
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.25),
              Colors.white.withOpacity(0.15),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(PhosphorIcons.wallet(PhosphorIconsStyle.fill), 
              color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Obx(() => Text(
              controller.walletBalance.value,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 15,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            )),
            const SizedBox(width: 6),
            const Icon(Icons.add_circle_rounded, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  // --- HEADER ---
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Text(
            "Bonjour, ${controller.userName.value} 👋",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1A1F36),
              letterSpacing: -0.5,
            ),
          )),
          const SizedBox(height: 4),
          Text(
            "Comment pouvons-nous vous aider aujourd'hui ?",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
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
        height: 200, // Hauteur augmentée pour éviter que le zoom ne coupe l'image
        child: PageView.builder(
          controller: controller.pageController,
          onPageChanged: controller.onPageChanged,
          itemBuilder: (context, index) {
            return Obx(() {
              // Calcul de la distance par rapport au centre (0.0 = centre parfait)
              double relativePosition = controller.currentPageValue.value - index;
              
              // 1.0 au centre, descend à 0.85 quand l'image s'éloigne
              double scale = (1 - (relativePosition.abs() * 0.15)).clamp(0.85, 1.0);

              return Transform.scale(
                scale: scale,
                child: _buildAdImageBanner(
                  controller.promoImages[index % controller.promoImages.length],
                ),
              );
            });
          },
        ),
      ),
      const SizedBox(height: 4),
      // --- INDICATEURS (POINTS) ---
      Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          controller.promoImages.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 2),
            height: 8,
            width: controller.currentIndex.value == index ? 8 : 8,
            decoration: BoxDecoration(
              color: controller.currentIndex.value == index 
                  ? AppColors.generalColor 
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      )),
    ],
  );
}
Widget _buildAdImageBanner(String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover, 
        ),
      ),
    );
  }
  Widget _buildAdBanner(
    Gradient gradient,
    String title,
    String subtitle,
    IconData icon,
    String buttonText,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(icon, color: Colors.white.withOpacity(0.1), size: 140),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        buttonText,
                        style: TextStyle(
                          color: AppColors.generalColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward, 
                        color: AppColors.generalColor, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1A1F36),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 18),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.88,
            children: [
                _buildServiceCard(
                context,
                PhosphorIcons.arrowsClockwise(PhosphorIconsStyle.bold),
                "Recharger\nGaz",
                AppColors.generalColor,
                () => Get.toNamed(Routes.RECHARGE),//Navigator.push(context, MaterialPageRoute(builder: (c) => const RechargeScreen())),
              ),
                _buildServiceCard(
                context,
                PhosphorIcons.repeat(PhosphorIconsStyle.bold),
                "Échanger\nGaz",
                AppColors.generalColor,
                () => Get.toNamed(Routes.CHANGE),//Navigator.push(context, MaterialPageRoute(builder: (c) => const SwapScreen())),
              ),
                _buildServiceCard(
                context,
                PhosphorIcons.plusCircle(PhosphorIconsStyle.bold),
                "Nouvelle\nBouteille",
              AppColors.generalColor,
              ()=> Get.toNamed(Routes.BUY)
                // () => Navigator.push(context, MaterialPageRoute(builder: (c) => const NewBottleScreen())),
              ),
   
              _buildServiceCard(
                context,
                PhosphorIcons.handCoins(PhosphorIconsStyle.bold),
                "Payer pour\nun tiers",
                AppColors.generalColor,
                () => Navigator.push(context, MaterialPageRoute(builder: (c) => const PayGasScreen())),
              ),
              _buildServiceCard(
                context,
                PhosphorIcons.calendarCheck(PhosphorIconsStyle.bold),
                "Planifier\nLivraison",
                AppColors.generalColor,
                () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SubscriptionScreen())),
              ),
              _buildServiceCard(
                context,
                PhosphorIcons.wrench(PhosphorIconsStyle.bold),
                "SOS &\nOutils",
                AppColors.generalColor,
                () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SosScreen())),
              ),
              _buildServiceCard(
                context,
                PhosphorIcons.storefront(PhosphorIconsStyle.bold),
                "Espace\nPro",
                AppColors.generalColor,
                () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ProScreen())),
              ),
              _buildServiceCard(
                context,
                PhosphorIcons.gift(PhosphorIconsStyle.bold),
                "Gagner\nde l'argent",
                AppColors.generalColor,
                () => Navigator.push(context, MaterialPageRoute(builder: (c) => const WalletScreen())),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1F36),
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- EXPRESS BUTTON ---
  // Widget _buildExpressSection() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 24),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           "Raccourci",
  //           style: TextStyle(
  //             fontSize: 13,
  //             fontWeight: FontWeight.w700,
  //             color: Colors.grey[500],
  //             letterSpacing: 0.5,
  //           ),
  //         ),
  //         const SizedBox(height: 12),
  //         _buildExpressButton(),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildExpressButton() {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.generalColor, AppColors.generalColor.withOpacity(0.85)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.generalColor.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.toNamed(Routes.CALALOG),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    "COMMANDE EXPRESS (1-CLIC)",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ),
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