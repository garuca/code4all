import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';

import 'profile_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Scalable OCR',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          floatingLabelStyle: TextStyle(color: Colors.blue.shade700),
        ),
      ),
      home: const MyHomePage(title: 'Flutter Scalable OCR'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String text = "";
  final StreamController<String> controller = StreamController<String>();
  bool torchOn = false;
  int cameraSelection = 0;
  bool lockCamera = true;
  bool loading = false;
  final GlobalKey<ScalableOCRState> cameraKey = GlobalKey<ScalableOCRState>();

  void setText(value) {
    controller.add(value);
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            !loading
                ? ScalableOCR(
                    key: cameraKey,
                    torchOn: torchOn,
                    cameraSelection: cameraSelection,
                    lockCamera: lockCamera,
                    paintboxCustom: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 4.0
                      ..color = const Color.fromARGB(153, 102, 160, 241),
                    boxLeftOff: 5,
                    boxBottomOff: 2.5,
                    boxRightOff: 5,
                    boxTopOff: 2.5,
                    boxHeight: MediaQuery.of(context).size.height / 3,
                    getRawData: (value) {
                      inspect(value);
                    },
                    getScannedText: (value) {
                      setText(value);
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.all(17.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<String>(
                stream: controller.stream,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return Result(
                        text: snapshot.data != null ? snapshot.data! : "",
                      );
                    },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.switch_camera_outlined),
                    label: const Text("Câmera"),
                    onPressed: () {
                      setState(() {
                        loading = true;
                        cameraSelection = cameraSelection == 0 ? 1 : 0;
                      });
                      Future.delayed(const Duration(milliseconds: 150), () {
                        setState(() {
                          loading = false;
                        });
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: Icon(
                      torchOn
                          ? Icons.flash_on_outlined
                          : Icons.flash_off_outlined,
                    ),
                    label: const Text("Lanterna"),
                    onPressed: () async {
                      setState(() {
                        loading = true;
                        torchOn = !torchOn;
                      });
                      Future.delayed(const Duration(milliseconds: 150), () {
                        setState(() {
                          loading = false;
                        });
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: Icon(
                      lockCamera
                          ? Icons.lock_outline
                          : Icons.lock_open_outlined,
                    ),
                    label: const Text("Travar"),
                    onPressed: () {
                      setState(() {
                        loading = true;
                        lockCamera = !lockCamera;
                      });
                      Future.delayed(const Duration(milliseconds: 150), () {
                        setState(() {
                          loading = false;
                        });
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Result extends StatelessWidget {
  const Result({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      "Texto Identificado: $text",
      style: Theme.of(context).textTheme.titleMedium,
      textAlign: TextAlign.center,
    );
  }
}
