# Introduction
Implementation of [hustcc](https://github.com/hustcc) [canvas_nest](https://github.com/hustcc/canvas-nest.js/) in Flutter. See example here (https://justinkek.com).


# Usage
1. Add `flutter_canvasnest` to pubspec.yaml and import package.
2. Initialise `screenSize`, `nestConfig` and `_canvasNestController` in State class (remember to dispose controller). 
3. At the start of the `build` method, query `screenSize` and generate `nodeInfoList`.
4. Add `CanvasNestTransition` to desired widget and pass `_canvasNestController`, `nestConfig`, `nodeInfoList` and `screenSize`.
```
// Step 1.
import 'package:flutter_canvasnest/flutter_canvasnest.dart';

class _ExampleState extends State<Example> with TickerProviderStateMixin{
    // Step 2.
    ScreenSize screenSize = ScreenSize(0, 0); // init screen size
    final CanvasNestConfig nestConfig = CanvasNestConfig(100, 1,
        Colors.grey.withAlpha(200), Colors.grey.withAlpha(200), 120, 0.02);

    late final AnimationController _canvasNestController = AnimationController(
        duration: Duration(seconds: 30), 
        vsync: this,
    )..repeat();
    // repeat animation progress so that transition keeps building (see listenable)


    @override
    Widget build(BuildContext context) {
        // Step 3.
        screenSize = ScreenSize(MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height - kToolbarHeight);
    
        List<NodeInfo> nodeInfoList =
            generateNodeInfo(context, nestConfig, screenSize);
        return Scaffold(
            appBar: AppBar(title: Text("Canvas Nest")),
            // Step 4.
            body: CanvasNestTransition(
                _canvasNestController, nestConfig, nodeInfoList, screenSize),
        );
    }
}

```