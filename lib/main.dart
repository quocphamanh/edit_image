import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:test_image_edit/app/data/bindings/initial_binding.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: InitialBinding(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
