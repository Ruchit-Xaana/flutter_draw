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

  @override
  void didUpdateWidget(LineStyleEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update state when widget properties change (e.g., selection changes)
    if (oldWidget.initialStyle != widget.initialStyle) {
      _selectedColor = widget.initialStyle.color;
      _opacity = widget.initialStyle.opacity;
      _width = widget.initialStyle.width;
    }
    if (oldWidget.initialFillStyle != widget.initialFillStyle) {
      _fillColor = widget.initialFillStyle.color;
      _fillOpacity = widget.initialFillStyle.opacity;
    }
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

class TextStyleEditor extends StatefulWidget {
  final TextStyle initialStyle;
  final ValueChanged<TextStyle> onChanged;

  const TextStyleEditor({
    super.key,
    required this.initialStyle,
    required this.onChanged,
  });

  @override
  State<TextStyleEditor> createState() => _TextStyleEditorState();
}

class _TextStyleEditorState extends State<TextStyleEditor> {
  late Color _color;
  late double _fontSize;
  late bool _isBold;
  late bool _isItalic;

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
    final style = widget.initialStyle;
    _color = style.color ?? Colors.white;
    _fontSize = style.fontSize ?? 16;
    _isBold = style.fontWeight == FontWeight.bold;
    _isItalic = style.fontStyle == FontStyle.italic;
  }

  @override
  void didUpdateWidget(TextStyleEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialStyle != widget.initialStyle) {
      final style = widget.initialStyle;
      _color = style.color ?? Colors.white;
      _fontSize = style.fontSize ?? 16;
      _isBold = style.fontWeight == FontWeight.bold;
      _isItalic = style.fontStyle == FontStyle.italic;
    }
  }

  void _emitChange() {
    widget.onChanged(
      TextStyle(
        color: _color,
        fontSize: _fontSize,
        fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
        fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
      ),
    );
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
              Text(
                'Text Style',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.theme.colorScheme.foreground,
                ),
              ),
              const Gap(16),
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
                  final isSelected = _color.value == color.value;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _color = color);
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
              Text(
                'Font size',
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
                      value: SliderValue.single(_fontSize),
                      min: 8.0,
                      max: 64.0,
                      divisions: 56,
                      onChanged: (value) {
                        setState(() => _fontSize = value.value);
                        _emitChange();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Text(
                      _fontSize.toStringAsFixed(0),
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
              Text(
                'Weight & style',
                style: TextStyle(
                  fontSize: 12,
                  color: context.theme.colorScheme.mutedForeground,
                ),
              ),
              const Gap(8),
              Row(
                children: [
                  Expanded(
                    child: Toggle(
                      value: _isBold,
                      onChanged: (value) {
                        setState(() => _isBold = value);
                        _emitChange();
                      },
                      child: const Icon(Icons.format_bold, size: 16),
                    ),
                  ),
                  const Gap(8),
                  Expanded(
                    child: Toggle(
                      value: _isItalic,
                      onChanged: (value) {
                        setState(() => _isItalic = value);
                        _emitChange();
                      },
                      child: const Icon(Icons.format_italic, size: 16),
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
