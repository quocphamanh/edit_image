import 'package:get/get.dart';

import 'dart:async';
import 'dart:typed_data';
import 'package:dio/dio.dart' as Dio;

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:signature/signature.dart';
import 'package:test_image_edit/app/data/models/drag_update.dart';
import 'package:test_image_edit/app/data/models/drawing_points.dart';
import 'package:test_image_edit/app/data/models/image_editor.dart';
import 'package:test_image_edit/app/data/models/text_info.dart';
import 'package:test_image_edit/app/data/widgets/default_button.dart';
import 'package:test_image_edit/app/data/widgets/paint_layer.dart';
import 'package:test_image_edit/app/data/widgets/stickerview.dart';

class ImageEditController extends GetxController {
  final _initialStickerScale = 10.0;

  // widget use get text from form
  TextEditingController textEditingController = TextEditingController();
  // widget use capture image current screen
  ScreenshotController screenshotController = ScreenshotController();
  // widget handle page view
  PageController pageController =
      new PageController(viewportFraction: 1, keepPage: true, initialPage: 0);
  // index sticker in current page
  int currentIndex = 0;
  // index page edit in list pageview
  int currentPage = 0;
  // flag check show list image picker
  bool isShowListImage = false;
  // selected asset id
  String selectedAssetId = "";
  // show icon loading when loading image network
  bool loadingImageNetwork = false;

  // drawing
  bool isDrawing = false;
  double strokeWidth = 3.0;
  List<DrawingPoints> points = [];
  Color selectedColorDraw = Colors.red;
  // drawing

  // list sticker
  List<Sticker> listSticker = [];
  // list image editor
  List<ImageEditor> listImageEditor = [];
  // list image select from order
  List<String> listImageFromOrder = [
    'https://thumbs.dreamstime.com/b/funny-face-baby-27701492.jpg',
    'https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg?auto=compress&cs=tinysrgb&w=1600',
    'https://media.istockphoto.com/photos/great-pyramids-of-giza-picture-id901630488?k=20&m=901630488&s=612x612&w=0&h=9lLAJ6aENeyp1eEw5iIzPIM1ZlAz9K0K6XvYTDZn5-I=',
    'https://media.istockphoto.com/photos/the-main-attraction-of-paris-and-all-of-europe-is-the-eiffel-tower-in-picture-id1185953092?k=20&m=1185953092&s=612x612&w=0&h=KHs_E9GYlaacGx9lzvYwID7mopBmw7nN4jyr7b-Acqo=',
  ];

  @override
  void onInit() {
    pageController = new PageController()..addListener(_listener);
    getOrderItems();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    textEditingController.clear();
    listSticker = [];
    currentIndex = 0;
    loadingImageNetwork = false;
  }

  _listener() {
    print('@@@ page listen controller ${pageController.page}');
  }

  getOrderItems() async {
    await Future.delayed(Duration(seconds: 2), () {
      listImageEditor = [
        ImageEditor(
          id: "1111",
          imageUrl: "",
          stickers: [],
        ),
        ImageEditor(
          id: "2222",
          imageUrl: "",
          stickers: [],
        ),
      ];
    });
    update();
  }

  saveToGallery(BuildContext context) {
    if (listSticker.isNotEmpty) {
      screenshotController.capture().then((Uint8List image) {
        saveImage(image);
        Get.snackbar('Image saved to gallery.', '',
            snackPosition: SnackPosition.BOTTOM);
      }).catchError((err) => print(err));
    }
  }

  saveImage(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = "screenshot_$time";

    Dio.FormData formData = Dio.FormData.fromMap({
      "file": Dio.MultipartFile.fromBytes(bytes, filename: name),
    });

    // TODO: call api upload image
  }

  removeText(BuildContext context, int index) {
    currentIndex = index;
    listSticker.removeAt(index);
    update();

    Get.snackbar('Deleted', '', snackPosition: SnackPosition.BOTTOM);
  }

  setCurrentIndex(BuildContext context, int index) {
    currentIndex = index;
    update();

    Get.snackbar('Selected For Styling', '',
        snackPosition: SnackPosition.BOTTOM);
  }

  changeTextColor(Color color) {
    listSticker[currentIndex].textInfo.color = color;
    update();
  }

