import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'change_controller.dart';
import '../../../../servicesApp/urlBase.dart';
import '../../../../appColors/appColors.dart';
import '../../../../routes/app_routes.dart';
import '../../../../loading/loading.dart';

class ChangeView extends GetView<ChangeController> {
  const ChangeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Echange  debouteille",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor:AppColors.generalColor,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.05),
        centerTitle: false,
        actions: [
          Obx(() => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.generalColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        size: 22,
                        color: Colors.white,
                      ),
                    ),
                    if (controller.selectedProductsIds.length > 0)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Text(
                            '${controller.selectedProductsIds.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )),
        ],
      ),
      bottomNavigationBar: _buildBottomAction(),
      body: Column(
        children: [
          _buildBrandDropdown(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.products.isEmpty) {
                return const Center(
                  child: LoadingWidget(
                    text: "Chargement du catalogue...",
                  ),
                );
              }

              if (controller.filteredProducts.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                physics: const BouncingScrollPhysics(),
                itemCount: controller.filteredProducts.length,
                itemBuilder: (context, index) =>
                    _buildProductCard(context, controller.filteredProducts[index]),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inbox_outlined,
              size: 60,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Aucune bouteille disponible",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Veuillez vérifier ultérieurement",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    return Obx(() {
      bool isSelected = controller.selectedProductsIds.contains(product['id']);
      String poids = product['poids_value']?.toString() ?? "0";
      
      int pEchange = product['price_echange'] ?? 0;
      int stockEchange = product['damaged'] ?? 0;

      bool hasStock = stockEchange > 0;

      final String fullImageUrl = (product['image'] != null && product['image'].isNotEmpty)
          ? "${ApiUrlPage.baseUrl}${product['image']}"
          : "";

      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: hasStock
                ? () => Get.toNamed(Routes.DETAILPRODUIT, arguments: product['id'])
                : null,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected ? AppColors.generalColor : Colors.grey.shade200,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header avec badge de statut
                  if (!hasStock)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(23),
                          topRight: Radius.circular(23),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Rupture de stock",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image avec badge de sélection et badge de stock
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              child: Hero(
                                tag: "img_${product['id']}",
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: fullImageUrl.isNotEmpty
                                      ? Image.network(
                                          fullImageUrl,
                                          fit: BoxFit.contain,
                                          errorBuilder: (c, e, s) => Container(
                                            color: Colors.grey.shade100,
                                            child: Icon(
                                              Icons.propane_tank_outlined,
                                              size: 40,
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          color: Colors.grey.shade100,
                                          child: Icon(
                                            Icons.propane_tank_outlined,
                                            size: 40,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            if (hasStock)
                              Positioned(
                                top: -8,
                                right: -8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.generalColor,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    "$stockEchange",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            if (isSelected)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration:  BoxDecoration(
                                    color: AppColors.generalColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 16),

                        // Informations produit
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      product['name'].toString().toUpperCase(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                        color: hasStock ? Colors.black87 : Colors.grey.shade500,
                                      ),
                                    ),
                                  ),
                                  if (hasStock)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.generalColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "$stockEchange disponible${stockEchange > 1 ? 's' : ''}",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.generalColor,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "$poids kg",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Prix d'échange
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "PRIX ÉCHANGE",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        "$pEchange",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w900,
                                          color: hasStock ?AppColors.generalColor : Colors.grey.shade400,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        "FCFA",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: hasStock ? Colors.grey.shade600 : Colors.grey.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bouton de sélection
                  if (hasStock)
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: ElevatedButton(
                        onPressed: () => controller.toggleSelection(product['id']),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected ? Colors.white : AppColors.generalColor,
                          foregroundColor: isSelected ? AppColors.generalColor : Colors.white,
                          side: isSelected ? BorderSide(color:AppColors.generalColor) : null,
                          minimumSize: const Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          isSelected ? "RETIRER" : "AJOUTER",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildBrandDropdown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Obx(() {
        List<String> brands = controller.products
            .map((e) => e['name'].toString())
            .toSet()
            .toList();
        if (!brands.contains("TOUS LES PRODUITS")) {
          brands.insert(0, "TOUS LES PRODUITS");
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.selectedBrand.value,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.generalColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.generalColor,
                  size: 20,
                ),
              ),
              items: brands.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: controller.selectedBrand.value == value
                          ? AppColors.generalColor
                          : Colors.black87,
                      fontWeight: controller.selectedBrand.value == value
                          ? FontWeight.w700
                          : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (v) => controller.selectedBrand.value = v!,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBottomAction() {
    return Obx(() {
      int count = controller.selectedProductsIds.length;
      bool hasSelection = count > 0;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: hasSelection
                      ? () => Get.toNamed(Routes.ORDERVALIDATION, arguments: {
                          'products': controller.selectedProductsList,
                          'number': 3,
                        })
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.generalColor,
                    disabledBackgroundColor: Colors.grey.shade200,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 20,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        hasSelection 
                          ? "PASSER AU PAIEMENT${count > 0 ? ' ($count)' : ''}" 
                          : "SÉLECTIONNER",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'change_controller.dart';
// import '../../../../servicesApp/urlBase.dart';
// import '../../../../appColors/appColors.dart';
// import '../../../../routes/app_routes.dart';
// import '../../../../loading/loading.dart';

// class ChangeView extends GetView<ChangeController> {
//   const ChangeView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FD),
//       appBar: AppBar(
//         title: const Text("Espace échange bouteille",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//       ),
//       bottomNavigationBar: _buildBottomAction(),
//       body: Column(
//         children: [
//           _buildBrandDropdown(),
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value && controller.products.isEmpty) {
//                 return const Center(child: LoadingWidget(text: "Chargement..."));
//               }

//               if (controller.filteredProducts.isEmpty) {
//                 return const Center(
//                     child: Text("Aucune bouteille disponible",
//                         style: TextStyle(
//                             color: Colors.grey, fontWeight: FontWeight.bold)));
//               }

//               return ListView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 physics: const BouncingScrollPhysics(),
//                 itemCount: controller.filteredProducts.length,
//                 itemBuilder: (context, index) =>
//                     _buildProductRow(context, controller.filteredProducts[index]),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProductRow(BuildContext context, Map<String, dynamic> product) {
//     return Obx(() {
//       bool isSelected = controller.selectedProductsIds.contains(product['id']);
//       String poids = product['poids_value']?.toString() ?? "0";
      
//       // Extraction données échange
//       int pEchange = product['price_echange'] ?? 0;
//       int stockEchange = product['damaged'] ?? 0; 

//       bool hasStock = stockEchange > 0;

//       final String fullImageUrl = (product['image'] != null && product['image'].isNotEmpty)
//           ? "${ApiUrlPage.baseUrl}${product['image']}"
//           : "";

//       return GestureDetector(
//         onTap: hasStock 
//             ? () => Get.toNamed(Routes.DETAILPRODUIT, arguments: product['id'])
//             : null,
//         child: Container(
//           margin: const EdgeInsets.only(bottom: 15),
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: hasStock ? Colors.white : Colors.grey.shade200, 
//             borderRadius: BorderRadius.circular(18),
//             border: Border.all(
//                 color: isSelected ? AppColors.generalColor : Colors.transparent,
//                 width: 2),
//             boxShadow: [
//               if (hasStock) BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)
//             ],
//           ),
//           child: Row(
//             children: [
//               // IMAGE AVEC BADGE DE STOCK POSITIONNÉ
//               Stack(
//                 clipBehavior: Clip.none,
//                 children: [
//                   Container(
//                     height: 90, width: 90,
//                     decoration: BoxDecoration(
//                       color: hasStock ? Colors.grey[50] : Colors.grey[300], 
//                       borderRadius: BorderRadius.circular(12)
//                     ),
//                     child: Hero(
//                       tag: "img_${product['id']}",
//                       child: fullImageUrl.isNotEmpty
//                           ? Image.network(fullImageUrl, fit: BoxFit.contain, 
//                               errorBuilder: (c, e, s) => const Icon(Icons.propane_tank, color: Colors.grey))
//                           : const Icon(Icons.propane_tank, color: Colors.grey),
//                     ),
//                   ),
//                   // BADGE STOCK DISPONIBLE (Positioned sur l'image)
//                   if (hasStock)
//                     Positioned(
//                       top: -5,
//                       right: -5,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: AppColors.generalColor,
//                           borderRadius: BorderRadius.circular(10),
//                           boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
//                         ),
//                         child: Text(
//                           "$stockEchange Bouteille(s)",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 9,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//               const SizedBox(width: 15),

//               // INFOS
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Text(product['name'].toString().toUpperCase(),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w900, 
//                                 fontSize: 14,
//                                 color: hasStock ? Colors.black : Colors.grey[600] 
//                               )),
//                         ),
                        
//                         if (hasStock)
//                           GestureDetector(
//                             onTap: () => controller.toggleSelection(product['id']),
//                             child: Container(
//                               padding: const EdgeInsets.all(4),
//                               decoration: BoxDecoration(
//                                 color: isSelected ? AppColors.generalColor : Colors.white,
//                                 shape: BoxShape.rectangle,
//                                 borderRadius: BorderRadius.circular(6),
//                                 border: Border.all(color: isSelected ? AppColors.generalColor : Colors.grey.shade300),
//                               ),
//                               child: Icon(Icons.check, size: 14, color: isSelected ? Colors.white : Colors.transparent),
//                             ),
//                           )
//                         else
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                             decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(4)),
//                             child: const Text("EPUISE", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
//                           ),
//                     ],
//                   ),
//                   Text("$poids kg",
//                       style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                  
//                   const SizedBox(height: 8),
                  
//                   // AFFICHAGE DU PRIX ÉCHANGE
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text("PRIX ÉCHANGE", style: TextStyle(fontSize: 7, color: Colors.black, fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 2),
//                       Text("$pEchange F", 
//                         style: TextStyle(
//                           fontSize: 18, 
//                           fontWeight: FontWeight.w900, 
//                           color: hasStock ? AppColors.generalColor : Colors.grey
//                         )),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   });
// }

//   Widget _buildBrandDropdown() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
//       child: Obx(() {
//         List<String> brands = controller.products.map((e) => e['name'].toString()).toSet().toList();
//         if (!brands.contains("TOUS LES PRODUITS")) brands.insert(0, "TOUS LES PRODUITS");

//         return Container(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(15),
//             boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
//             border: Border.all(color: Colors.grey.shade100),
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               dropdownColor: Colors.white,
//               value: controller.selectedBrand.value,
//               isExpanded: true,
//               icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black, size: 28),
//               items: brands.map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value, 
//                     style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 14)),
//                 );
//               }).toList(),
//               onChanged: (v) => controller.selectedBrand.value = v!,
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildBottomAction() {
//     return Obx(() {
//       int count = controller.selectedProductsIds.length;
//       bool hasSelection = count > 0;
//       return Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
//         ),
//         child: SafeArea(
//           child: ElevatedButton(
//             onPressed: hasSelection 
//               ? () => Get.toNamed(Routes.ORDERVALIDATION, arguments: {
//                   'products': controller.selectedProductsList, 
//                   'number': 3,
//                 })
//               : null,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.generalColor,
//               disabledBackgroundColor: Colors.grey.shade300,
//               minimumSize: const Size(double.infinity, 55),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//             ),
//             child: Text(
//               hasSelection ? "PASSER AU PAIEMENT ($count)" : "SÉLECTIONNEZ UNE BOUTEILLE",
//               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }