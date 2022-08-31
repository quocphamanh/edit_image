import 'dart:io';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:test_image_edit/app/data/models/drawing_points.dart';

import '../../modules/image_edit/controllers/image_edit_controller.dart';

class PaintLayer extends StatefulWidget {
  @override
  _PaintLayerState createState() => _PaintLayerState();
}

class _PaintLayerState extends State<PaintLayer> {
  bool showBottomList = false;
  double opacity = 1.0;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;
  // SelectedMode selectedMode = SelectedMode.StrokeWidth;
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    Colors.black
  ];
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ImageEditController(),
      builder: (controller) => GestureDetector(
        onPanStart: (details) {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          controller.addPointDraw(DrawingPoints(
              points: renderBox.globalToLocal(details.globalPosition),
              paint: Paint()
                ..strokeCap = strokeCap
                ..isAntiAlias = true
                ..color = controller.selectedColorDraw.withOpacity(opacity)
                ..strokeWidth = controller.strokeWidth));
        },
        onPanUpdate: (details) {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          controller.addPointDraw(DrawingPoints(
              points: renderBox.globalToLocal(details.globalPosition),
              paint: Paint()
                ..strokeCap = strokeCap
                ..isAntiAlias = true
                ..color = controller.selectedColorDraw.withOpacity(opacity)
                ..strokeWidth = controller.strokeWidth));
        },
        onPanEnd: (details) {
          controller.addPointDraw(null);
        },
        child: CustomPaint(
          size: Size.infinite,
          painter: DrawingPainter(
            pointsList: controller.points,
          ),
        ),
      ),
    );
  }
}

// FOR PAINTING LINES
class DrawingPainter extends CustomPainter {
  DrawingPainter({this.pointsList = const []});
  List<DrawingPoints> pointsList;
  List<Offset> offsetPoints = [];
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points,
            pointsList[i].paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].points);
        offsetPoints.add(Offset(
            pointsList[i].points.dx + 0.1, pointsList[i].points.dy + 0.1));
        canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
