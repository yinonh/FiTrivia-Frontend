import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../Widgets/camera_widget.dart';

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp(this.camera);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trivia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(camera),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final CameraDescription camera;

  MyHomePage(this.camera);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Demo'),
        centerTitle: true,
      ),
      body: Container(
        //height: MediaQuery.of(context).size.height * 0.5,
        //width: MediaQuery.of(context).size.width * 0.6,
        child: Column(
          children: [
            Container(
              height: (MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).viewPadding.top) *
                  0.4,
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: CameraPreview(_controller),
                        ),
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            SizedBox(
                height: (MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).viewPadding.top) *
                    0.1),
            Container(
              height: (MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).viewPadding.top) *
                  0.5,
              child: GridView.count(
                padding: const EdgeInsets.all(10),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                crossAxisCount: 2,
                childAspectRatio: 1 / 0.6,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("answer 1"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("answer 2"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("answer 3"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("answer 4"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
