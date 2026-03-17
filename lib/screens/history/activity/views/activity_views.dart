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
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          title: const Text(
            "Mes Commandes",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
              ),
              child: TabBar(
                labelColor: AppColors.generalColor,
                unselectedLabelColor: Colors.grey.shade500,
                indicatorColor: AppColors.generalColor,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
                tabs: const [
                  Tab(text: "En cours"),
                  Tab(text: "Historique"),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: _buildFAB(),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildFAB() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // boxShadow: [
        //   BoxShadow(
        //     color: AppColors.generalColor.withOpacity(0.3),
        //     blurRadius: 15,
        //     offset: const Offset(0, 5),
        //   ),
        // ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () async {
          await Get.toNamed(Routes.CALALOG);
          // CORRECTION : Ajout des parenthèses pour exécuter la fonction
          await controller.handleRefresh();
        },
        backgroundColor: AppColors.generalColor,
        elevation: 0,
        icon: Icon(
          PhosphorIcons.shoppingCart(PhosphorIconsStyle.regular),
          color: Colors.white,
          size: 20,
        ),
        label: const Text(
          "Commander",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 15,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Obx(() => FutureBuilder<List<dynamic>?>(
          future: controller.futureCommandes.value,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingWidget(text: "Récupération des commandes");
            }

            if (snapshot.hasError || snapshot.data == null) {
              return _buildErrorState();
            }

            final List<dynamic> allOrders = List.from(snapshot.data!);
            
            allOrders.sort((a, b) {
              final DateTime dateA = DateTime.tryParse(a['created'] ?? "") ?? DateTime(2000);
              final DateTime dateB = DateTime.tryParse(b['created'] ?? "") ?? DateTime(2000);
              return dateB.compareTo(dateA);
            });

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
        ));
  }

  Widget _buildOrderList(List<dynamic> orders, bool isActiveTab) {
    if (orders.isEmpty) {
      return _buildEmptyState(isActiveTab);
    }

    return RefreshIndicator(
      // CORRECTION : Ajout des parenthèses ()
      onRefresh: () async => await controller.handleRefresh(),
      color: AppColors.generalColor,
      backgroundColor: Colors.white,
      strokeWidth: 2.5,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        cacheExtent: 100,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        itemCount: orders.length,
        itemBuilder: (context, index) => _buildOrderCard(orders[index]),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> cmd) {
    final String dateStr = cmd['created'] ?? DateTime.now().toIso8601String();
    final String formattedDate = DateFormat('dd MMMM yyyy, HH:mm', 'fr_FR').format(DateTime.parse(dateStr));
    final List items = cmd['items'] ?? [];
    
    final int totalQty = items.fold(0, (sum, item) => sum + (item['quantity'] as num).toInt());

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -5,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          splashColor: AppColors.generalColor.withOpacity(0.05),
          highlightColor: AppColors.generalColor.withOpacity(0.02),
          onTap: () => Get.toNamed(Routes.ACTIVITYDETAIL, arguments: cmd),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildCartIcon(),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildOrderNumber(cmd['id']),
                              _buildStatusBadge(cmd['etat']),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _buildQuantityText(totalQty),
                          const SizedBox(height: 6),
                          _buildDateRow(formattedDate),
                        ],
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFF1F5F9), 
                  ),
                ),
                _buildCardFooter(cmd['montant_total']),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartIcon() {
    return Container(
      height: 58,
      width: 58,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.generalColor.withOpacity(0.12),
            AppColors.generalColor.withOpacity(0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(
        PhosphorIcons.shoppingCart(PhosphorIconsStyle.regular),
        color: AppColors.generalColor,
        size: 28,
      ),
    );
  }

  Widget _buildOrderNumber(dynamic id) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        "N° ${id.toString().substring(0, 8).toUpperCase()}",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 10,
          color: Colors.blueGrey.shade400,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildQuantityText(int totalQty) {
    return Row(
      children: [
        Text(
          "$totalQty",
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          totalQty > 1 ? 'bouteilles' : 'bouteille',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRow(String formattedDate) {
    return Row(
      children: [
        Icon(
          PhosphorIcons.clock(PhosphorIconsStyle.regular),
          size: 12,
          color: Colors.grey.shade400,
        ),
        const SizedBox(width: 4),
        Text(
          formattedDate,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildCardFooter(dynamic total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 2),
            Text(
              "$total F CFA",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.generalColor,
                fontSize: 18,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Text(
                "Détails",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
              ),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios_rounded, size: 10, color: Colors.grey.shade500),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildEmptyState(bool isActiveTab) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
            child: Icon(PhosphorIcons.shoppingCart(PhosphorIconsStyle.fill), size: 50, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 20),
          Text(
            isActiveTab ? "Aucune commande active" : "Historique vide",
            style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(PhosphorIcons.warningCircle(PhosphorIconsStyle.fill), size: 50, color: Colors.red.shade200),
          const SizedBox(height: 16),
          const Text("Une erreur est survenue", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              // CORRECTION : Ajout des parenthèses ()
              await controller.handleRefresh();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.generalColor),
            child: const Text("Réessayer"),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String etat) {
    final Map<String, dynamic> config = _getStatusConfig(etat);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: config['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: config['color'].withOpacity(0.2), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config['icon'], size: 12, color: config['color']),
          const SizedBox(width: 4),
          Text(
            config['label'],
            style: TextStyle(color: config['color'], fontWeight: FontWeight.w600, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getStatusConfig(String etat) {
    switch (etat) {
      case "EN_ATTENTE":
        return {'color': Colors.amber.shade700, 'icon': PhosphorIcons.hourglass(PhosphorIconsStyle.fill), 'label': "En attente"};
      case "LIVRE":
        return {'color': Colors.green.shade600, 'icon': PhosphorIcons.checkCircle(PhosphorIconsStyle.fill), 'label': "Livré"};
      case "ANNULE":
        return {'color': Colors.red.shade400, 'icon': PhosphorIcons.xCircle(PhosphorIconsStyle.fill), 'label': "Annulé"};
      case "EN_COURS":
        return {'color': Colors.blue.shade500, 'icon': PhosphorIcons.truck(PhosphorIconsStyle.fill), 'label': "En cours"};
      case "CONFIRME":
        return {'color': Colors.indigo.shade400, 'icon': PhosphorIcons.check(PhosphorIconsStyle.fill), 'label': "Confirmé"};
      default:
        return {'color': Colors.grey, 'icon': PhosphorIcons.info(PhosphorIconsStyle.fill), 'label': etat};
    }
  }
}