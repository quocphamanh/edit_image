import 'package:get/get.dart';
import 'package:test_image_edit/app/modules/image_edit/bindings/image_edit_binding.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    ImageEditBinding().dependencies();
  }
}
