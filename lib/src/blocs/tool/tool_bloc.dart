import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fldraw/src/models/drawing_entities.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

part 'tool_event.dart';
part 'tool_state.dart';

class ToolBloc extends Bloc<ToolEvent, ToolState> {
  ToolBloc({ToolState initialState = const ToolState()}) : super(initialState) {
    on<ToolEvent>((event, emit) async {
      return (switch (event) {
        ToolSelected e => _onToolSelected(e, emit),
        LineStyleChanged e => _onLineStyleChanged(e, emit),
        FillStyleChanged e => _onFillStyleChanged(e, emit),
        TextStyleChanged e => _onTextStyleChanged(e, emit),
      });
    });
  }

  void _onToolSelected(ToolSelected event, Emitter<ToolState> emit) {
    emit(
      ToolState(
        activeTool: event.tool,
        lineStyle: state.lineStyle,
        fillStyle: state.fillStyle,
        textStyle: state.textStyle,
      ),
    );
  }

  void _onLineStyleChanged(LineStyleChanged event, Emitter<ToolState> emit) {
    emit(
      ToolState(
        activeTool: state.activeTool,
        lineStyle: event.lineStyle,
        fillStyle: state.fillStyle,
        textStyle: state.textStyle,
      ),
    );
  }

  void _onFillStyleChanged(FillStyleChanged event, Emitter<ToolState> emit) {
    emit(
      ToolState(
        activeTool: state.activeTool,
        lineStyle: state.lineStyle,
        fillStyle: event.fillStyle,
        textStyle: state.textStyle,
      ),
    );
  }

  void _onTextStyleChanged(TextStyleChanged event, Emitter<ToolState> emit) {
    emit(
      ToolState(
        activeTool: state.activeTool,
        lineStyle: state.lineStyle,
        fillStyle: state.fillStyle,
        textStyle: event.textStyle,
      ),
    );
  }
}
