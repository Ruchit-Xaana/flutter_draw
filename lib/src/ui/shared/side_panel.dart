import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fldraw/fldraw.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class StyleSidePanel extends StatelessWidget {
  const StyleSidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final selectionState = context.select((SelectionBloc bloc) => bloc.state);

    if (selectionState.selectedDrawingObjectIds.length != 1) {
      return const SizedBox.shrink();
    }

    final objectId = selectionState.selectedDrawingObjectIds.first;

    final obj = context.select(
      (CanvasBloc bloc) => bloc.state.drawingObjects[objectId],
    );

    if (obj == null) return const SizedBox.shrink();

    if (obj is TextObject) {
      return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextStyleEditor(
                initialStyle: obj.style,
                onChanged: (newStyle) {
                  context.read<CanvasBloc>().add(
                    DrawingObjectUpdated(obj.copyWith(style: newStyle)),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    LineStyle? lineStyle;
    FillStyle? fillStyle;
    if (obj is RectangleObject) {
      lineStyle = obj.lineStyle;
      fillStyle = obj.fillStyle;
    } else if (obj is CircleObject) {
      lineStyle = obj.lineStyle;
      fillStyle = obj.fillStyle;
    } else if (obj is ArrowObject) {
      lineStyle = obj.lineStyle;
    } else if (obj is LineObject) {
      lineStyle = obj.lineStyle;
    } else if (obj is PencilStrokeObject) {
      lineStyle = obj.lineStyle;
    }
    if (lineStyle == null) return const SizedBox.shrink();

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Layering controls
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton.ghost(
                    icon: const Icon(Icons.vertical_align_top),
                    onPressed: () {
                      context.read<CanvasBloc>().add(
                        BringDrawingObjectToFront(objectId),
                      );
                    },
                  ),
                  IconButton.ghost(
                    icon: const Icon(Icons.vertical_align_bottom),
                    onPressed: () {
                      context.read<CanvasBloc>().add(
                        SendDrawingObjectToBack(objectId),
                      );
                    },
                  ),
                  IconButton.ghost(
                    icon: const Icon(Icons.arrow_upward),
                    onPressed: () {
                      context.read<CanvasBloc>().add(
                        MoveDrawingObjectUp(objectId),
                      );
                    },
                  ),
                  IconButton.ghost(
                    icon: const Icon(Icons.arrow_downward),
                    onPressed: () {
                      context.read<CanvasBloc>().add(
                        MoveDrawingObjectDown(objectId),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Style editor
            LineStyleEditor(
              initialStyle: lineStyle,
              onChanged: (newLineStyle) {
                if (obj is RectangleObject) {
                  context.read<CanvasBloc>().add(
                    DrawingObjectUpdated(obj.copyWith(lineStyle: newLineStyle)),
                  );
                } else if (obj is CircleObject) {
                  context.read<CanvasBloc>().add(
                    DrawingObjectUpdated(obj.copyWith(lineStyle: newLineStyle)),
                  );
                } else if (obj is ArrowObject) {
                  context.read<CanvasBloc>().add(
                    DrawingObjectUpdated(obj.copyWith(lineStyle: newLineStyle)),
                  );
                } else if (obj is LineObject) {
                  context.read<CanvasBloc>().add(
                    DrawingObjectUpdated(obj.copyWith(lineStyle: newLineStyle)),
                  );
                } else if (obj is PencilStrokeObject) {
                  context.read<CanvasBloc>().add(
                    DrawingObjectUpdated(obj.copyWith(lineStyle: newLineStyle)),
                  );
                }
              },
              initialFillStyle: fillStyle ?? const FillStyle(),
              onFillChanged: (newFillStyle) {
                if (obj is RectangleObject) {
                  context.read<CanvasBloc>().add(
                    DrawingObjectUpdated(obj.copyWith(fillStyle: newFillStyle)),
                  );
                } else if (obj is CircleObject) {
                  context.read<CanvasBloc>().add(
                    DrawingObjectUpdated(obj.copyWith(fillStyle: newFillStyle)),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
