import 'package:fldraw/src/models/drawing_entities.dart'
    show LineStyle, FillStyle;
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

class LineStyleEditor extends StatefulWidget {
  final LineStyle initialStyle;
  final ValueChanged<LineStyle> onChanged;
  final FillStyle initialFillStyle;
  final ValueChanged<FillStyle> onFillChanged;

  const LineStyleEditor({
    super.key,
    required this.initialStyle,
    required this.onChanged,
    required this.initialFillStyle,
    required this.onFillChanged,
  });

  @override
  State<LineStyleEditor> createState() => _LineStyleEditorState();
}

class _LineStyleEditorState extends State<LineStyleEditor> {
  late Color _selectedColor;
  late double _opacity;
  late double _width;
  late Color _fillColor;
  late double _fillOpacity;

  // Preset colors list
  final _presetColors = const [
    Colors.white,
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.cyan,
    Colors.teal,
    Colors.indigo,
  ];

  @override
  void initState() {
    super.initState();
    // Initialize state from the passed widget configuration
    _selectedColor = widget.initialStyle.color;
    _opacity = widget.initialStyle.opacity;
    _width = widget.initialStyle.width;
    _fillColor = widget.initialFillStyle.color;
    _fillOpacity = widget.initialFillStyle.opacity;
  }

  void _emitChange() {
    widget.onChanged(
      LineStyle(color: _selectedColor, opacity: _opacity, width: _width),
    );
  }

  void _emitFillChange() {
    widget.onFillChanged(FillStyle(color: _fillColor, opacity: _fillOpacity));
  }

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Line Style',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.theme.colorScheme.foreground,
                ),
              ),
              const Gap(16),

              // --- Color Section ---
              Text(
                'Color',
                style: TextStyle(
                  fontSize: 12,
                  color: context.theme.colorScheme.mutedForeground,
                ),
              ),
              const Gap(8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _presetColors.map((color) {
                  final isSelected = _selectedColor.value == color.value;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedColor = color);
                      _emitChange();
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? context.theme.colorScheme.ring
                              : context.theme.colorScheme.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              size: 16,
                              color: color.computeLuminance() > 0.5
                                  ? Colors.black
                                  : Colors.white,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const Gap(16),

              // --- Opacity Section ---
              Text(
                'Opacity',
                style: TextStyle(
                  fontSize: 12,
                  color: context.theme.colorScheme.mutedForeground,
                ),
              ),
              const Gap(8),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: SliderValue.single(_opacity),
                      min: 0.0,
                      max: 1.0,
                      divisions: 100,
                      onChanged: (value) {
                        setState(() => _opacity = value.value);
                        _emitChange();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Text(
                      '${(_opacity * 100).toStringAsFixed(0)}%',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 12,
                        color: context.theme.colorScheme.mutedForeground,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(16),

              // --- Width Section ---
              Text(
                'Width',
                style: TextStyle(
                  fontSize: 12,
                  color: context.theme.colorScheme.mutedForeground,
                ),
              ),
              const Gap(8),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: SliderValue.single(_width),
                      min: 0.5,
                      max: 10.0,
                      divisions: 95,
                      onChanged: (value) {
                        setState(() => _width = value.value);
                        _emitChange();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Text(
                      _width.toStringAsFixed(1),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 12,
                        color: context.theme.colorScheme.mutedForeground,
                      ),
                    ),
                  ),
                ],
              ),

              // ===== Fill Style (optional) =====
              const Gap(24),
              Text(
                'Fill Color',
                style: TextStyle(
                  fontSize: 12,
                  color: context.theme.colorScheme.mutedForeground,
                ),
              ),
              const Gap(8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _presetColors.map((color) {
                  final isSelected =
                      _fillColor.value == color.value && _fillOpacity > 0;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _fillColor = color;
                        if (_fillOpacity == 0) _fillOpacity = 1.0;
                      });
                      _emitFillChange();
                    },
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? context.theme.colorScheme.ring
                              : context.theme.colorScheme.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              size: 14,
                              color: color.computeLuminance() > 0.5
                                  ? Colors.black
                                  : Colors.white,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const Gap(12),
              Text(
                'Fill Opacity',
                style: TextStyle(
                  fontSize: 12,
                  color: context.theme.colorScheme.mutedForeground,
                ),
              ),
              const Gap(8),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: SliderValue.single(_fillOpacity),
                      min: 0.0,
                      max: 1.0,
                      divisions: 100,
                      onChanged: (value) {
                        setState(() => _fillOpacity = value.value);
                        _emitFillChange();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Text(
                      '${(_fillOpacity * 100).toStringAsFixed(0)}%',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 12,
                        color: context.theme.colorScheme.mutedForeground,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
