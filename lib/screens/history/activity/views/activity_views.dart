import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../controllers/activity_controller.dart';
import '../../../../appColors/appColors.dart';
import '../../../../routes/app_routes.dart';
import '../../../../loading/loading.dart';

class ActivityScreen extends GetView<ActivityController> {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FD),
        appBar: AppBar(
          title: const Text(
            "Mes Commandes",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.5),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            labelColor: AppColors.generalColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.generalColor,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
            tabs: const [
              Tab(text: "En cours"),
              Tab(text: "Historique"),
            ],
          ),
        ),
        
        // --- BOUTON COMMANDER ---
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Get.toNamed(Routes.CALALOG),
          backgroundColor: const Color(0xFF003317),
          elevation: 4,
          icon: Icon(PhosphorIcons.shoppingCart(PhosphorIconsStyle.fill), color: Colors.white, size: 20),
          label: const Text("Commander", 
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
        ),

        body: Obx(() => FutureBuilder<List<dynamic>?>(
          future: controller.futureCommandes.value,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingWidget(text: "Récupération des commandes");
            }

            if (snapshot.hasError || snapshot.data == null) {
              return _buildErrorState();
            }

            // --- RÉCUPÉRATION ET TRI ---
            List<dynamic> allOrders = List.from(snapshot.data!);
            
            // Tri du plus récent au plus ancien
            allOrders.sort((a, b) {
              DateTime dateA = DateTime.tryParse(a['created'] ?? "") ?? DateTime(2000);
              DateTime dateB = DateTime.tryParse(b['created'] ?? "") ?? DateTime(2000);
              return dateB.compareTo(dateA); 
            });

            // Filtres par état
            final activeOrders = allOrders.where((cmd) => 
              ["EN_ATTENTE", "EN_COURS", "CONFIRME"].contains(cmd['etat'])).toList();
            
            final historyOrders = allOrders.where((cmd) => 
              ["LIVRE", "ANNULE", "TERMINE"].contains(cmd['etat'])).toList();

            return TabBarView(
              children: [
                _buildOrderList(activeOrders, true),
                _buildOrderList(historyOrders, false),
              ],
            );
          },
        )),
      ),
    );
  }

  Widget _buildOrderList(List<dynamic> orders, bool isActiveTab) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.05), shape: BoxShape.circle),
              child: Icon(PhosphorIcons.package(PhosphorIconsStyle.fill), size: 60, color: Colors.grey.shade300),
            ),
            const SizedBox(height: 16),
            Text(
              isActiveTab ? "Aucune commande active" : "Historique vide",
              style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: controller.handleRefresh,
      color: AppColors.generalColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: orders.length,
        itemBuilder: (context, index) => _buildOrderCard(orders[index]),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> cmd) {
    final String dateStr = cmd['created'] ?? DateTime.now().toIso8601String();
    final String formattedDate = DateFormat('dd MMMM yyyy, HH:mm', 'fr_FR').format(DateTime.parse(dateStr));
    final List items = cmd['items'] ?? [];
    
    // Calcul du total des quantités
    int totalQty = 0;
    for (var item in items) {
      totalQty += (item['quantity'] as num).toInt();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => Get.toNamed(Routes.ACTIVITYDETAIL, arguments: cmd),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    // Icône Panier
                    Container(
                      height: 52, width: 52,
                      decoration: BoxDecoration(
                        color: AppColors.generalColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(PhosphorIcons.shoppingCart(PhosphorIconsStyle.fill), 
                        color: AppColors.generalColor, size: 26),
                    ),
                    const SizedBox(width: 16),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("N° ${cmd['id'].toString().substring(0, 8).toUpperCase()}", 
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: Colors.blueGrey, letterSpacing: 0.5)),
                              _buildStatusBadge(cmd['etat']),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text("$totalQty ${totalQty > 1 ? 'bouteilles' : 'bouteille'}", 
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: Color(0xFF1A1A1A))),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(PhosphorIcons.calendarCheck(), size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(formattedDate, style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1, thickness: 0.5),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${cmd['montant_total']} F CFA", 
                          style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.generalColor, fontSize: 16)),
                    
                    Row(
                      children: [
                        Text("Détails", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey.shade600)),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey.shade400),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String etat) {
    Color color;
    IconData icon;
    switch (etat) {
      case "EN_ATTENTE": 
        color = Colors.orange; 
        icon = PhosphorIcons.clockClockwise();
        break;
      case "LIVRE": 
        color = Colors.green; 
        icon = PhosphorIcons.checkCircle();
        break;
      case "ANNULE": 
        color = Colors.red; 
        icon = PhosphorIcons.xCircle();
        break;
      case "EN_COURS": 
        color = Colors.blue; 
        icon = PhosphorIcons.truck();
        break;
      default: 
        color = Colors.grey;
        icon = PhosphorIcons.info();
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(etat.replaceAll("_", " "), 
            style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 9)),
        ],
      ),
    );
  }



  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(PhosphorIcons.warningCircle(PhosphorIconsStyle.fill), size: 50, color: Colors.redAccent.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text("Une erreur est survenue", style: TextStyle(fontWeight: FontWeight.w900)),
          TextButton.icon(
            onPressed: controller.handleRefresh, 
            icon: Icon(PhosphorIcons.arrowsClockwise()),
            label: const Text("Réessayer"),
            style: TextButton.styleFrom(foregroundColor: AppColors.generalColor),
          )
        ],
      ),
    );
  }
}