import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../servicesApp/apiServices.dart';
import '../../../loading/loading.dart';
import '../../../alerte/alerte.dart';

class CatalogController extends GetxController {
  final apiservices = ApiService(); 
  String? orderId;

  // Liste brute de l'API
  var products = <Map<String, dynamic>>[].obs;
  
  // Variable pour la recherche
  var searchQuery = "".obs;

  @override
  void onInit() {
    super.onInit();
    // Récupération de l'ID (soit direct, soit via un Map d'arguments)
    if (Get.arguments is Map) {
      orderId = Get.arguments['id'];
    } else {
      orderId = Get.arguments as String?;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProduits();
    });
  }

  // Getter qui filtre la liste en temps réel
  List<Map<String, dynamic>> get filteredProducts {
    if (searchQuery.value.isEmpty) {
      return products;
    } else {
      return products.where((p) {
        final name = p['name'].toString().toLowerCase();
        final weight = p['weight'].toString().toLowerCase();
        final query = searchQuery.value.toLowerCase();
        return name.contains(query) || weight.contains(query);
      }).toList();
    }
  }

  Future<void> getProduits() async {
    try {
      LoadingModal.show();
      final response = await apiservices.getProduits(); 
      
      if (response != null && response is List) {
        List<Map<String, dynamic>> fetchedItems = response.map((item) {
          return {
            "id": item['id'], 
            "name": item['marque_name'] ?? "Inconnu",
            "weight": "${item['poids_value']} kg",
            "price": (item['tarif'] as num?)?.toInt() ?? 0,
            "stock": (item['stock'] as num?)?.toInt() ?? 0,
            "image": item['image'],
            "available": (item['stock'] as num?) != null && (item['stock'] as num) > 0,
          };
        }).toList();
        
        products.assignAll(fetchedItems); 
      }
    } catch (e) {
      Alerte.show(title: "Erreur", message: "Impossible de charger les produits", color: Colors.red);
    } finally {
      LoadingModal.hide();
    }
  }
}