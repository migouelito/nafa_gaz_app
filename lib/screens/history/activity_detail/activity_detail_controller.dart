import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../servicesApp/apiServices.dart';
import '../../../loading/loading.dart';
import '../../../alerte/alerte.dart';
import '../../../appColors/appColors.dart';
import 'package:flutter/material.dart';
import '../activity/controllers/activity_controller.dart';

class ActivityDetailController extends GetxController {
  final ApiService apiService = ApiService();
  
  var order = <String, dynamic>{}.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      order.value = Get.arguments;
    }
    fetchCommandeDetail();
  }

  Future<void> fetchCommandeDetail() async {
    if (order['id'] == null) return;
    try {
      isLoading.value = true;
      final response = await apiService.fetchCommandeDetail(order['id']);
      print("=======================detail$response");
      if (response != null) {
        order.value = response;
      }
    } catch (e) {
      print("Erreur chargement détails : $e");
    } finally {
      isLoading.value = false;
    }
  }

  // --- MÉTHODE MISE À JOUR : Plus besoin de paramètre ID ---
  Future<void> cancelCommande() async {
    final String? idCommande = order.value['id'];
    if (idCommande == null) {
      Alerte.show(title: "Erreur", message: "ID de commande introuvable", color: Colors.red);
      return;
    }

    try {
      LoadingModal.show(text: "Annulation...");

      // On utilise l'ID récupéré de l'observable 'order'
      bool success = await apiService.cancelCommande(idCommande);
      
      LoadingModal.hide();

      if (success) {
      if (Get.isRegistered<ActivityController>()) {
          final activityController = Get.find<ActivityController>();
          await activityController.fetchOrders();
        }
        Get.back();
        Alerte.show(
          title: "Succès",
          message: "Commande annulée avec succès",
          imagePath: "assets/images/succes.png",
          color: AppColors.generalColor,
        );
      } else {
        throw Exception("Serveur a refusé l'annulation");
      }
    } catch (e) {
      LoadingModal.hide();
      Alerte.show(
        title: "Erreur",
        message: "Échec de l’annulation de la commande",
        imagePath: "assets/images/error.png",
        color: Colors.red,
      );
      print("Erreur annulation: $e");
    }
  }

  // Getters réactifs
  String get formattedDate {
    if (order['created'] == null) return "Date inconnue";
    DateTime date = DateTime.parse(order['created'].toString());
    return DateFormat('dd MMM yyyy • HH:mm').format(date);
  }

  String get shortId => order['id'] != null 
      ? order['id'].toString().substring(0, 8).toUpperCase() 
      : "ID Inconnu";

  List get items => order['items'] ?? [];

  bool get canModify => order['etat'] == "EN_ATTENTE";
}