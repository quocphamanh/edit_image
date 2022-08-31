import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:test_image_edit/app/data/models/drag_update.dart';

import 'package:test_image_edit/app/data/models/text_info.dart';
import 'package:test_image_edit/app/data/widgets/paint_layer.dart';
import 'package:test_image_edit/app/modules/image_edit/controllers/image_edit_controller.dart';

class StickerView extends StatefulWidget {
  final List<Sticker> stickers;
  final String imageUrl;

  const StickerView({Key key, this.stickers, this.imageUrl}) : super(key: key);

  @override
  _StickerViewState createState() => _StickerViewState();
}

class _StickerViewState extends State<StickerView> {
  ImageEditController imageEditController = Get.find<ImageEditController>();

  Offset _initPos;
  Offset _currentPos = Offset(0, 0);
  double _currentScale;
  double _currentRotation;
  Size screen;
  bool loading = false;

  @override
  void initState() {
    screen = Size(500, 500);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.imageUrl != ""
            ? Container(
                alignment: Alignment.center,
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: widget.imageUrl.contains('https://')
                      ? Image.network(
                          widget.imageUrl,
                          fit: BoxFit.fill,
                          frameBuilder: (BuildContext context, Widget child,
                              int frame, bool wasSynchronouslyLoaded) {
                            if (wasSynchronouslyLoaded) {
                              return child;
                            }
                            return AnimatedOpacity(
                              child: child,
                              opacity: loading ? 0 : 1,
                              duration: const Duration(seconds: 3),
                              curve: Curves.easeOut,
                            );
                          },
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) {
                              // The child (AnimatedOpacity) is build with loading == true, and then the setState will change loading to false, which trigger the animation
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() => loading = false);
                              });

                              return child;
                            }
                            loading = true;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          },
                        )
                      : Image.file(
                          File(widget.imageUrl),
                          fit: BoxFit.fill,
                          frameBuilder: (BuildContext context, Widget child,
                              int frame, bool wasSynchronouslyLoaded) {
                            if (wasSynchronouslyLoaded) {
                              return child;
                            }
                            return AnimatedOpacity(
                              opacity: frame == null ? 0 : 1,
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeOut,
                              child: child,
                            );
                          },
                        ),
                ),
              )
            : Container(
                alignment: Alignment.center,
                child: Text(
                  'please select image'.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
        PaintLayer(),
        for (var i = 0; i < widget.stickers.length; i++)
          Positioned(
            left: widget.stickers[i].dragUpdate.xPosition * screen.width,
            top: widget.stickers[i].dragUpdate.yPosition * screen.height,
            child: Transform.scale(
              scale: widget.stickers[i].dragUpdate.scale,
              child: Transform.rotate(
                angle: widget.stickers[i].dragUpdate.rotation,
                child: GestureDetector(
                  onScaleStart: (details) {
                    if (widget.stickers[i] == null ||
                        imageEditController.selectedAssetId !=
                            widget.stickers[i].id) return;
                    if (widget.stickers[i].isDraw) return;
                    _initPos = details.focalPoint;
                    _currentPos = Offset(
                        widget.stickers[i].dragUpdate.xPosition,
                        widget.stickers[i].dragUpdate.yPosition);
                    _currentScale = widget.stickers[i].dragUpdate.scale;
                    _currentRotation = widget.stickers[i].dragUpdate.rotation;
                  },
                  onScaleUpdate: (details) {
                    if (widget.stickers[i] == null ||
                        widget.stickers[i] == null ||
                        imageEditController.selectedAssetId !=
                            widget.stickers[i].id) return;
                    if (widget.stickers[i].isDraw) return;
                    final delta = details.focalPoint - _initPos;
                    final left = (delta.dx / screen.width) + _currentPos.dx;
                    final top = (delta.dy / screen.height) + _currentPos.dy;

                    imageEditController.handleStickerDragUpdate(
                      details: details,
                      i: i,
                      newRotation: details.rotation + _currentRotation,
                      newScale: details.scale * _currentScale,
                      newXPosition: Offset(left, top).dx,
                      newYPosition: Offset(left, top).dy,
                    );
                  },
                  onTap: () {
                    if (widget.stickers[i].isDraw) return;
                    if (imageEditController.selectedAssetId ==
                        widget.stickers[i].id) {
                      imageEditController.handleSelectedAssetId("");
                    } else {
                      imageEditController
                          .handleSelectedAssetId(widget.stickers[i].id);
                    }
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 2,
                                color: imageEditController.selectedAssetId ==
                                        widget.stickers[i].id
                                    ? Colors.blue
                                    : Colors.transparent),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: widget.stickers[i].isText == true
                              ? Center(
                                  child: Text(
                                    widget.stickers[i].textInfo.text,
                                    style: TextStyle(
                                      fontSize:
                                          widget.stickers[i].textInfo.fontSize,
                                      fontWeight: widget
                                          .stickers[i].textInfo.fontWeight,
                                      color: widget.stickers[i].textInfo.color,
                                    ),
                                  ),
                                )
                              : widget.stickers[i].isImage == true
                                  ? Center(
                                      child: Image.asset(
                                        widget.stickers[i].pathImage,
                                        fit: BoxFit.contain,
                                      ),
                                    )
                                  : widget.stickers[i].child,
                        ),
                      ),
                      Positioned(
                        top: 3,
                        left: 3,
                        child: InkWell(
                          onTap: () {
                            imageEditController.removeSticker(
                                imageEditController
                                    .listImageEditor[
                                        imageEditController.currentPage]
                                    .stickers
                                    .indexOf(widget.stickers[i]));
                          },
                          child: imageEditController.selectedAssetId ==
                                  widget.stickers[i].id
                              ? Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: const Icon(Icons.cancel_outlined,
                                      color: Colors.black, size: 18),
                                )
                              : Container(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }
}

class Sticker extends StatefulWidget {
  // you can pass any widget to it as child
  Widget child;
  // path image
  String pathImage;
  // set isText to true if passed Text widget as child
  bool isText = false;
  // set isImage to true if passed Image render
  bool isImage = false;
  // every sticker must be assigned with unique id
  String id;
  //text info
  TextInfo textInfo;
  // drag info
  DragUpdate dragUpdate;
  // set isDraw to true if draw show over image
  bool isDraw = false;

  Sticker({
    Key key,
    this.child,
    this.pathImage,
    this.isText,
    this.isImage,
    @required this.id,
    this.textInfo,
    @required this.dragUpdate,
    this.isDraw,
  }) : super(key: key);
  @override
  _StickerState createState() => _StickerState();
}

class _StickerState extends State<Sticker> {
  @override
  Widget build(BuildContext context) {
    return widget.child != null ? widget.child : Container();
  }
}
