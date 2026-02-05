import 'package:get/get.dart';
import 'activity_detail_controller.dart';

class ActivityDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivityDetailController>(() => ActivityDetailController());
  }
}