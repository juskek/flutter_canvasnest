import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'canvas_nest.dart';
import 'dart:math';

void main() {
  runApp(CanvasNestApp());
}

class CanvasNestApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Canvas Nest',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Canvas Nest'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  ScreenSize screenSize = ScreenSize(0, 0); // init screen size
  final CanvasNestConfig nestConfig = CanvasNestConfig(100, 1,
      Colors.grey.withAlpha(200), Colors.grey.withAlpha(200), 120, 0.02);

  late final AnimationController _controller = AnimationController(
    duration: Duration(seconds: 30), // ANITIME
    vsync: this,
  )..repeat();
  // repeat animation progress so that transition keeps building (see listenable)

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = ScreenSize(MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height - kToolbarHeight);
    // generate node info
    List<NodeInfo> nodeInfoList =
        generateNodeInfo(context, nestConfig, screenSize);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: CanvasNestTransition(
          _controller, nestConfig, nodeInfoList, screenSize),
    );
  }
}