  addNewText() {
    selectedAssetId =
        'uniqueId_${textEditingController.text}_${listSticker.length + 1}';
    listImageEditor[currentPage].stickers.add(Sticker(
          textInfo: TextInfo(
            text: textEditingController.text,
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 32,
          ),
          id: "uniqueId_${textEditingController.text}_${listSticker.length + 1}",
          isText: true,
          isImage: false,
          isDraw: false,
          dragUpdate: DragUpdate(
            height: 64 * _initialStickerScale / 3,
            width: 64 * _initialStickerScale / 3,
            rotation: 0.0,
            scale: 1.0,
            xPosition: 0.1,
            yPosition: 0.1,
          ),
        ));

    textEditingController.clear();
    update();
    Get.back();
  }

  addNewDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Add New Text',
        ),
        content: TextField(
          controller: textEditingController,
          maxLines: 5,
          decoration: const InputDecoration(
            suffixIcon: Icon(
              Icons.edit,
            ),
            filled: true,
            hintText: 'Your Text Here..',
          ),
        ),
        actions: <Widget>[
          DefaultButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Back',
              style: TextStyle(color: Colors.black),
            ),
            color: Colors.white,
            textColor: Colors.black,
          ),
          DefaultButton(
            onPressed: () => addNewText(),
            child: const Text('Add Text'),
            color: Colors.red,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  setImageUrl(String imageUrl) {
    showImagePicker();
    listImageEditor[currentPage].imageUrl = imageUrl;
    update();
  }

  showImagePicker() {
    isShowListImage = !isShowListImage;
    update();
  }

  handlePreviousPage() {
    pageController.previousPage(
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
    if (currentPage == 0) return;
    currentPage--;
    update();
  }

  handleNextPage() {
    pageController.nextPage(
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
    if (listImageEditor.length - 1 == currentPage) return;
    currentPage++;
    update();
  }

  removeSticker(int indexSticker) {
    listImageEditor[currentPage].stickers.removeAt(indexSticker);
    update();
  }

  handleSelectedStamp(String assetImage) {
    selectedAssetId = "uniqueId_${assetImage}_${listSticker.length + 1}";
    listImageEditor[currentPage].stickers.add(
          Sticker(
            isText: false,
            isImage: true,
            isDraw: false,
            pathImage: assetImage,
            id: "uniqueId_${assetImage}_${listSticker.length + 1}",
            dragUpdate: DragUpdate(
              height: 64 * _initialStickerScale,
              width: 64 * _initialStickerScale,
              rotation: 0.0,
              scale: 1.0,
              xPosition: 0.1,
              yPosition: 0.1,
            ),
          ),
        );
    update();
    Get.back();
  }

  handleDrawImage({double heightDraw, double widthDraw}) {
    selectedAssetId = "";
    isDrawing = true;
    update();
  }

  addPointDraw(DrawingPoints point) {
    if (!isDrawing) return;
    points.add(point);
    update();
  }

  setStrokeWidth(double value) {
    strokeWidth = value;
    update();
  }

  onChangeSelectedColor(Color color) {
    selectedColorDraw = color;
    update();
  }

  clearDraw() {
    points.clear();
    update();
  }

  undoDraw() {
    points.removeLast();
    update();
  }

  saveDraw() {
    isDrawing = false;
    update();
  }

  addImageFromCamera(String pathImage) {
    listImageFromOrder = [pathImage, ...listImageFromOrder];
    isShowListImage = true;
    update();
  }

  handleLoadingImageNetwork(bool loading) {
    loadingImageNetwork = loading;
    update();
  }

  handleSelectedAssetId(String id) {
    selectedAssetId = id;
    update();
  }

  handleStickerDragUpdate(
      {double newXPosition,
      double newYPosition,
      double newRotation,
      double newHeight,
      double newWidth,
      double newScale,
      int i,
      ScaleUpdateDetails details}) {
    listImageEditor[currentPage].stickers[i].dragUpdate.xPosition =
        newXPosition;
    listImageEditor[currentPage].stickers[i].dragUpdate.yPosition =
        newYPosition;
    listImageEditor[currentPage].stickers[i].dragUpdate.scale = newScale;
    listImageEditor[currentPage].stickers[i].dragUpdate.rotation = newRotation;
    update();
  }
}
