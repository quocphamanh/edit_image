import 'package:get/get.dart';

import 'package:test_image_edit/app/modules/home/bindings/home_binding.dart';
import 'package:test_image_edit/app/modules/home/views/home_view.dart';
import 'package:test_image_edit/app/modules/image_edit/bindings/image_edit_binding.dart';
import 'package:test_image_edit/app/modules/image_edit/views/image_edit_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.IMAGE_EDIT;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.IMAGE_EDIT,
      page: () => ImageEditView(),
      binding: ImageEditBinding(),
    ),
  ];
}
