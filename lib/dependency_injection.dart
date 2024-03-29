import 'package:get/get.dart';

import 'package:todoapp/services/connectivity_service.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }
}
