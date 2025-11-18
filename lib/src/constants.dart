import 'package:flutter/material.dart';

final kCanvasRepaintBoundaryKey = GlobalKey();
final kNodeEditorWidgetKey = GlobalKey();
const kMaxEventUndoHistory = 128;
const kMaxEventRedoHistory = 128;
const kSpatialHashingCellSize = 2056.0;
