import 'dart:async';
import 'package:flutter/material.dart';

class TextSelectorLine extends StatefulWidget {
  final List<String> words;
  final Function(String) onWordSelected;
  final Color defaultColor;
  final Color backgroundColor;
  final double defaultFontSize;
  final double selectedFontSize;
  final bool showBackground;
  final int cooldownDuration;

  const TextSelectorLine({
    super.key,
    required this.words,
    required this.onWordSelected,
    this.defaultColor = Colors.grey,
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.defaultFontSize = 16.0,
    this.selectedFontSize = 20.0,
    this.showBackground = true,
    this.cooldownDuration = 2000,
  });

  @override
  State<TextSelectorLine> createState() => _TextSelectorLineState();
}

class _TextSelectorLineState extends State<TextSelectorLine> {
  int _selectedIndex = -1;
  final ScrollController _scrollController = ScrollController();
  bool _isCooldown = false;
  Timer? _cooldownTimer;
  Timer? _scrollTimer;
  bool _scrollForward = true;
  bool _isPaused = false;
  bool _isUserScrolling = false;
  Timer? _userScrollTimer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.isScrollingNotifier.value) {
        _handleUserScrollStart();
      }
    });
  }

  void _handleUserScrollStart() {
    if (_isUserScrolling) return;
    setState(() {
      _isUserScrolling = true;
    });
    _scrollTimer?.cancel();
    _userScrollTimer?.cancel();
    _userScrollTimer = Timer(const Duration(seconds: 3), _handleUserScrollEnd);
  }

  void _handleUserScrollEnd() {
    if (!mounted) return;
    setState(() {
      _isUserScrolling = false;
    });
    if (!_isCooldown && !_isPaused) {
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    const tickRate = Duration(milliseconds: 30);
    double speed = 40;
    _scrollTimer = Timer.periodic(tickRate, (timer) {
      if (!mounted || _isPaused || _isUserScrolling || _isCooldown) return;
      final maxScroll = _scrollController.position.maxScrollExtent;
      final current = _scrollController.offset;
      double step = speed * (tickRate.inMilliseconds / 1000);
      double next = _scrollForward ? current + step : current - step;

      if (next >= maxScroll) {
        _pauseAndReverse();
        return;
      } else if (next <= 0) {
        _pauseAndReverse();
        return;
      }

      if (mounted) {
        _scrollController.jumpTo(next.clamp(0.0, maxScroll));
      }
    });
  }

  void _pauseAndReverse() {
    if (!mounted || _isPaused || _isUserScrolling) return;

    setState(() {
      _isPaused = true;
    });
    _scrollTimer?.cancel();
    Timer(const Duration(seconds: 5), () {
      if (!mounted) return;
      setState(() {
        _isPaused = false;
        _scrollForward = !_scrollForward;
      });
      if (!_isUserScrolling && !_isCooldown) {
        _startAutoScroll();
      }
    });
  }

  void _startCooldown() {
    setState(() => _isCooldown = true);
    _scrollTimer?.cancel();
    _cooldownTimer?.cancel();

    _cooldownTimer = Timer(Duration(milliseconds: widget.cooldownDuration), () {
      if (!mounted) return;
      setState(() => _isCooldown = false);
      if (!_isUserScrolling && !_isPaused) {
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cooldownTimer?.cancel();
    _scrollTimer?.cancel();
    _userScrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration:
            widget.showBackground
                ? BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                )
                : null,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: IgnorePointer(
            ignoring: _isCooldown,
            child: Opacity(
              opacity: _isCooldown ? 0.6 : 1.0,
              child: Row(
                children: List.generate(widget.words.length, (index) {
                  final isSelected = index == _selectedIndex;
                  final word = widget.words[index];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                        widget.onWordSelected(word);
                        _startCooldown();
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? widget.defaultColor.withAlpha(50)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              isSelected
                                  ? widget.defaultColor
                                  : Colors.transparent,
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            word,
                            style: TextStyle(
                              fontSize:
                                  isSelected
                                      ? widget.selectedFontSize
                                      : widget.defaultFontSize,
                              color:
                                  isSelected
                                      ? widget.defaultColor
                                      : widget.defaultColor,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              fontFamily: 'NotoNaskhArabic',
                            ),
                          ),
                          if (isSelected && _isCooldown)
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    widget.defaultColor,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
