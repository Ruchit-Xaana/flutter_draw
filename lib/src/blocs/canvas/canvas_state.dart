part of 'canvas_bloc.dart';

typedef HistoryEntry = (CanvasState state, CanvasEvent event);

final class CanvasState extends Equatable {
  final Map<String, NodeInstance> nodes;
  final Map<String, DrawingObject> drawingObjects;

  /// List of drawing object IDs in z-order (first is back, last is front)
  final List<String> drawingObjectOrder;
  final Offset viewportOffset;
  final double viewportZoom;

  // History stacks
  final List<HistoryEntry> undoStack;
  final List<HistoryEntry> redoStack;

  const CanvasState({
    this.nodes = const {},
    this.drawingObjects = const {},
    this.drawingObjectOrder = const [],
    this.viewportOffset = Offset.zero,
    this.viewportZoom = 1.0,
    this.undoStack = const [],
    this.redoStack = const [],
  });

  // A helper constructor to create a "historic" state without its own history stacks
  CanvasState.historic({
    required this.nodes,
    required this.drawingObjects,
    required this.drawingObjectOrder,
    required this.viewportOffset,
    required this.viewportZoom,
  }) : undoStack = [],
       redoStack = [];

  CanvasState copyWith({
    Map<String, NodeInstance>? nodes,
    Map<String, DrawingObject>? drawingObjects,
    List<String>? drawingObjectOrder,
    Offset? viewportOffset,
    double? viewportZoom,
    List<HistoryEntry>? undoStack,
    List<HistoryEntry>? redoStack,
  }) {
    return CanvasState(
      nodes: nodes ?? this.nodes,
      drawingObjects: drawingObjects ?? this.drawingObjects,
      drawingObjectOrder: drawingObjectOrder ?? this.drawingObjectOrder,
      viewportOffset: viewportOffset ?? this.viewportOffset,
      viewportZoom: viewportZoom ?? this.viewportZoom,
      undoStack: undoStack ?? this.undoStack,
      redoStack: redoStack ?? this.redoStack,
    );
  }

  @override
  List<Object> get props => [
    nodes,
    drawingObjects,
    drawingObjectOrder,
    viewportOffset,
    viewportZoom,
    undoStack,
    redoStack,
  ];
}
