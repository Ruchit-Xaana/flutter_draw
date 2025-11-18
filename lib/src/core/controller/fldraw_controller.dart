import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:fldraw/src/constants.dart';
import 'dart:async';

import 'package:fldraw/fldraw.dart';

/// A controller to programmatically interact with the fldraw canvas.
///
/// This controller provides a clean API to access functionalities like changing tools,
/// performing undo/redo, adding objects, and listening to state changes from
/// outside the main `FlDraw` widget.
///
/// ## Usage
///
/// 1. Create an instance of the controller.
/// ```dart
/// final controller = FlDrawController();
/// ```
///
/// 2. Pass it to the `FlDraw` widget.
/// ```dart
/// FlDraw(
///   controller: controller,
///   child: FlDrawCanvas(),
/// );
/// ```
///
/// 3. Use the controller's methods and streams.
/// ```dart
/// controller.setTool(EditorTool.square);
/// controller.undo();
///
/// controller.canvasStateStream.listen((state) {
///   print('Canvas updated! It now has ${state.nodes.length} nodes.');
/// });
/// ```
class FlDrawControllerImpl implements FlDrawController {
  CanvasBloc? _canvasBloc;
  SelectionBloc? _selectionBloc;
  ToolBloc? _toolBloc;

  bool _isInitialized = false;

  /// Initializes the controller with the BLoCs from the `FlDraw` widget.
  /// This is intended for internal use by the library.
  void init(
    CanvasBloc canvasBloc,
    SelectionBloc selectionBloc,
    ToolBloc toolBloc,
  ) {
    _canvasBloc = canvasBloc;
    _selectionBloc = selectionBloc;
    _toolBloc = toolBloc;
    _isInitialized = true;
  }

  /// Throws an error if the controller has not been attached to an [FlDraw] widget.
  void _assertIsInitialized() {
    assert(
      _isInitialized,
      'FlDrawController is not attached to an FlDraw widget. '
      'Please pass this controller to the `controller` property of an FlDraw widget.',
    );
  }

  // --- State Getters and Streams ---

  /// Provides a stream of [CanvasState] updates.
  /// Listen to this to react to changes in nodes, drawing objects, or viewport.
  @override
  Stream<CanvasState> get canvasStateStream {
    _assertIsInitialized();
    return _canvasBloc!.stream;
  }

  /// Gets the current [CanvasState].
  @override
  CanvasState get canvasState {
    _assertIsInitialized();
    return _canvasBloc!.state;
  }

  /// Provides a stream of [SelectionState] updates.
  /// Listen to this to react to changes in object selection.
  @override
  Stream<SelectionState> get selectionStateStream {
    _assertIsInitialized();
    return _selectionBloc!.stream;
  }

  /// Gets the current [SelectionState].
  @override
  SelectionState get selectionState {
    _assertIsInitialized();
    return _selectionBloc!.state;
  }

  /// Provides a stream of [ToolState] updates.
  /// Listen to this to react to changes in the active tool.
  @override
  Stream<ToolState> get toolStateStream {
    _assertIsInitialized();
    return _toolBloc!.stream;
  }

  /// Gets the current [ToolState].
  @override
  ToolState get toolState {
    _assertIsInitialized();
    return _toolBloc!.state;
  }

  // --- Tool Methods ---

  /// Sets the active drawing tool.
  @override
  void setTool(EditorTool tool) {
    _assertIsInitialized();
    _toolBloc!.add(ToolSelected(tool));
  }

  // --- History Methods ---

  /// Reverts the last action.
  @override
  void undo() {
    _assertIsInitialized();
    _canvasBloc!.add(UndoRequested());
  }

  /// Re-applies the last undone action.
  @override
  void redo() {
    _assertIsInitialized();
    _canvasBloc!.add(RedoRequested());
  }

  // --- Object Manipulation Methods ---

  /// Adds a new [NodeInstance] to the canvas.
  @override
  void addNode(NodeInstance node) {
    _assertIsInitialized();
    _canvasBloc!.add(NodeAdded(node));
  }

  /// Adds a new [DrawingObject] (e.g., Rectangle, Circle) to the canvas.
  @override
  void addDrawingObject(DrawingObject object) {
    _assertIsInitialized();
    _canvasBloc!.add(DrawingObjectAdded(object));
  }

  /// Removes a set of objects from the canvas by their IDs.
  @override
  void removeObjects({
    Set<String> nodeIds = const {},
    Set<String> drawingObjectIds = const {},
  }) {
    _assertIsInitialized();
    _canvasBloc!.add(
      ObjectsRemoved(nodeIds: nodeIds, drawingObjectIds: drawingObjectIds),
    );
  }

  /// Removes all currently selected objects from the canvas.
  @override
  void removeSelectedObjects() {
    _assertIsInitialized();
    final selection = selectionState;
    removeObjects(
      nodeIds: selection.selectedNodeIds,
      drawingObjectIds: selection.selectedDrawingObjectIds,
    );
  }

  // --- Selection Methods ---

  /// Clears the current selection.
  @override
  void clearSelection() {
    _assertIsInitialized();
    _selectionBloc!.add(SelectionCleared());
  }

