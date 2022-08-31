import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:test_image_edit/app/data/widgets/stickerview.dart';

import '../controllers/image_edit_controller.dart';

List<String> assetImages = [
  'assets/images/bear.png',
  'assets/images/fox.png',
  'assets/images/reindeer.png'
];

class ImageEditView extends GetView<ImageEditController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ImageEditController(),
        builder: (ImageEditController controller) {
          return Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  Screenshot(
                    controller: controller.screenshotController,
                    child: Container(
                      height: Get.height - (Get.height / 7) - 31,
                      // decoration: BoxDecoration(
                      //   border: Border.all(color: Colors.yellow, width: 15),
                      // ),
                      child: PageView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.listImageEditor.length,
                        controller: controller.pageController,
                        itemBuilder: (BuildContext context, int itemIndex) {
                          return StickerView(
                            stickers:
                                controller.listImageEditor[itemIndex].stickers,
                            imageUrl:
                                controller.listImageEditor[itemIndex].imageUrl,
                          );
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Offstage(
                          offstage: !controller.isShowListImage,
                          child: _listImage(context, controller),
                        ),
                        _toolBar(context, controller)
                      ],
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 10,
                    child: Offstage(
                      offstage: !controller.isDrawing,
                      child: _buildStrokeToolbar(),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 15,
                    child: Offstage(
                      offstage: !controller.isDrawing,
                      child: _buildColorToolbar(),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      height: Get.height - (Get.height / 7),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  size: 42,
                                ),
                                onPressed: () =>
                                    controller.handlePreviousPage(),
                              )
                            ],
                          ),
                          SizedBox(
                            width: Get.width / 1.5,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 42,
                                ),
                                onPressed: () => controller.handleNextPage(),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: EdgeInsets.only(top: 20),
                      child: IconButton(
                          icon: Icon(
                            Icons.file_download,
                            size: 32,
                            color: Colors.blue[800],
                          ),
                          onPressed: () => controller.saveToGallery(context)),
                    ),
                  ),
                ],
              ),
            ),
            // floatingActionButton: _addnewTextFab(context, controller),
          );
        });
  }

  Widget _toolBar(BuildContext context, ImageEditController controller) {
    return Container(
      color: Color(0xFF11B1BC),
      height: Get.height / 7.0,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Material(
                  child: InkWell(
                    child: Container(
                      width: 56.0,
                      height: 56.0,
                      padding: EdgeInsets.all(15.0),
                      child: SizedBox(
                        child: Icon(Icons.camera_alt),
                      ),
                    ),
                    onTap: () async {
                      final _picker = ImagePicker();
                      final _file =
                          await _picker.getImage(source: ImageSource.camera);
                      print(_file.path);
                      if (_file != null)
                        controller.addImageFromCamera(_file.path);
                    },
                  ),
                ),
              )
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Material(
                  child: InkWell(
                    child: Container(
                      width: 56.0,
                      height: 56.0,
                      padding: EdgeInsets.all(15.0),
                      child: SizedBox(
                        child: Icon(Icons.image),
                      ),
                    ),
                    onTap: () => controller.showImagePicker(),
                  ),
                ),
              )
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Material(
                  child: InkWell(
                    child: Container(
                      width: 56.0,
                      height: 56.0,
                      padding: EdgeInsets.all(15.0),
                      child: SizedBox(
                        child: Icon(Icons.brush),
                      ),
                    ),
                    onTap: () => controller.handleDrawImage(
                        heightDraw: Get.height - (Get.height / 7),
                        widthDraw: Get.width),
                  ),
                ),
              )
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Material(
                  child: InkWell(
                    child: Container(
                      width: 56.0,
                      height: 56.0,
                      padding: EdgeInsets.all(15.0),
                      child: SizedBox(
                        child: Icon(Icons.edit),
                      ),
                    ),
                    onTap: () => controller.addNewDialog(context),
                  ),
                ),
              )
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Material(
                  child: InkWell(
                    child: Container(
                      width: 56.0,
                      height: 56.0,
                      padding: EdgeInsets.all(15.0),
                      child: SizedBox(child: Icon(Icons.emoji_emotions)),
                    ),
                    onTap: () => {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (builder) {
                          return Container(
                            height: Get.height / 3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              color: Colors.blueGrey[100],
                            ),
                            child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: assetImages.length,
                              padding: EdgeInsets.all(16),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemBuilder: (context, index) => ClipOval(
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(48),
                                  child: InkWell(
                                    onTap: () {
                                      controller.handleSelectedStamp(
                                          assetImages[index]);
                                      Get.back();
                                    },
                                    child: Image.asset(
                                      assetImages[index],
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    },
                  ),
                ),
              )
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Material(
                  child: InkWell(
                    child: Container(
                      width: 56.0,
                      height: 56.0,
                      padding: EdgeInsets.all(15.0),
                      child: SizedBox(
                        child: Icon(Icons.filter_frames_sharp),
                      ),
                    ),
                    onTap: () => null,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

Widget _listImage(BuildContext context, ImageEditController controller) {
  return SizedBox(
    height: Get.height / 7,
    child: ListView.builder(
      itemCount: controller.listImageFromOrder.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int indexItem) {
        if (controller.listImageEditor.length > 0) {
          return InkWell(
            child: Container(
              width: 160.0,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: controller.listImageEditor[controller.currentPage]
                                  ?.imageUrl ==
                              controller.listImageFromOrder[indexItem]
                          ? Colors.greenAccent
                          : Colors.transparent,
                      width: 5)),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: controller.listImageFromOrder[indexItem]
                        .contains('https://')
                    ? Image.network(
                        controller.listImageFromOrder[indexItem],
                        fit: BoxFit.fitWidth,
                        frameBuilder: (BuildContext context, Widget child,
                            int frame, bool wasSynchronouslyLoaded) {
                          if (wasSynchronouslyLoaded) {
                            return child;
                          }
                          return AnimatedOpacity(
                            child: child,
                            opacity: controller.loadingImageNetwork ? 0 : 1,
                            duration: const Duration(seconds: 3),
                            curve: Curves.easeOut,
                          );
                        },
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) {
                            // The child (AnimatedOpacity) is build with loading == true, and then the setState will change loading to false, which trigger the animation
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              controller.handleLoadingImageNetwork(false);
                            });

                            return child;
                          }
                          controller.handleLoadingImageNetwork(true);
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                          );
                        },
                      )
                    : Image.file(
                        File(controller.listImageFromOrder[indexItem]),
                        fit: BoxFit.fitWidth,
                      ),
              ),
            ),
            onTap: () => controller
                .setImageUrl(controller.listImageFromOrder[indexItem]),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    ),
  );
}

