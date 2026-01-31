import 'package:get/get.dart';
import 'update_activity_controller.dart';

class UpdateActivityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateActivityController>(() => UpdateActivityController());
  }
}