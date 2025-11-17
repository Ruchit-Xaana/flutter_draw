import 'package:fldraw/fldraw.dart';
import 'package:fldraw/src/constants.dart';
import 'package:fldraw/src/core/utils/renderbox.dart';
import 'package:fldraw/src/gen/assets.gen.dart';
import 'package:fldraw/src/models/drawing_entities.dart';
import 'package:fldraw/src/ui/shared/line_style_editor.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' hide TabItem;
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:uuid/uuid.dart';

import 'custom_tab.dart';

class FlToolbar extends StatelessWidget {
  final List<String> svgs;
  final FlDrawController? controller;

  const FlToolbar({super.key, required this.svgs, required this.controller});

  @override
  Widget build(BuildContext context) {
    final padding = const EdgeInsets.symmetric(vertical: 10.0);

    final toolBloc = context.watch<ToolBloc>();

    void onToolSelected(int index, BuildContext? popoverContext) {
      final tool = EditorTool.values.elementAt(index);

      if (tool == EditorTool.add) {
        if (popoverContext == null) return;
        _showAddPopover(popoverContext);
      } else {
        toolBloc.add(ToolSelected(tool));
      }
    }

    return BlocBuilder<ToolBloc, ToolState>(
      builder: (context, state) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Builder(
              builder: (context) {
                return CustomTabs(
                  index: state.activeTool.index,
                  onChanged: (index) =>
                      onToolSelected(index, index == 9 ? context : null),
                  children: [
                    TabItem(
                      index: 9,
                      child: SizedBox(
                        child: Padding(
                          padding: padding.copyWith(
                            top: padding.top + 2,
                            bottom: padding.bottom + 2,
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Assets.icons.add.svg(
                                width: 16,
                                color: context.theme.colorScheme.foreground,
                              ),
                              Positioned(
                                bottom: -10,
                                right: -10,
                                child: Text(
                                  '/',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Gap(16),
            CustomTabs(
              index: state.activeTool.index,
              onChanged: (index) => onToolSelected(index, null),
              children: [
                TabItem(
                  child: Padding(
                    padding: padding,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Assets.icons.arrow.svg(
                          width: 16,
                          color: context.theme.colorScheme.foreground,
                        ),
                        Positioned(
                          bottom: -10,
                          right: -10,
                          child: Text('V', style: TextStyle(fontSize: 10)),
                        ),
                      ],
                    ),
                  ),
                ),
                TabItem(
                  child: Padding(
                    padding: padding,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          Icons.open_with,
                          size: 16,
                          color: context.theme.colorScheme.foreground,
                        ),
                        Positioned(
                          bottom: -10,
                          right: -10,
                          child: Text('P', style: TextStyle(fontSize: 10)),
                        ),
                      ],
                    ),
                  ),
                ),
                TabItem(
                  child: Padding(
                    padding: padding,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Assets.icons.square.svg(
                          width: 16,
                          color: context.theme.colorScheme.foreground,
                        ),
                        Positioned(
                          bottom: -10,
                          right: -10,
                          child: Text('R', style: TextStyle(fontSize: 10)),
                        ),
                      ],
                    ),
                  ),
                ),
                TabItem(
                  child: Padding(
                    padding: padding,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Assets.icons.circle.svg(
                          width: 16,
                          color: context.theme.colorScheme.foreground,
                        ),
                        Positioned(
                          bottom: -10,
                          right: -10,
                          child: Text('O', style: TextStyle(fontSize: 10)),
                        ),
                      ],
                    ),
                  ),
                ),
                TabItem(
                  child: Padding(
                    padding: padding,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Assets.icons.arrowTopRight.svg(
                          width: 16,
                          color: context.theme.colorScheme.foreground,
                        ),
                        Positioned(
                          bottom: -10,
                          right: -10,
                          child: Text('A', style: TextStyle(fontSize: 10)),
                        ),
                      ],
                    ),
                  ),
                ),
                TabItem(
                  child: Padding(
                    padding: padding,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Assets.icons.line.svg(
                          width: 16,
                          color: context.theme.colorScheme.foreground,
                        ),
                        Positioned(
                          bottom: -10,
                          right: -10,
                          child: Text('L', style: TextStyle(fontSize: 10)),
                        ),
                      ],
                    ),
                  ),
                ),
                TabItem(
                  child: Padding(
                    padding: padding,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Assets.icons.pencil.svg(
                          width: 16,
                          color: context.theme.colorScheme.foreground,
                        ),
                        Positioned(
                          bottom: -10,
                          right: -10,
                          child: Text('D', style: TextStyle(fontSize: 10)),
                        ),
                      ],
                    ),
                  ),
                ),
                TabItem(
                  child: Padding(
                    padding: padding,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Assets.icons.text.svg(
                          width: 16,
                          color: context.theme.colorScheme.foreground,
                        ),
                        Positioned(
                          bottom: -10,
                          right: -10,
                          child: Text('T', style: TextStyle(fontSize: 10)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Gap(16),
            CustomTabs(
              index: state.activeTool.index,
              onChanged: (index) => onToolSelected(index, null),
              children: [
                TabItem(
                  index: 7,
                  child: Padding(
                    padding: padding.copyWith(
                      top: padding.top + 2,
                      bottom: padding.bottom + 2,
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Assets.icons.figure.svg(
                          width: 16,
                          color: context.theme.colorScheme.foreground,
                        ),
                        Positioned(
                          bottom: -10,
                          right: -10,
                          child: Text('F', style: TextStyle(fontSize: 10)),
                        ),
                      ],
                    ),
                  ),
                ),
                TabItem(
                  index: 8,
                  child: Padding(
                    padding: padding,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Assets.icons.comment.svg(
                          width: 16,
                          color: context.theme.colorScheme.foreground,
                        ),
                        Positioned(
                          bottom: -10,
                          right: -10,
                          child: Text('C', style: TextStyle(fontSize: 10)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Gap(16),
            Builder(
              builder: (context) {
                return _LineStyleSelector(
                  lineStyle: state.lineStyle,
                  onLineStyleChanged: (lineStyle) {
                    toolBloc.add(LineStyleChanged(lineStyle));
                  },
                  fillStyle: state.fillStyle,
                  onFillStyleChanged: (fillStyle) {
                    toolBloc.add(FillStyleChanged(fillStyle));
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddPopover(BuildContext context) {
    final canvasBloc = context.read<CanvasBloc>();
    List<String> assets = svgs;
    List<String> filteredAssets = assets;

    showPopover(
      context: context,
      alignment: Alignment.topCenter,
      offset: const Offset(240, 8),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return ModalContainer(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200),
                child: SizedBox(
                  width: 460,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        placeholder: Text('Search over 2500+ icons...'),
                        autofocus: true,
                        onChanged: (value) {
                          setState(() {
                            filteredAssets = svgs
                                .where(
                                  (e) => e
                                      .split('/')
                                      .last
                                      .split('.')
                                      .first
                                      .toLowerCase()
                                      .contains(value.toLowerCase()),
                                )
                                .toList();
                          });
                        },
                      ),
                      Gap(16),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 8,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemCount: filteredAssets.length,
                          itemBuilder: (context, index) => IconButton.outline(
                            onPressed: () {
                              closeOverlay(
                                context,
                                filteredAssets.elementAt(index),
                              );
                            },
                            icon: SvgPicture.asset(filteredAssets[index]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).future.then((value) async {
      if (value != null && value is String) {
        final String svgString = await rootBundle.loadString(value);
        final pictureInfo = await vg.loadPicture(
          SvgStringLoader(svgString),
          null,
        );
        final Size svgSize = pictureInfo.size;

        final canvasState = canvasBloc.state;
        final editorBounds = getEditorBoundsInScreen(kNodeEditorWidgetKey);
        final centerOfScreenWorldPos =
            screenToWorld(
              editorBounds?.center ?? Offset.zero,
              canvasState.viewportOffset,
              canvasState.viewportZoom,
            ) ??
            Offset.zero;

        final initialRect = Rect.fromCenter(
          center: centerOfScreenWorldPos,
          width: svgSize.width.isFinite ? svgSize.width : 100.0,
          height: svgSize.height.isFinite ? svgSize.height : 100.0,
        );

        final newObject = SvgObject(
          id: const Uuid().v4(),
          rect: initialRect,
          assetPath: value,
          pictureInfo: pictureInfo,
        );

        canvasBloc.add(DrawingObjectAdded(newObject));
      }
    });
  }
}

class _LineStyleSelector extends StatelessWidget {
  final LineStyle lineStyle;
  final ValueChanged<LineStyle> onLineStyleChanged;
  final FillStyle fillStyle;
  final ValueChanged<FillStyle> onFillStyleChanged;

  const _LineStyleSelector({
    required this.lineStyle,
    required this.onLineStyleChanged,
    required this.fillStyle,
    required this.onFillStyleChanged,
  });

  void _showLineStylePopover(BuildContext context) {
    showPopover(
      context: context,
      alignment: Alignment.topCenter,
      offset: const Offset(0, 8),
      builder: (context) {
        return LineStyleEditor(
          initialStyle: lineStyle,
          onChanged: onLineStyleChanged,
          initialFillStyle: fillStyle,
          onFillChanged: onFillStyleChanged,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton.outline(
      size: ButtonSize.large,
      onPressed: () => _showLineStylePopover(context),
      icon: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.format_color_fill,
            size: 16,
            color: context.theme.colorScheme.foreground,
          ),
          Positioned(
            bottom: 2,
            left: 2,
            right: 2,
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                color: lineStyle.color.withValues(alpha: lineStyle.opacity),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
