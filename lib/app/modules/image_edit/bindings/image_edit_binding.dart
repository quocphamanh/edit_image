import 'package:get/get.dart';

import '../controllers/image_edit_controller.dart';

class ImageEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImageEditController>(
      () => ImageEditController(),
    );
  }
}
