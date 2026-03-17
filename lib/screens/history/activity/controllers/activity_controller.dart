import 'package:get/get.dart';
import '../../../../servicesApp/apiServices.dart';
import '../../../../loading/loading.dart';
import 'package:flutter/widgets.dart';

class ActivityController extends GetxController {
  final ApiService _apiService = ApiService();

  var futureCommandes = Future<List<dynamic>?>.value([]).obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchOrders();
    });
  }

  Future<void> fetchOrders() async {
    try {
      await Future.delayed(Duration.zero);
      LoadingModal.show(); 

      final commandes = await _apiService.fetchCommandes();
      futureCommandes.value = Future.value(commandes);
    } finally {
      LoadingModal.hide();
    }
  }

  Future<void> handleRefresh() async {
    await fetchOrders();
  }
}