import 'package:get/get.dart';
import 'order_validation_controller.dart';

class OrderValidationBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<OrderValidationController>(() => OrderValidationController());
  }
}