  /// Replaces the current selection with a new set of objects.
  @override
  void setSelection({
    Set<String> nodeIds = const {},
    Set<String> drawingObjectIds = const {},
  }) {
    _assertIsInitialized();
    _selectionBloc!.add(
      SelectionReplaced(nodeIds: nodeIds, drawingObjectIds: drawingObjectIds),
    );
  }

  // --- Viewport Methods ---

  /// Pans the canvas by the given [delta] offset.
  @override
  void pan(Offset delta) {
    _assertIsInitialized();
    _canvasBloc!.add(CanvasPanned(delta));
  }

  /// Zooms the canvas to a specific [newZoom] level.
  /// The zoom level is clamped between 0.1 and 10.0.
  @override
  void zoom(double newZoom) {
    _assertIsInitialized();
    _canvasBloc!.add(CanvasZoomed(newZoom.clamp(0.1, 10.0)));
  }

  /// Zooms in by a fixed factor.
  @override
  void zoomIn([double factor = 1.2]) {
    _assertIsInitialized();
    zoom(canvasState.viewportZoom * factor);
  }

  /// Zooms out by a fixed factor.
  @override
  void zoomOut([double factor = 1.2]) {
    _assertIsInitialized();
    zoom(canvasState.viewportZoom / factor);
  }

  /// Resets the canvas zoom to 1.0.
  @override
  void resetZoom() {
    _assertIsInitialized();
    zoom(1.0);
  }

  /// Resets the canvas pan to the center (Offset.zero).
  @override
  void centerView() {
    _assertIsInitialized();
    // To set the offset to zero, we need to pan by the negative of the current offset.
    _canvasBloc!.add(CanvasPanned(-canvasState.viewportOffset));
  }

  // --- Project Methods ---

  /// Clears the canvas to start a new project.
  @override
  void createNewProject() {
    _assertIsInitialized();
    _canvasBloc!.add(NewProjectCreated());
  }

  /// Loads a project from the given [data] map.
  @override
  void loadProject(Map<String, dynamic> data) {
    _assertIsInitialized();
    _canvasBloc!.add(ProjectLoaded(data));
  }

  /// Triggers a save action. The [onSave] callback will receive the project data.
  @override
  void saveProject(Function(Map<String, dynamic>) onSave) {
    _assertIsInitialized();
    _canvasBloc!.add(ProjectSaved(onSave: onSave));
  }

  /// Returns a PNG of the current canvas as bytes.
  @override
  Future<Uint8List> getCanvasPngBytes({
    double? pixelRatio,
    Color? backgroundColor,
  }) async {
    _assertIsInitialized();
    final canvasState = _canvasBloc!.state;
    final allRects = [...canvasState.drawingObjects.values.map((o) => o.rect)];
    if (allRects.isEmpty) {
      throw Exception('No objects to export.');
    }
    Rect bounds = allRects.reduce((a, b) => a.expandToInclude(b));
    const double padding = 32.0;
    bounds = bounds.inflate(padding);

    // 2. Compute new zoom and offset to fit bounds
    final context = kCanvasRepaintBoundaryKey.currentContext;
    if (context == null) {
      throw Exception('Canvas context not found.');
    }
    final boundary = context.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      throw Exception('Render boundary not found.');
    }
    final size = boundary.size;
    debugPrint('Canvas size: $size, Bounds to fit: $bounds');

    // Calculate zoom to fit bounds in viewport
    final scaleX = size.width / bounds.width;
    final scaleY = size.height / bounds.height;

    final fitZoom = scaleX < scaleY ? scaleX : scaleY;
    final fitOffset =
        -canvasState.viewportOffset +
        Offset(
          -bounds.left - (bounds.width / 2),
          -bounds.top - (bounds.height / 2),
        );

    // 3. Temporarily clear selection and set viewport
    _selectionBloc!.add(SelectionCleared());
    if (scaleX < 1.0 || scaleY < 1.0) {
      _canvasBloc!.add(CanvasZoomed(fitZoom));
    }

    _canvasBloc!.add(CanvasPanned(fitOffset));
    await Future.delayed(const Duration(milliseconds: 50));
    await Future.delayed(Duration.zero);

    // 5. Capture image
    final image = await boundary.toImage(pixelRatio: pixelRatio ?? 3.0);

    // 6. Apply background color if specified
    if (backgroundColor != null) {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final paint = Paint()..color = backgroundColor;

      // Draw background
      canvas.drawRect(
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        paint,
      );

      // Draw original image on top
      canvas.drawImage(image, Offset.zero, Paint());

      final picture = recorder.endRecording();
      final finalImage = await picture.toImage(image.width, image.height);
      final byteData = await finalImage.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        throw Exception('Failed to encode image as PNG.');
      }

      return byteData.buffer.asUint8List();
    }

    // Original path without background
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception('Failed to encode image as PNG.');
    }

    return byteData.buffer.asUint8List();
  }

  /// Disposes of the controller's resources.
  /// Should be called when the controller is no longer needed.
  /// This is handled automatically by the `FlDraw` widget.
  @override
  void dispose() {
    _canvasBloc = null;
    _selectionBloc = null;
    _toolBloc = null;
    _isInitialized = false;
  }
}
