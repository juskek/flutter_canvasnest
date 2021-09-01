import 'package:flutter/gestures.dart';
import 'dart:html';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CursorInfo {
  double x, y;
  bool hovering;
  CursorInfo(this.x, this.y, this.hovering);
}

class CanvasNestConfig {
  Color nodeColor, lineColor;
  int nodeCount, maxLineDist;
  double nodeSize;

  CanvasNestConfig(this.nodeCount, this.nodeSize, this.nodeColor,
      this.lineColor, this.maxLineDist);
}

class NodeInfo {
  // this remains constant throughout animation
  double x, y, xVector, yVector;

  NodeInfo(
    this.x,
    this.y,
    this.xVector,
    this.yVector,
  );
}

class ScreenSize {
  double width, height;
  ScreenSize(this.width, this.height);
}

class CanvasNestTransition extends AnimatedWidget {
  // bool _cursorHovering = false;
  final AnimationController _controller;
  final CanvasNestConfig nestConfig;
  List<NodeInfo> nodeInfoList;
  ScreenSize screenSize;
  PointerEvent? _details;
  CursorInfo _cursor = CursorInfo(0, 0, false);
  PointerExitEvent _pointerExitEvent = PointerExitEvent();
  void _pointerLocation(PointerEvent details) {
    _cursor.x = details.position.dx;
    _cursor.y = details.position.dy - kToolbarHeight;
    _details = details;
  }

  CanvasNestTransition(
      controller, this.nestConfig, this.nodeInfoList, this.screenSize)
      : _controller = controller,
        super(listenable: controller);

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerHover: _pointerLocation,
      child: Stack(children: [
        // Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Text(
        //         'The cursor is at (${_cursor.x.toStringAsFixed(2)}, ${_cursor.y.toStringAsFixed(2)})',
        //       ),
        //       // Text(
        //       // 'PointerEvent: ${_details?.original}',
        //       // 'MouseRegion: ${_cursorHovering}',
        //       // ),
        //     ],
        //   ),
        // ),
        Container(
          constraints: BoxConstraints.expand(),
          child: CustomPaint(
            painter: CanvasNestPainter(
                nestConfig, nodeInfoList, screenSize, _cursor),
          ),
        ),
        Center(
          child: Container(
            height: screenSize.height * 0.9,
            width: screenSize.width * 0.9,
            // color: Colors.grey,
            child: MouseRegion(
              onEnter: (PointerEnterEvent details) {
                _cursor.hovering = true;
              },
              onExit: (PointerExitEvent details) {
                _cursor.hovering = false;
              },
            ),
          ),
        ),
      ]),
    );
  }
}

class CanvasNestPainter extends CustomPainter {
  final CanvasNestConfig nestConfig;
  List<NodeInfo> nodeInfoList;

  final ScreenSize screenSize;
  CursorInfo cursor;
  CanvasNestPainter(
      this.nestConfig, this.nodeInfoList, this.screenSize, this.cursor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint nodeStyle = Paint()..color = nestConfig.nodeColor;
    print('Hovering: ${cursor.hovering}');
    print('Original count: ${nestConfig.nodeCount}');
    print('List length: ${nodeInfoList.length}');

    if (cursor.hovering && (nodeInfoList.length == nestConfig.nodeCount)) {
      // cursor just entered
      // add cursor to nodeInfoList
      nodeInfoList.add(NodeInfo(cursor.x, cursor.y, 0, 0));
    } else if (cursor.hovering &&
        (nodeInfoList.length != nestConfig.nodeCount)) {
      // cursor already entered
      // replace node
      nodeInfoList.removeLast();
      nodeInfoList.add(NodeInfo(cursor.x, cursor.y, 0, 0));
    } else if (!cursor.hovering &&
        (nodeInfoList.length != nestConfig.nodeCount)) {
      nodeInfoList.removeLast();
    } else {
      // throw ('unhandled cursor.hovering exception');
    }

    // for every node,
    for (var node in nodeInfoList) {
      // move node
      node.x += node.xVector;
      node.y += node.yVector;

      // change direction of node if it hits the wall
      node.xVector *= (node.x > screenSize.width) || (node.x < 0) ? -1 : 1;
      node.yVector *= (node.y > screenSize.height) || (node.y < 0) ? -1 : 1;
      canvas.drawCircle(Offset(node.x, node.y), nestConfig.nodeSize, nodeStyle);

      // TODO: paint line between each node if distance is less than specified amount
      // compare this node to every other node to draw line
      for (var otherNode in nodeInfoList) {
        if (identical(node, otherNode)) {
          // print('Same node instance, skipping');
          continue;
        }
        // print('Different node instance');
        double xDist = node.x - otherNode.x;
        double yDist = node.y - otherNode.y;
        double dist = sqrt(xDist * xDist + yDist * yDist); // pythagoras
        if (dist < nestConfig.maxLineDist) {
          nestConfig.lineColor = Colors.grey
              .withAlpha(200 - (200 * dist ~/ nestConfig.maxLineDist));
          Paint lineStyle = Paint()..color = nestConfig.lineColor;
          canvas.drawLine(Offset(node.x, node.y),
              Offset(otherNode.x, otherNode.y), lineStyle);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
