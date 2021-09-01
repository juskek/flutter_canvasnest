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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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

  // bool _cursorHovering = false;

  final Random rng = Random();
  final CanvasNestConfig nestConfig = CanvasNestConfig(
      100, 1, Colors.grey.withAlpha(200), Colors.grey.withAlpha(200), 120);

  List<NodeInfo> generateNodeInfo(BuildContext context) {
    screenSize = ScreenSize(MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height - kToolbarHeight);
    print("Screen width:");
    print(screenSize.width);
    print("Screen height (minus appbar):");
    print(screenSize.height);

    return List<NodeInfo>.generate(
        nestConfig.nodeCount,
        (index) => NodeInfo(
            rng.nextDouble() * screenSize.width,
            rng.nextDouble() * screenSize.height,
            rng.nextDouble() * 2 - 1,
            rng.nextDouble() * 2 - 1));
  }

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
    // generate node info
    List<NodeInfo> nodeInfoList = generateNodeInfo(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        // color: Colors.grey,
        child: Stack(children: [
          CanvasNestTransition(
              _controller, nestConfig, nodeInfoList, screenSize),
        ]),
      ),
    );
  }
}
