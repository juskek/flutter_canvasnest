import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'canvas_nest.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

const githubURL = 'https://github.com/juskek/flutter_canvasnest';
const portfolioURL = 'https://justinkek.com/';

void launchURL(_url) async {
  await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
}

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
        primaryColor: Colors.white,
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
        actions: [
          IconButton(
            onPressed: () => launchURL(githubURL),
            icon: SvgPicture.network(
                'https://raw.githubusercontent.com/gilbarbara/logos/f4c8e8b933aa80ce83b6d6d387e016bf4cb4e376/logos/github-icon.svg'),
            splashRadius: kToolbarHeight * 0.4,
          ),
          IconButton(
            icon: SvgPicture.network(
                'https://raw.githubusercontent.com/juskek/web_portfolio/3971af96ed96c1a175360ff0b57753090b01fc67/assets/JK_sb.svg'),
            onPressed: () => launchURL(portfolioURL),
            splashRadius: kToolbarHeight * 0.4,
          ),
        ],
      ),
      body: CanvasNestTransition(
          _controller, nestConfig, nodeInfoList, screenSize),
    );
  }
}
