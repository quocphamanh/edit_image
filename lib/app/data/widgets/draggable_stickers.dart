// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:test_image_edit/app/modules/image_edit/controllers/image_edit_controller.dart';
// import 'draggable_resizable.dart';
// import 'stickerview.dart';

// class DraggableStickers extends StatefulWidget {
//   //List of stickers (elements)
//   final List<Sticker> stickerList;
//   final int itemIndex;

//   // ignore: use_key_in_widget_constructors
//   const DraggableStickers({this.stickerList, this.itemIndex});
//   @override
//   State<DraggableStickers> createState() => _DraggableStickersState();
// }

// String selectedAssetId;

// class _DraggableStickersState extends State<DraggableStickers> {
//   final imageEditController = Get.find<ImageEditController>();
//   // initial scale of sticker
//   final _initialStickerScale = 10.0;

//   @override
//   Widget build(BuildContext context) {
//     return widget.stickerList.isNotEmpty && widget.stickerList != []
//         ? Stack(
//             fit: StackFit.expand,
//             children: [
//               Positioned.fill(
//                 child: GestureDetector(
//                   key: const Key('stickersView_background_gestureDetector'),
//                   onTap: () {},
//                 ),
//               ),
//               for (final sticker in widget.stickerList)

//                 // Main widget that handles all features like rotate, resize, edit, delete, layer update etc.
//                 DraggableResizable(
//                   key:
//                       Key('stickerPage_${sticker.id}_draggableResizable_asset'),
//                   canTransform: selectedAssetId == sticker.id ? true : false

//                   //  true
//                   /*sticker.id == state.selectedAssetId*/,
//                   onUpdate: (update) => {},

//                   // To update the layer (manage position of widget in stack)
//                   onLayerTapped: () {
//                     var listLength = widget.stickerList.length;
//                     var ind = widget.stickerList.indexOf(sticker);
//                     widget.stickerList.remove(sticker);
//                     if (ind == listLength - 1) {
//                       widget.stickerList.insert(0, sticker);
//                     } else {
//                       widget.stickerList.insert(listLength - 1, sticker);
//                     }

//                     selectedAssetId = sticker.id;
//                     setState(() {});
//                   },

//                   // To edit (Not implemented yet)
//                   onEdit: () {},

//                   // To Delete the sticker
//                   onDelete: () async {
//                     {
//                       widget.stickerList.remove(sticker);
//                       setState(() {});
//                     }
//                   },

//                   // Size of the sticker
//                   size: sticker.isText == true
//                       ? Size(64 * _initialStickerScale / 3,
//                           64 * _initialStickerScale / 3)
//                       : Size(
//                           64 * _initialStickerScale, 64 * _initialStickerScale),

//                   // Constraints of the sticker
//                   constraints: sticker.isText == true
//                       ? BoxConstraints.tight(
//                           Size(
//                             64 * _initialStickerScale / 3,
//                             64 * _initialStickerScale / 3,
//                           ),
//                         )
//                       : BoxConstraints.tight(
//                           Size(
//                             64 * _initialStickerScale,
//                             64 * _initialStickerScale,
//                           ),
//                         ),

//                   // Child widget in which sticker is passed
//                   child: InkWell(
//                     splashColor: Colors.transparent,
//                     onTap: () {
//                       // To update the selected widget
//                       selectedAssetId = sticker.id;
//                       setState(() {});
//                     },
//                     child: SizedBox(
//                       width: double.infinity,
//                       height: double.infinity,
//                       child: sticker.isText == true
//                           ? FittedBox(
//                               child: Flexible(
//                                 child: Text(
//                                   sticker.text,
//                                   style: TextStyle(
//                                     fontSize: sticker.textInfo.fontSize,
//                                     fontWeight: sticker.textInfo.fontWeight,
//                                     fontStyle: sticker.textInfo.fontStyle,
//                                     color: sticker.textInfo.color,
//                                   ),
//                                 ),
//                               ),
//                             )
//                           : sticker.isImage == true
//                               ? Image.file(
//                                   File(sticker.path),
//                                   width: Get.width,
//                                   height: Get.height,
//                                 )
//                               : sticker.child,
//                     ),
//                   ),
//                 ),
//             ],
//           )
//         : Container();
//   }
// }
