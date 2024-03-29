import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.checkConnectivity().then((result) {
      _updateConnectionStatus(result);
    });
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      Get.rawSnackbar(
        messageText: const Text('SIN INTERNET...',
            style: TextStyle(
              color: Colors.white,
            )),
        isDismissible: false,
        duration: const Duration(days: 1),
        backgroundColor: Colors.red[400]!,
        icon: const Icon(
          Icons.wifi_off,
          color: Colors.white,
          size: 35,
        ),
        margin: EdgeInsets.zero,
        snackStyle: SnackStyle.GROUNDED,

        snackPosition: SnackPosition.TOP, // o SnackPosition.CENTER
      );
      print('Mostrando snackbar');
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
        print('Snackbar cerrado');
      }
    }
  }
}
