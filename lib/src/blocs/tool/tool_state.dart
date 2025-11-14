part of 'tool_bloc.dart';

class ToolState extends Equatable {
  final EditorTool activeTool;
  final LineStyle lineStyle;
  final FillStyle fillStyle;

  const ToolState({
    this.activeTool = EditorTool.arrow,
    this.lineStyle = const LineStyle(),
    this.fillStyle = const FillStyle(),
  });

  @override
  List<Object> get props => [activeTool, lineStyle, fillStyle];
}
