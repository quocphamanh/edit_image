import 'package:flutter/material.dart';
import 'package:test_image_edit/app/data/widgets/stickerview.dart';

class ImageEditor {
  String id;
  String imageUrl;
  List<Sticker> stickers;

  ImageEditor({@required this.id, this.imageUrl, this.stickers});
}
