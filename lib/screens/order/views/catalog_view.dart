import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/catalog_controllers.dart';
import '../../../servicesApp/urlBase.dart';
import '../../../appColors/appColors.dart';
import '../../../routes/app_routes.dart';

class CatalogView extends GetView<CatalogController> {
  const CatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text("Choisir une bouteille", 
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // --- BARRE DE RECHERCHE STYLEE ---
          _buildSearchBar(),

          // --- GRILLE DE PRODUITS ---
          Expanded(
            child: Obx(() {
              if (controller.filteredProducts.isEmpty && controller.products.isNotEmpty) {
                return _buildEmptySearchState();
              }
              
              if (controller.products.isEmpty) {
                return const SizedBox.shrink();
              }

              return GridView.builder(
                padding: const EdgeInsets.all(20),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: controller.filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = controller.filteredProducts[index];
                  return _buildProductCard(context, product);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: TextField(
          onChanged: (value) => controller.searchQuery.value = value,
          decoration: InputDecoration(
            hintText: "Rechercher une bouteille ou marque...",
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            prefixIcon: Icon(Icons.search_rounded, color: AppColors.generalColor),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    bool isAvailable = product['available'];
    int stockRestant = product['stock'] ?? 0;
    
    final String fullImageUrl = (product['image'] != null && product['image'].isNotEmpty)
        ? "${ApiUrlPage.baseUrl}${product['image']}"
        : "";

    return GestureDetector(
      onTap: isAvailable 
        ? () => Get.toNamed(Routes.CHECKOUT, arguments: {
            'product': product, 
            'orderId': controller.orderId
          }) 
        : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Column(
          children: [
            // ZONE IMAGE ET BADGE STOCK
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(15)),
                      child: Hero(
                        tag: "gas_${product['id']}",
                        child: fullImageUrl.isNotEmpty
                            ? Image.network(
                                fullImageUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (c, e, s) => _buildPlaceholderIcon(isAvailable),
                              )
                            : _buildPlaceholderIcon(isAvailable),
                      ),
                    ),
                    // BADGE STOCK POSITIONNÉ
                    Positioned(
                      top: -5,
                      right: -5,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: stockRestant < 5 ? Colors.red : AppColors.generalColor, 
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(
                          "$stockRestant",
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // ZONE INFOS
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Text(product['name'], 
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                    Text(product['weight'], 
                      style: TextStyle(color: Colors.grey[400], fontSize: 11, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isAvailable ? AppColors.generalColor : Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Text("${product['price']} F", 
                            style: TextStyle(
                              fontWeight: FontWeight.w900, 
                              fontSize: 13,
                              color: isAvailable ? Colors.white : Colors.grey[600])),
                          if (!isAvailable)
                            const Text("RUPTURE", style: TextStyle(color: Colors.red, fontSize: 8, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon(bool isAvailable) {
    return Icon(Icons.propane_tank, size: 45, color: isAvailable ? AppColors.generalColor.withOpacity(0.1) : Colors.grey[200]);
  }

  Widget _buildEmptySearchState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          const Text("Aucun résultat pour votre recherche", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}