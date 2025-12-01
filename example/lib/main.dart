import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html; // For web download
import 'package:example/gen/assets.gen.dart';
import 'package:fldraw/fldraw.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<String> svgs;
  FlDrawController controller = FlDrawController();
  Map<String, dynamic>? loadedProjectData;

  @override
  void initState() {
    svgs = Assets.svgs.values.map((e) => e.path).toList();
    super.initState();
  }

  Future<void> downloadImage() async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Generating image...')));

      // Get the image bytes
      final Uint8List imageBytes = await controller!.getCanvasPngBytes(
        pixelRatio: 3.0,
        backgroundColor: Colors.black,
      );

      // Create blob and download (web)
      final blob = html.Blob([imageBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute(
          'download',
          'canvas_${DateTime.now().millisecondsSinceEpoch}.png',
        )
        ..click();
      html.Url.revokeObjectUrl(url);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image downloaded successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error downloading image: $e')));
    }
  }

  Future<void> saveProject() async {
    try {
      controller.saveProject((data) {
        final jsonStr = jsonEncode(data);
        final bytes = Uint8List.fromList(utf8.encode(jsonStr));
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute(
            'download',
            'fldraw_project_${DateTime.now().millisecondsSinceEpoch}.json',
          )
          ..click();
        html.Url.revokeObjectUrl(url);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project saved successfully!')),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving project: $e')));
    }
  }

  Future<void> loadProject() async {
    try {
      final input = html.FileUploadInputElement();
      input.accept = '.json';
      input.click();
      input.onChange.listen((event) {
        final file = input.files?.first;
        if (file != null) {
          final reader = html.FileReader();
          reader.readAsText(file);
          reader.onLoadEnd.listen((e) {
            try {
              final jsonStr = reader.result as String;
              final data = jsonDecode(jsonStr) as Map<String, dynamic>;
              controller.loadProject(data);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Project loaded successfully!')),
              );
            } catch (err) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error loading project: $err')),
              );
            }
          });
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading project: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 250, maxWidth: 250),
              child: HistoryPanel(controller: controller),
            ),
          ),
          const SizedBox(height: 12),
          // Save Project button
          FloatingActionButton(
            heroTag: 'saveProject',
            onPressed: saveProject,
            tooltip: 'Save Project',
            child: const Icon(Icons.save),
          ),
          const SizedBox(height: 12),
          // Load Project button
          FloatingActionButton(
            heroTag: 'loadProject',
            onPressed: loadProject,
            tooltip: 'Load Project',
            child: const Icon(Icons.folder_open),
          ),
        ],
      ),
      body: FlDraw(
        controller: controller,
        initialToolState: ToolState(
          lineStyle: LineStyle(color: shadcn.Colors.blue),
        ),
        onCanvasStateChanged: (state) {
          print("====== CANVAS ======");
          print(state.drawingObjects);
          print(state.nodes);
          print(state.viewportZoom);
          print(state.viewportOffset);
          print(state.redoStack);
          print(state.undoStack);
          print("====== CANVAS ======\n");
        },
        onSelectionStateChanged: (state) {
          print("====== SELECTION ======");
          print(state.selectedDrawingObjectIds);
          print(state.selectedNodeIds);
          print("====== SELECTION ======\n");
        },
        onToolStateChanged: (state) {
          print("====== TOOL ======");
          print(state.activeTool);
          print("====== TOOL ======\n");
        },
        child: Stack(
          children: [
            FlDrawCanvas(),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: FlToolbar(svgs: svgs),
              ),
            ),
            // Add the style side panel to the right
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: SizedBox(width: 320, child: const StyleSidePanel()),
              ),
            ),
            // Download button
            Positioned(
              top: 32,
              right: 32,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Download button
                  FloatingActionButton(
                    heroTag: 'download',
                    onPressed: downloadImage,
                    tooltip: 'Download Image',
                    child: const Icon(Icons.download),
                  ),
                  const SizedBox(height: 12),
                  // Zoom In button
                  FloatingActionButton(
                    heroTag: 'zoomIn',
                    onPressed: () => controller.zoomIn(),
                    tooltip: 'Zoom In',
                    child: const Icon(Icons.zoom_in),
                  ),
                  const SizedBox(height: 12),
                  // Zoom Out button
                  FloatingActionButton(
                    heroTag: 'zoomOut',
                    onPressed: () => controller.zoomOut(),
                    tooltip: 'Zoom Out',
                    child: const Icon(Icons.zoom_out),
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
