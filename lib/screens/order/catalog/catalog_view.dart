import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'catalog_controller.dart';
import '../../../servicesApp/urlBase.dart';
import '../../../appColors/appColors.dart';
import '../../../routes/app_routes.dart';
import '../../../../loading/loading.dart';

class CatalogView extends GetView<CatalogController> {
  const CatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text("Choisir une bouteille",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      bottomNavigationBar: _buildBottomAction(),
      body: Column(
        children: [
          _buildBrandDropdown(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.products.isEmpty) {
                return const Center(child: LoadingWidget(text: "Chargement..."));
              }

              if (controller.filteredProducts.isEmpty) {
                return const Center(
                    child: Text("Aucune bouteille disponible",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold)));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                physics: const BouncingScrollPhysics(),
                itemCount: controller.filteredProducts.length,
                itemBuilder: (context, index) =>
                    _buildProductRow(context, controller.filteredProducts[index]),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildProductRow(BuildContext context, Map<String, dynamic> product) {
    return Obx(() {
      bool isSelected = controller.selectedProductsIds.contains(product['id']);
      
      String poids = product['poids_value']?.toString() ?? "0";
      int pRecharge = product['price_recharge'] ?? 0;
      int pVente = product['price_vente'] ?? 0;
      int pEchange = product['price_echange'] ?? 0;

      int stockRecharge = product['full'] ?? 0;
      int stockVente = product['empty'] ?? 0;
      int stockEchange = product['damaged'] ?? 0;

      // VERIFICATION DU STOCK TOTAL
      bool hasStock = (stockRecharge + stockVente + stockEchange) > 0;

      final String fullImageUrl = (product['image'] != null && product['image'].isNotEmpty)
          ? "${ApiUrlPage.baseUrl}${product['image']}"
          : "";

      return GestureDetector(
        onTap: hasStock 
            ? () => Get.toNamed(Routes.DETAILPRODUIT, arguments: product['id'])
            : null,
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            // CHANGEMENT ICI : Le fond devient gris clair si pas de stock, sinon blanc
            color: hasStock ? Colors.white : Colors.grey.shade200, 
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
                color: isSelected ? AppColors.generalColor : Colors.transparent,
                width: 2),
            boxShadow: [
              if (hasStock) BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)
            ],
          ),
          child: Row(
            children: [
              // IMAGE
              Container(
                height: 90, width: 90,
                decoration: BoxDecoration(
                  // Petit rappel visuel sur le fond de l'image aussi
                  color: hasStock ? Colors.grey[50] : Colors.grey[300], 
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Hero(
                  tag: "img_${product['id']}",
                  child: fullImageUrl.isNotEmpty
                      ? Image.network(fullImageUrl, fit: BoxFit.contain, 
                          errorBuilder: (c, e, s) => const Icon(Icons.propane_tank, color: Colors.grey))
                      : const Icon(Icons.propane_tank, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 15),

              // INFOS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(product['name'].toString().toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w900, 
                                fontSize: 14,
                                // Texte un peu plus discret si pas de stock
                                color: hasStock ? Colors.black : Colors.grey[600] 
                              )),
                        ),
                        
                        // COCHE CARRÉE (Invisible si pas de stock pour éviter la confusion)
                        if (hasStock)
                          GestureDetector(
                            onTap: () => controller.toggleSelection(product['id']),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.generalColor : Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: isSelected ? AppColors.generalColor : Colors.grey.shade300),
                              ),
                              child: Icon(Icons.check, size: 14, color: isSelected ? Colors.white : Colors.transparent),
                            ),
                          )
                        else
                          // Petit badge "Épuisé" à la place de la coche
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(4)),
                            child: const Text("VIDE", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                    Text("$poids kg",
                        style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                    
                    const SizedBox(height: 12),
                    
                    // SECTION DES PRIX ET STOCKS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _priceIndicator(stockRecharge, pRecharge, hasStock ? Colors.green : Colors.grey, "RECHARGE"),
                        _priceIndicator(stockVente, pVente, hasStock ? Colors.orange : Colors.grey, "VENTE"),
                        _priceIndicator(stockEchange, pEchange, hasStock ? Colors.blue : Colors.grey, "ECHANGE"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // LA MÉTHODE QUI MANQUAIT (ou qui était mal nommée)
  Widget _priceIndicator(int count, int price, Color color, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 7, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text("$price F", 
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.black87)),
        Text("$count disp.", 
          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildBrandDropdown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: Obx(() {
        List<String> brands = controller.products.map((e) => e['name'].toString()).toSet().toList();
        if (!brands.contains("TOUS LES PRODUITS")) brands.insert(0, "TOUS LES PRODUITS");

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.selectedBrand.value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black, size: 28),
              items: brands.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, 
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 14)),
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: hasSelection 
              ? () => Get.toNamed(Routes.CHECKOUT, arguments: {
                  'products': controller.selectedProductsList, 
                  'orderId': controller.orderId
                })
              : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.generalColor,
              disabledBackgroundColor: Colors.grey.shade300,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(
              hasSelection ? "VOIR LE PANIER ($count)" : "SÉLECTIONNEZ UNE BOUTEILLE",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ),
      );
    });
  }
}