Widget _buildColorToolbar() {
  ImageEditController imageEditController = Get.find<ImageEditController>();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      ClipOval(
        child: Material(
          child: InkWell(
            child: Container(
              width: 30.0,
              height: 30.0,
              padding: EdgeInsets.all(15.0),
              color: Colors.red,
            ),
            onTap: () => imageEditController.onChangeSelectedColor(Colors.red),
          ),
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      ClipOval(
        child: Material(
          child: InkWell(
            child: Container(
              width: 30.0,
              height: 30.0,
              padding: EdgeInsets.all(15.0),
              color: Colors.blueAccent,
            ),
            onTap: () =>
                imageEditController.onChangeSelectedColor(Colors.blueAccent),
          ),
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      ClipOval(
        child: Material(
          child: InkWell(
            child: Container(
              width: 30.0,
              height: 30.0,
              padding: EdgeInsets.all(15.0),
              color: Colors.yellow,
            ),
            onTap: () =>
                imageEditController.onChangeSelectedColor(Colors.yellow),
          ),
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      IconButton(
        icon: Icon(
          Icons.undo,
          color: Colors.blueAccent,
          size: 32,
        ),
        onPressed: () => imageEditController.undoDraw(),
      ),
      SizedBox(
        height: 10.0,
      ),
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.redAccent,
          size: 32,
        ),
        onPressed: () => imageEditController.clearDraw(),
      ),
      SizedBox(
        height: 10.0,
      ),
      IconButton(
        icon: Icon(
          Icons.save,
          color: Colors.greenAccent,
          size: 32,
        ),
        onPressed: () => imageEditController.saveDraw(),
      )
    ],
  );
}

Widget _buildStrokeToolbar() {
  ImageEditController imageEditController = Get.find<ImageEditController>();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      ClipOval(
        child: Material(
          child: InkWell(
            child: Container(
              width: 30.0,
              height: 30.0,
              padding: EdgeInsets.all(15.0),
              color: imageEditController.selectedColorDraw,
            ),
            onTap: () => imageEditController.setStrokeWidth(3.0),
          ),
        ),
      ),
      SizedBox(
        height: 10,
      ),
      ClipOval(
        child: Material(
          child: InkWell(
            child: Container(
              width: 40.0,
              height: 40.0,
              padding: EdgeInsets.all(15.0),
              color: imageEditController.selectedColorDraw,
            ),
            onTap: () => imageEditController.setStrokeWidth(5.0),
          ),
        ),
      ),
      SizedBox(
        height: 10,
      ),
      ClipOval(
        child: Material(
          child: InkWell(
            child: Container(
              width: 50.0,
              height: 50.0,
              padding: EdgeInsets.all(15.0),
              color: imageEditController.selectedColorDraw,
            ),
            onTap: () => imageEditController.setStrokeWidth(10.0),
          ),
        ),
      ),
      SizedBox(
        height: 10,
      ),
    ],
  );
}
