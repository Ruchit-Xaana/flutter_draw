import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fldraw/src/models/drawing_entities.dart';

part 'tool_event.dart';
part 'tool_state.dart';

class ToolBloc extends Bloc<ToolEvent, ToolState> {
  ToolBloc() : super(const ToolState()) {
    on<ToolEvent>((event, emit) async {
      return (switch (event) {
        ToolSelected e => _onToolSelected(e, emit),
        LineStyleChanged e => _onLineStyleChanged(e, emit),
        FillStyleChanged e => _onFillStyleChanged(e, emit),
      });
    });
  }

  void _onToolSelected(ToolSelected event, Emitter<ToolState> emit) {
    emit(
      ToolState(
        activeTool: event.tool,
        lineStyle: state.lineStyle,
        fillStyle: state.fillStyle,
      ),
    );
  }

  void _onLineStyleChanged(LineStyleChanged event, Emitter<ToolState> emit) {
    emit(
      ToolState(
        activeTool: state.activeTool,
        lineStyle: event.lineStyle,
        fillStyle: state.fillStyle,
      ),
    );
  }

  void _onFillStyleChanged(FillStyleChanged event, Emitter<ToolState> emit) {
    emit(
      ToolState(
        activeTool: state.activeTool,
        lineStyle: state.lineStyle,
        fillStyle: event.fillStyle,
      ),
    );
  }
}
