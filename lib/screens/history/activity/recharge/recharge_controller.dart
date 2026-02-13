import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../servicesApp/apiServices.dart';
import '../../../../alerte/alerte.dart';

class RechargeController extends GetxController {
  final apiservices = ApiService(); 
  String? orderId;

  var products = <Map<String, dynamic>>[].obs;
  var selectedBrand = "TOUS LES PRODUITS".obs;
  var isLoading = false.obs;
  
  // LISTE des IDs sélectionnés
  var selectedProductsIds = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Map) {
      orderId = Get.arguments['id']?.toString();
    } else {
      orderId = Get.arguments?.toString();
    }
    getProduits();
  }

  //Fonction pour ajouter/retirer un produit de la sélection
  void toggleSelection(String id) {
    if (selectedProductsIds.contains(id)) {
      selectedProductsIds.remove(id);
    } else {
      selectedProductsIds.add(id);
    }
  }

  // Retourne la liste des objets produits complets sélectionnés
  List<Map<String, dynamic>> get selectedProductsList {
    return products.where((p) => selectedProductsIds.contains(p['id'])).toList();
  }

  List<Map<String, dynamic>> get filteredProducts {
    return products.where((p) {
      return selectedBrand.value == "TOUS LES PRODUITS" || 
             p['name'].toString().toUpperCase() == selectedBrand.value.toUpperCase();
    }).toList();
  }

  Future<void> getProduits() async {
  try {
    isLoading.value = true;
    final response = await apiservices.getProduits(); 
    
    if (response != null && response is List) {
      List<Map<String, dynamic>> fetchedItems = response.map((item) {
        // 1. Gestion du TARIF (Objet direct 'tarif')
        var t = item['tarif'] ?? {}; 
        int pRecharge = (double.tryParse(t['price_recharge']?.toString() ?? '0') ?? 0.0).toInt();
        int pVente = (double.tryParse(t['price_vente']?.toString() ?? '0') ?? 0.0).toInt();
        int pEchange = (double.tryParse(t['price_echange']?.toString() ?? '0') ?? 0.0).toInt();

        // 2. Gestion du STOCK (Objet 'stock')
        var s = item['stock'] ?? {};
        int qteRecharge = int.tryParse(s['recharge']?.toString() ?? '0') ?? 0;
        int qteVente = int.tryParse(s['vente']?.toString() ?? '0') ?? 0;
        int qteEchange = int.tryParse(s['echange']?.toString() ?? '0') ?? 0;

        // 3. Gestion du POIDS (poids_value)
        String poids = item['poids_value']?.toString() ?? '0';

        return {
          "id": item['id'].toString(),
          "name": item['marque_name'] ?? item['name'] ?? "Inconnu",
          "poids_value": poids,
          "price_recharge": pRecharge,
          "price_vente": pVente,
          "price_echange": pEchange,
          "full": qteRecharge,
          "empty": qteVente,
          "damaged": qteRecharge,
          "image": item['image'],
          "available": (qteRecharge + qteVente + qteEchange) > 0, 
        };
      }).toList();
      
      products.assignAll(fetchedItems);
    }
  } catch (e) {
    print("Erreur mapping: $e");
    Alerte.show(title: "Erreur", message: "Problème de données", color: Colors.red);
  } finally {
    isLoading.value = false;
  }
}
}