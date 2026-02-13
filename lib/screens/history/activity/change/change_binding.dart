import 'package:get/get.dart';
import 'change_controller.dart';

class  ChangeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangeController>(() => ChangeController());
  }
}