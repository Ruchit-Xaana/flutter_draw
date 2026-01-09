part of 'tool_bloc.dart';

sealed class ToolEvent extends Equatable {
  const ToolEvent();

  @override
  List<Object> get props => [];
}

/// Event dispatched when a new tool is selected from the toolbar.
final class ToolSelected extends ToolEvent {
  final EditorTool tool;

  const ToolSelected(this.tool);

  @override
  List<Object> get props => [tool];
}

/// Event dispatched when line style is changed in the toolbar.
class LineStyleChanged extends ToolEvent {
  final LineStyle lineStyle;

  const LineStyleChanged(this.lineStyle);

  @override
  List<Object> get props => [lineStyle];
}

/// Event dispatched when fill style is changed in the toolbar.
class FillStyleChanged extends ToolEvent {
  final FillStyle fillStyle;

  const FillStyleChanged(this.fillStyle);

  @override
  List<Object> get props => [fillStyle];
}

/// Event dispatched when text style is changed (for text tool / text objects).
class TextStyleChanged extends ToolEvent {
  final TextStyle textStyle;

  const TextStyleChanged(this.textStyle);

  @override
  List<Object> get props => [textStyle];
}
