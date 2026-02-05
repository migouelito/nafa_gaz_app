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
    fetchOrders();
  }

Future<void> fetchOrders() async {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {
      LoadingModal.show();
      futureCommandes.value =  _apiService.fetchCommandes();
    } finally {
      LoadingModal.hide();
    }
  });
}

  Future<void> handleRefresh() async {
    fetchOrders();
  }
}