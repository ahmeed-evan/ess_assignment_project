import 'package:ess_assignment_project/controller/custom_order_controller.dart';
import 'package:ess_assignment_project/controller/feedback_controller.dart';
import 'package:get/get.dart';

Future<void> initApp() async {
  Get.put(FeedBackController());
  Get.put(CustomOrderController());
}
