import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../servicesApp/apiServices.dart';
import '../../../../loading/loading.dart';
import '../../../../alerte/alerte.dart';
import '../../../../appColors/appColors.dart';
import '../../../../screens/history/activity/controllers/activity_controller.dart';


class CheckoutController extends GetxController {
  final apiservices = ApiService(); 
  
  late final String productId;
  late final String? orderId;
  late final String ?orderupadteId;

  var product = <String, dynamic>{}.obs;
  var isProductLoading = true.obs;

  final int deliveryFee = 1500;
  
  var quantity = 1.obs;
  var total = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    
    productId = args['product']?['id'] ?? "";
    orderId = args['orderId']; 

    _loadFreshProductData();
  }
  Future<void> _loadFreshProductData() async {
    try {
      
      isProductLoading.value = true;
      final freshData = await apiservices.getStocksDetails(productId);
      
      if (freshData != null) {
        product.value = {
          "id": freshData['id'],
          "name": freshData['marque_name'] ?? "Inconnu",
          "price": (freshData['tarif'] as num?)?.toInt() ?? 0,
          "stock": (freshData['stock'] as num?)?.toInt() ?? 0,
          "weight": "${freshData['poids_value']} kg",
          "image": freshData['image'],
        };
        _calculateTotals();
      } else {
        throw Exception("Produit introuvable");
      }
    } catch (e) {
      Alerte.show(title: "Erreur", message: "Impossible de charger les données", color: Colors.red);
    } finally {
      isProductLoading.value = false;
    }
  }

  void _calculateTotals() {
    if (product.isEmpty) return;
    int unitPrice = (product['price'] as int?) ?? 0;
    total.value = (unitPrice * quantity.value) + deliveryFee;
  }

  void addQuantity() {
    int availableStock = product['stock'] ?? 0;
    if (quantity.value < availableStock) {
      quantity.value++;
      _calculateTotals();
    } else {
      Get.snackbar(
        "Stock insuffisant", 
        "Il ne reste que $availableStock bouteilles en stock.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white
      );
    }
  }

  void removeQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
      _calculateTotals();
    }
  }

  Future<void> validerCommande() async {
    if (isProductLoading.value) return;

    try {
      LoadingModal.show(text: orderId != null ? "Mise à jour..." : "Validation...");

      Map<String, dynamic> commandeData = {
        "prix_livraison": deliveryFee.toString(),
        "items": [
          {
            "produit": product['id'],
            "quantity": quantity.value,
            "prix_unitaire": product['price'].toString()
          }
        ]
      };

      bool success;
      if (orderId != null) {
        success = await apiservices.updateCommande(orderId!, commandeData);
      } else {
        success = await apiservices.createCommande(commandeData);
      }

      LoadingModal.hide();

      if (success) {
        back(2);

        if (orderId != null)
        {    
        back(4);
        }
        
        Alerte.show(
          title: "Succès",
          message: orderId != null ? "Commande mise à jour !" : "Commande enregistrée !",
          imagePath: "assets/images/succes.png",
          color: AppColors.generalColor
        );

        if (Get.isRegistered<ActivityController>()) {
          final activityController = Get.find<ActivityController>();
          await activityController.fetchOrders();
        }
      } else {
        Alerte.show(title: "Erreur", message: "Échec de l'opération", color: Colors.red);
      }
    } catch (e) {
      LoadingModal.hide();
      Alerte.show(title: "Erreur", message: e.toString(), color: Colors.red);
    }
  }
    void back(int value) {
    for (int i = 0; i < value; i++) {
      if (Get.key.currentState?.canPop() ?? false) {
        Get.back();
      } else {
        break;
      }
    }
  }


}