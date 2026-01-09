part of 'tool_bloc.dart';

class ToolState extends Equatable {
  final EditorTool activeTool;
  final LineStyle lineStyle;
  final FillStyle fillStyle;
  final TextStyle textStyle;

  const ToolState({
    this.activeTool = EditorTool.arrow,
    this.lineStyle = const LineStyle(),
    this.fillStyle = const FillStyle(),
    this.textStyle = const TextStyle(fontSize: 16, color: Colors.white),
  });
  @override
  List<Object> get props => [activeTool, lineStyle, fillStyle, textStyle];
}
