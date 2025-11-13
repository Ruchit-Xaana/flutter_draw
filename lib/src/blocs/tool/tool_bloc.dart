import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fldraw/src/models/drawing_entities.dart';

part 'tool_event.dart';
part 'tool_state.dart';

class ToolBloc extends Bloc<ToolEvent, ToolState> {
  ToolBloc() : super(const ToolState()) {
    on<ToolSelected>(_onToolSelected);
    on<LineStyleChanged>(_onLineStyleChanged);
  }

  void _onToolSelected(ToolSelected event, Emitter<ToolState> emit) {
    emit(ToolState(activeTool: event.tool, lineStyle: state.lineStyle));
  }

  void _onLineStyleChanged(LineStyleChanged event, Emitter<ToolState> emit) {
    emit(ToolState(activeTool: state.activeTool, lineStyle: event.lineStyle));
  }
}
