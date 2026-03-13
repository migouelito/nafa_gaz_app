import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../servicesApp/apiServices.dart';
import '../../../loading/loading.dart';
import '../../../alerte/alerte.dart';
import '../../../appColors/appColors.dart';

class CheckoutController extends GetxController {
  final apiservices = ApiService(); 
  
  String? orderId;
  var selectedProducts = <Map<String, dynamic>>[].obs;
  var allAvailableProducts = <Map<String, dynamic>>[].obs; 
  var isProductLoading = true.obs;
  
  // --- GESTION DYNAMIQUE DES ADRESSES ---
  var addresses = <dynamic>[].obs;
  var selectedAddressId = "".obs;
  var isAddressLoading = false.obs;

  var exchangeSelection = <String, RxString>{}.obs;

  final int deliveryFee = 1500;
  var totalGlobal = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    orderId = args['orderId']; 
    
    List<String> productIds = args['productIds'] != null 
        ? List<String>.from(args['productIds']) 
        : [];
        
    _initializeData(productIds);
    refreshAddresses(); // Chargement des adresses dès le début
  }

  Future<void> _initializeData(List<String> productIds) async {
    try {
      isProductLoading.value = true;
      
      final productsFromApi = await apiservices.getProduits();
      if (productsFromApi != null) {
        allAvailableProducts.assignAll(List<Map<String, dynamic>>.from(productsFromApi));
      }

      await _loadFullDetailsByIds(productIds);
    } catch (e) {
      print("Erreur initialisation: $e");
    } finally {
      isProductLoading.value = false;
    }
  }

  Future<void> _loadFullDetailsByIds(List<String> productIds) async {
    List<Map<String, dynamic>> fullProducts = [];
    Map<String, dynamic>? existingOrder;

    if (orderId != null) {
      existingOrder = await apiservices.fetchCommandeDetail(orderId!);
    }

    for (String id in productIds) {
      final details = await apiservices.getProduitDetail(id);
      
      if (details != null) {
        var genericTarifs = details['tarifs'] ?? (details['tarif'] != null ? [details['tarif']] : []);
        RxInt qV = 0.obs; RxInt qR = 0.obs; RxInt qE = 0.obs;
        RxString selectedExchangeId = "".obs;

        if (existingOrder != null && existingOrder['items'] != null) {
          for (var i in existingOrder['items']) {
            String iProdId = (i['produit'] is Map) ? i['produit']['id'].toString() : i['produit'].toString();
            if (iProdId == id) {
              int qty = int.tryParse(i['quantity'].toString()) ?? 0;
              String type = i['type_commerce'].toString().toLowerCase();
              if (type == 'vente') qV.value = qty;
              else if (type == 'recharge') qR.value = qty;
              else if (type == 'echange') {
                qE.value = qty;
                selectedExchangeId.value = i['produit_echanger']?.toString() ?? "";
              }
            }
          }
        }

        exchangeSelection[id] = selectedExchangeId;
        fullProducts.add({
          ...details,
          'tarifs': genericTarifs, 
          "qty_vente": qV, "qty_recharge": qR, "qty_echange": qE,
        });
      }
    }
    selectedProducts.assignAll(fullProducts);
    _calculateTotalGlobal();
  }

  void _calculateTotalGlobal() {
    int sum = 0;
    for (var p in selectedProducts) {
      var tarifs = p['tarifs'] as List;
      if (tarifs.isEmpty) continue;
      var tarif = tarifs[0];
      sum += (double.parse(tarif['price_vente']?.toString() ?? '0').toInt() * (p['qty_vente'] as RxInt).value) +
             (double.parse(tarif['price_recharge']?.toString() ?? '0').toInt() * (p['qty_recharge'] as RxInt).value) +
             (double.parse(tarif['price_echange']?.toString() ?? '0').toInt() * (p['qty_echange'] as RxInt).value);
    }
    totalGlobal.value = (sum > 0) ? sum + deliveryFee : 0;
  }

  void updateQty(int index, String type, bool increase) {
    var p = selectedProducts[index];
    RxInt q = p['qty_$type'];
    if (increase) q.value++; else if (q.value > 0) q.value--;
    _calculateTotalGlobal();
  }

  Map<String, dynamic> _mapItem(Map p, String type, int qty) {
    var tarif = (p['tarifs'] as List)[0];
    String prix = tarif['price_$type']?.toString() ?? "0";
    String productId = p['id'].toString();
    String? prodEchanger = exchangeSelection[productId]?.value;
    if (prodEchanger == "") prodEchanger = null;

    return {
      "type_commerce": type,
      "produit": productId, 
      "produit_echanger": prodEchanger, 
      "quantity": qty,
      "prix_unitaire": prix,
    };
  }

  Future<bool> validerCommande() async {
    if (totalGlobal.value == 0) return false;

    // Vérification de l'adresse
    if (selectedAddressId.value.isEmpty) {
      Alerte.show(title: "Adresse", message: "Veuillez choisir un lieu de livraison", imagePath: "assets/images/error.png", color: Colors.red);
      return false;
    }

    for (var p in selectedProducts) {
      if (p['qty_echange'].value > 0 && (exchangeSelection[p['id'].toString()]?.value == "" || exchangeSelection[p['id'].toString()]?.value == null)) {
        Alerte.show(title: "Échange", message: "Choisissez la bouteille à rendre pour ${p['name']}", imagePath: "assets/images/error.png", color: Colors.red);
        return false;
      }
    }

    try {
      LoadingModal.show(text: "Validation...");
      List itemsFinal = [];
      for (var p in selectedProducts) {
        if (p['qty_vente'].value > 0) itemsFinal.add(_mapItem(p, "vente", p['qty_vente'].value));
        if (p['qty_recharge'].value > 0) itemsFinal.add(_mapItem(p, "recharge", p['qty_recharge'].value));
        if (p['qty_echange'].value > 0) itemsFinal.add(_mapItem(p, "echange", p['qty_echange'].value));
      }

      bool success = orderId != null 
          ? await apiservices.updateCommande(orderId!, {"lieu_livraison": selectedAddressId.value, "prix_livraison": deliveryFee.toString(), "items": itemsFinal})
          : await apiservices.createCommande({"lieu_livraison": selectedAddressId.value, "prix_livraison": deliveryFee.toString(), "items": itemsFinal});

      LoadingModal.hide();
      if (success) { 
       await Alerte.show(title: "Succès", message: "Commande confirmée", imagePath: "assets/images/succes.png", color: AppColors.generalColor); 
      }
      return true;
    } catch (e) { LoadingModal.hide(); 
    return false;}
  }

  Future<void> refreshAddresses() async {
    try {
      isAddressLoading.value = true;
      final List<dynamic> fetchedData = await apiservices.fetchLieuLivraison();
      if (fetchedData != null) {
        fetchedData.sort((a, b) => b['id'].compareTo(a['id']));
        addresses.assignAll(fetchedData);
        
        // Sélection auto de l'adresse par défaut
        var defaultAddr = addresses.firstWhere(
          (element) => element['is_default'] == true || element['is_default'] == 1,
          orElse: () => addresses.isNotEmpty ? addresses[0] : null,
        );
        if (defaultAddr != null) {
          selectedAddressId.value = defaultAddr['id'].toString();
        }
      }
    } catch (e) {
      debugPrint('Erreur Adresses: $e');
    } finally {
      isAddressLoading.value = false;
    }
  }
}