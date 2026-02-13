import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'order_validation_controller.dart';
import '../../../../servicesApp/urlBase.dart';
import '../../../../loading/loading.dart';
import '../../../../appColors/appColors.dart';

class OrderValidationView extends GetView<OrderValidationController> {
  const OrderValidationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text("Récapitulatif de la commande",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isProductLoading.value) {
          return const Center(child: LoadingWidget(text: "Chargement..."));
        }
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Liste des produits
                  ...List.generate(controller.selectedProducts.length, 
                      (index) => _buildProductCard(index)),
                  
                  const SizedBox(height: 10),
                  
                  // --- CHAMP DE LOCALISATION STYLE INKWELL ---
                  _buildLocationSelector(),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
            _buildSummarySection(),
          ],
        );
      }),
      bottomNavigationBar: _buildBottomAction(),
    );
  }

  Widget _buildProductCard(int index) {
    var p = controller.selectedProducts[index];
    var tarif = (p['tarifs'] != null && (p['tarifs'] as List).isNotEmpty) ? p['tarifs'][0] : {};

    return Obx(() {
      int qV = (p['qty_vente'] as RxInt).value;
      int qR = (p['qty_recharge'] as RxInt).value;
      int qE = (p['qty_echange'] as RxInt).value;

      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildProductImage(p['image'], size: 85),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${p['marque_name'] ?? p['name']}",
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
                        Text("Poids: ${p['poids_value']} kg",
                            style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        
                        if (controller.typeSelection == 1 && qV > 0) 
                          _headerDetailRow("Vente", tarif['price_vente'], qV, Colors.blue),
                        if (controller.typeSelection == 2 && qR > 0) 
                          _headerDetailRow("Recharge", tarif['price_recharge'], qR, Colors.green),
                        if (controller.typeSelection == 3 && qE > 0) 
                          _headerDetailRow("Échange", tarif['price_echange'], qE, Colors.orange),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (controller.typeSelection == 3 && qE > 0) _buildExchangeSelector(p),

            const Divider(height: 1),

            if (controller.typeSelection == 1) 
              _buildTypeRow(index, "vente", "Quantité Achat", Colors.blue, tarif['price_vente']),
            if (controller.typeSelection == 2) 
              _buildTypeRow(index, "recharge", "Quantité Recharge", Colors.green, tarif['price_recharge']),
            if (controller.typeSelection == 3) 
              _buildTypeRow(index, "echange", "Quantité Échange", Colors.orange, tarif['price_echange']),

            const SizedBox(height: 10),
          ],
        ),
      );
    });
  }

  Widget _buildExchangeSelector(Map<String, dynamic> p) {
    String productId = p['id'].toString();
    return Obx(() {
      String selectedId = controller.exchangeSelection[productId]?.value ?? "";
      var selectedProd = controller.allAvailableProducts.firstWhere(
          (el) => el['id'].toString() == selectedId, orElse: () => {});

      return InkWell(
        onTap: () => _showExchangePicker(p),
        child: Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.generalColor.withOpacity(0.06),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              width: 1.5,
              color: selectedId == "" ? Colors.orange.withOpacity(0.4) : AppColors.generalColor
            ),
          ),
          child: Row(
            children: [
              _buildProductImage(selectedProd['image'], size: 45),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("BOUTEILLE À RENDRE", 
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.blueGrey)),
                    const SizedBox(height: 4),
                    Text(
                      selectedId == "" ? "Cliquez pour choisir le modèle" : "${selectedProd['marque_name'] ?? selectedProd['name']}",
                      style: TextStyle(
                          fontSize: 14,
                          color: selectedId == "" ? Colors.orange[800] : Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Icon(Icons.swap_horizontal_circle, color: AppColors.generalColor, size: 26),
            ],
          ),
        ),
      );
    });
  }

  void _showExchangePicker(Map<String, dynamic> currentProd) {
    final String currentId = currentProd['id'].toString();
    final eligibleExchangeProds = controller.allAvailableProducts.where((item) {
      return item['poids_value'].toString() == currentProd['poids_value'].toString() &&
             item['id'].toString() != currentId;
    }).toList();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 15),
            const Text("Bouteille à rendre", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            const SizedBox(height: 20),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: eligibleExchangeProds.length,
                separatorBuilder: (c, i) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = eligibleExchangeProds[index];
                  final String itemId = item['id'].toString();
                  return Obx(() {
                    bool isSelected = controller.exchangeSelection[currentId]?.value == itemId;
                    return InkWell(
                      onTap: () {
                        controller.exchangeSelection[currentId]?.value = itemId;
                        Future.delayed(const Duration(milliseconds: 250), () => Get.back());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.generalColor.withOpacity(0.05) : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: isSelected ? AppColors.generalColor : Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            _buildProductImage(item['image'], size: 50),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${item['marque_name'] ?? item['name']}", 
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text("Poids: ${item['poids_value']} kg", 
                                      style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            // --- CASE A COCHER CARREE ---
                            Container(
                              height: 24, width: 24,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.generalColor : Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: isSelected ? AppColors.generalColor : Colors.grey.shade300),
                              ),
                              child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildLocationSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: InkWell(
        onTap: () => _showLocationPicker(),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              Icon(Icons.location_on_rounded, color: AppColors.generalColor, size: 22),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("ZONE DE LIVRAISON", 
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 0.5)),
                    Obx(() => Text(controller.selectedLocation.value, 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade400, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showLocationPicker() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            const Text("Sélectionner votre ville", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
            const SizedBox(height: 15),
            ...controller.locations.map((loc) => ListTile(
              leading: Icon(Icons.location_on_rounded, color: AppColors.generalColor),
              title: Text(loc, style: const TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                controller.selectedLocation.value = loc;
                Get.back();
              },
            )).toList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(String? imagePath, {double size = 60}) {
    final String fullImageUrl = (imagePath != null && imagePath.isNotEmpty) ? "${ApiUrlPage.baseUrl}$imagePath" : "";
    return Container(
      height: size, width: size,
      decoration: BoxDecoration(
        color: Colors.grey[50], 
        borderRadius: BorderRadius.circular(12), 
        border: Border.all(color: Colors.grey.shade100)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: fullImageUrl.isNotEmpty 
            ? Image.network(fullImageUrl, fit: BoxFit.contain) 
            : const Icon(Icons.propane_tank, color: Color(0xFF003317), size: 30),
      ),
    );
  }

  Widget _headerDetailRow(String title, dynamic price, int qty, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
            child: Text(title, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
          Text("$price F x $qty", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildTypeRow(int index, String type, String label, Color color, dynamic price) {
    var p = controller.selectedProducts[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Row(
            children: [
              _qtyBtn(Icons.remove, () => controller.updateQty(index, type, false)),
              Obx(() => Container(
                    width: 40, alignment: Alignment.center,
                    child: Text("${p['qty_$type'].value}", style: const TextStyle(fontWeight: FontWeight.w900)),
                  )),
              _qtyBtn(Icons.add, () => controller.updateQty(index, type, true)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: const Color(0xFF003317).withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 18, color: const Color(0xFF003317)),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Frais de livraison", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
            Text("${controller.deliveryFee} F", style: const TextStyle(fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("TOTAL À PAYER", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            Obx(() => Text("${controller.totalGlobal.value} F CFA", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Color(0xFF00A86B)))),
          ]),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      color: Colors.white,
      child: ElevatedButton(
        onPressed: () => controller.validerCommande(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.generalColor,
          minimumSize: const Size(double.infinity, 58),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
        ),
        child: const Text("CONFIRMER LA COMMANDE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15)),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'order_validation_controller.dart';
// import '../../../../servicesApp/urlBase.dart';
// import '../../../../loading/loading.dart';
// import '../../../../appColors/appColors.dart';

// class OrderValidationView extends GetView<OrderValidationController> {
//   const OrderValidationView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FD),
//       appBar: AppBar(
//         title: const Text("Récapitulatif de la commande",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//       ),
//       body: Obx(() {
//         if (controller.isProductLoading.value) {
//           return const Center(child: LoadingWidget(text: "Chargement..."));
//         }
//         return Column(
//           children: [
//             Expanded(
//               child: ListView(
//                 padding: const EdgeInsets.all(20),
//                 children: [
//                   // Liste des produits
//                   ...List.generate(controller.selectedProducts.length, 
//                       (index) => _buildProductCard(index)),
                  
//                   const SizedBox(height: 10),
                  
//                   // --- CHAMP DE LOCALISATION STYLE INKWELL ---
//                   _buildLocationSelector(),
                  
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//             _buildSummarySection(),
//           ],
//         );
//       }),
//       bottomNavigationBar: _buildBottomAction(),
//     );
//   }

//   Widget _buildProductCard(int index) {
//     var p = controller.selectedProducts[index];
//     var tarif = (p['tarifs'] != null && (p['tarifs'] as List).isNotEmpty) ? p['tarifs'][0] : {};

//     return Obx(() {
//       int qV = (p['qty_vente'] as RxInt).value;
//       int qR = (p['qty_recharge'] as RxInt).value;
//       int qE = (p['qty_echange'] as RxInt).value;

//       return Container(
//         margin: const EdgeInsets.only(bottom: 20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
//         ),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // --- IMAGE AGRANDIE (85x85) ---
//                   _buildProductImage(p['image'], size: 85),
//                   const SizedBox(width: 20),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("${p['marque_name'] ?? p['name']}",
//                             style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
//                         Text("Poids: ${p['poids_value']} kg",
//                             style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
//                         const SizedBox(height: 12),
                        
//                         if (controller.typeSelection == 1 && qV > 0) 
//                           _headerDetailRow("Vente", tarif['price_vente'], qV, Colors.blue),
//                         if (controller.typeSelection == 2 && qR > 0) 
//                           _headerDetailRow("Recharge", tarif['price_recharge'], qR, Colors.green),
//                         if (controller.typeSelection == 3 && qE > 0) 
//                           _headerDetailRow("Échange", tarif['price_echange'], qE, Colors.orange),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             if (controller.typeSelection == 3 && qE > 0) _buildExchangeSelector(p),

//             const Divider(height: 1),

//             if (controller.typeSelection == 1) 
//               _buildTypeRow(index, "vente", "Quantité Achat", Colors.blue, tarif['price_vente']),
//             if (controller.typeSelection == 2) 
//               _buildTypeRow(index, "recharge", "Quantité Recharge", Colors.green, tarif['price_recharge']),
//             if (controller.typeSelection == 3) 
//               _buildTypeRow(index, "echange", "Quantité Échange", Colors.orange, tarif['price_echange']),

//             const SizedBox(height: 10),
//           ],
//         ),
//       );
//     });
//   }

//   Widget _buildExchangeSelector(Map<String, dynamic> p) {
//     String productId = p['id'].toString();
//     return Obx(() {
//       String selectedId = controller.exchangeSelection[productId]?.value ?? "";
//       var selectedProd = controller.allAvailableProducts.firstWhere(
//           (el) => el['id'].toString() == selectedId, orElse: () => {});

//       return InkWell(
//         onTap: () => _showExchangePicker(p),
//         child: Container(
//           margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
//           padding: const EdgeInsets.all(18),
//           decoration: BoxDecoration(
//             color: AppColors.generalColor.withOpacity(0.06),
//             borderRadius: BorderRadius.circular(15),
//             border: Border.all(
//               width: 1.5,
//               color: selectedId == "" ? Colors.orange.withOpacity(0.4) : AppColors.generalColor
//             ),
//           ),
//           child: Row(
//             children: [
//               _buildProductImage(selectedProd['image'], size: 45),
//               const SizedBox(width: 15),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text("BOUTEILLE À RENDRE", 
//                         style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.blueGrey)),
//                     const SizedBox(height: 4),
//                     Text(
//                       selectedId == "" ? "Cliquez pour choisir le modèle" : "${selectedProd['marque_name'] ?? selectedProd['name']}",
//                       style: TextStyle(
//                           fontSize: 14,
//                           color: selectedId == "" ? Colors.orange[800] : Colors.black,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//               Icon(Icons.swap_horizontal_circle, color: AppColors.generalColor, size: 26),
//             ],
//           ),
//         ),
//       );
//     });
//   }

//   void _showExchangePicker(Map<String, dynamic> currentProd) {
//     final String currentId = currentProd['id'].toString();
//     final eligibleExchangeProds = controller.allAvailableProducts.where((item) {
//       return item['poids_value'].toString() == currentProd['poids_value'].toString() &&
//              item['id'].toString() != currentId;
//     }).toList();

//     Get.bottomSheet(
//       Container(
//         padding: const EdgeInsets.all(20),
//         decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
//             const SizedBox(height: 15),
//             const Text("Bouteille à rendre", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
//             const SizedBox(height: 20),
//             Flexible(
//               child: ListView.separated(
//                 shrinkWrap: true,
//                 itemCount: eligibleExchangeProds.length,
//                 separatorBuilder: (c, i) => const SizedBox(height: 10),
//                 itemBuilder: (context, index) {
//                   final item = eligibleExchangeProds[index];
//                   final String itemId = item['id'].toString();
//                   return Obx(() {
//                     bool isSelected = controller.exchangeSelection[currentId]?.value == itemId;
//                     return InkWell(
//                       onTap: () {
//                         controller.exchangeSelection[currentId]?.value = itemId;
//                         Future.delayed(const Duration(milliseconds: 250), () => Get.back());
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: isSelected ? AppColors.generalColor.withOpacity(0.05) : Colors.transparent,
//                           borderRadius: BorderRadius.circular(15),
//                           border: Border.all(color: isSelected ? AppColors.generalColor : Colors.grey.shade200),
//                         ),
//                         child: Row(
//                           children: [
//                             _buildProductImage(item['image'], size: 50),
//                             const SizedBox(width: 15),
//                             Expanded(child: Text("${item['marque_name'] ?? item['name']}")),
//                             if (isSelected) Icon(Icons.check_circle, color: AppColors.generalColor)
//                           ],
//                         ),
//                       ),
//                     );
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//     );
//   }

//   // --- NOUVEAU SELECTEUR DE LOCALISATION STYLE INKWELL ---
//   Widget _buildLocationSelector() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
//       ),
//       child: InkWell(
//         onTap: () {
//           // Logique pour ouvrir un sélecteur (BottomSheet ou Dialog)
//           _showLocationPicker();
//         },
//         borderRadius: BorderRadius.circular(15),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//           child: Row(
//             children: [
//               Icon(Icons.location_on_rounded, color: AppColors.generalColor, size: 22),
//               const SizedBox(width: 15),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text("ZONE DE LIVRAISON", 
//                       style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 0.5)),
//                     Obx(() => Text(controller.selectedLocation.value, 
//                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
//                   ],
//                 ),
//               ),
//               Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade400, size: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Petit Picker pour la localisation
//   void _showLocationPicker() {
//     Get.bottomSheet(
//       Container(
//         padding: const EdgeInsets.all(20),
//         decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
//             const SizedBox(height: 20),
//             const Text("Sélectionner votre ville", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
//             const SizedBox(height: 15),
//             ...controller.locations.map((loc) => ListTile(
//               leading: Icon(Icons.location_on_rounded, color: AppColors.generalColor),
//               title: Text(loc, style: const TextStyle(fontWeight: FontWeight.bold)),
//               onTap: () {
//                 controller.selectedLocation.value = loc;
//                 Get.back();
//               },
//             )).toList(),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProductImage(String? imagePath, {double size = 60}) {
//     final String fullImageUrl = (imagePath != null && imagePath.isNotEmpty) ? "${ApiUrlPage.baseUrl}$imagePath" : "";
//     return Container(
//       height: size, width: size,
//       decoration: BoxDecoration(
//         color: Colors.grey[50], 
//         borderRadius: BorderRadius.circular(12), 
//         border: Border.all(color: Colors.grey.shade100)
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: fullImageUrl.isNotEmpty 
//             ? Image.network(fullImageUrl, fit: BoxFit.contain) 
//             : const Icon(Icons.propane_tank, color: Color(0xFF003317), size: 30),
//       ),
//     );
//   }

//   Widget _headerDetailRow(String title, dynamic price, int qty, Color color) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 4),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//             decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
//             child: Text(title, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
//           ),
//           const SizedBox(width: 8),
//           Text("$price F x $qty", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
//         ],
//       ),
//     );
//   }

//   Widget _buildTypeRow(int index, String type, String label, Color color, dynamic price) {
//     var p = controller.selectedProducts[index];
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
//           Row(
//             children: [
//               _qtyBtn(Icons.remove, () => controller.updateQty(index, type, false)),
//               Obx(() => Container(
//                     width: 40, alignment: Alignment.center,
//                     child: Text("${p['qty_$type'].value}", style: const TextStyle(fontWeight: FontWeight.w900)),
//                   )),
//               _qtyBtn(Icons.add, () => controller.updateQty(index, type, true)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _qtyBtn(IconData icon, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(6),
//         decoration: BoxDecoration(color: const Color(0xFF003317).withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
//         child: Icon(icon, size: 18, color: const Color(0xFF003317)),
//       ),
//     );
//   }

//   Widget _buildSummarySection() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
//         borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
//       ),
//       child: Column(
//         children: [
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//             const Text("Frais de livraison", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
//             Text("${controller.deliveryFee} F", style: const TextStyle(fontWeight: FontWeight.bold)),
//           ]),
//           const SizedBox(height: 12),
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//             const Text("TOTAL À PAYER", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
//             Obx(() => Text("${controller.totalGlobal.value} F CFA", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Color(0xFF00A86B)))),
//           ]),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomAction() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
//       color: Colors.white,
//       child: ElevatedButton(
//         onPressed: () => controller.validerCommande(),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF003317),
//           minimumSize: const Size(double.infinity, 58),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//           elevation: 0,
//         ),
//         child: const Text("CONFIRMER LA COMMANDE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15)),
//       ),
//     );
//   }
// }