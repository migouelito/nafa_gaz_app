import 'package:get/get.dart';
import 'buy_controller.dart';

class  BuyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyController>(() => BuyController());
  }
}