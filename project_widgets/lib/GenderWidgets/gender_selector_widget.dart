import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PVGenderControl extends ChangeNotifier {
  String? _selectedGender;

  String? get selectedGender => _selectedGender;

  set selectedGender(String? value) {
    _selectedGender = value;
    notifyListeners();
  }
}

class WDGenderSelector extends StatelessWidget {
  const WDGenderSelector({
    super.key,
    required this.onChanged,
    this.initVal,
    this.textDirection,
  });

  final ValueChanged<String> onChanged;
  final String? initVal;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (con) => PVGenderControl(),
      child: _WDGenderSelector(
        onChanged: onChanged,
        initVal: initVal,
        textDirection: textDirection,
      ),
    );
  }
}

class _WDGenderSelector extends StatefulWidget {
  const _WDGenderSelector({
    super.key,
    required this.onChanged,
    this.initVal,
    this.textDirection,
  });

  final ValueChanged<String> onChanged;
  final String? initVal;
  final TextDirection? textDirection;

  @override
  State<_WDGenderSelector> createState() => __WDGenderSelectorState();
}

class __WDGenderSelectorState extends State<_WDGenderSelector> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.initVal == null) return;
      context.read<PVGenderControl>().selectedGender = widget.initVal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.textDirection ?? TextDirection.ltr,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'الجنس',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blueGrey[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Consumer<PVGenderControl>(
                      builder:
                          (context, pv, child) => RadioListTile<String>(
                            value: 'M',
                            groupValue: pv.selectedGender,
                            onChanged: (value) {
                              if (value != null) {
                                pv.selectedGender = value;
                                widget.onChanged(value);
                              }
                            },
                            title: const Text('ذكر'),
                            activeColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                    ),
                  ),
                  Expanded(
                    child: Consumer<PVGenderControl>(
                      builder:
                          (context, pv, child) => RadioListTile<String>(
                            value: 'F',
                            groupValue: pv.selectedGender,
                            onChanged: (value) {
                              if (value != null) {
                                pv.selectedGender = value;
                                widget.onChanged(value);
                              }
                            },
                            title: const Text('أنثى'),
                            activeColor: Colors.pink,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
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
