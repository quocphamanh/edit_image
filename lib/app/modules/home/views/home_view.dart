import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_image_edit/app/data/widgets/draw_demo/sticker_view_demo.dart';
import 'package:test_image_edit/app/modules/image_edit/views/image_edit_view.dart';
import 'package:test_image_edit/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        // Sticker Editor View
        child: StickerView(
          // List of Stickers
          stickerList: [
            Sticker(
              child: Image.network(
                  "https://images.unsplash.com/photo-1640113292801-785c4c678e1e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=736&q=80"),
              // must have unique id for every Sticker
              id: "uniqueId_111",
            ),
            Sticker(
              child: const Text("Hello"),
              id: "uniqueId_222",
              isText: true,
            ),
          ],
        ),
      ),
    );
  }
}
