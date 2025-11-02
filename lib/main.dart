import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const double kOuterPadding = 16.0;
const double kSectionSpacing = 16.0;
const double kCardPadding = 16.0;
const double kButtonSpacing = 8.0;
const int kMaxDigits = 9;
const double kPhoneChangeCardMaxWidth = 320.0;
const double kTabletChangeCardMaxWidth = 440.0;
const double kPhoneKeypadMaxWidth = 340.0;
const double kTabletKeypadMaxWidth = 480.0;

void main() {
  runApp(const VangtiChaiApp());
}

class VangtiChaiApp extends StatelessWidget {
  const VangtiChaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VangtiChai',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF006E7F)),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      home: const VangtiChaiHome(),
    );
  }
}

class VangtiChaiHome extends StatefulWidget {
  const VangtiChaiHome({super.key});

  @override
  State<VangtiChaiHome> createState() => _VangtiChaiHomeState();
}

class _VangtiChaiHomeState extends State<VangtiChaiHome> {
  static const List<int> _denominations = [500, 100, 50, 20, 10, 5, 2, 1];
  final NumberFormat _formatter = NumberFormat.decimalPattern();
  int _amount = 0;

  String get _formattedAmount =>
      _formatter.format(_amount).replaceAll(',', ' ');

  List<_NoteBreakdown> get _noteBreakdown {
    var remaining = _amount;
    return _denominations.map((value) {
      final count = remaining ~/ value;
      remaining -= count * value;
      return _NoteBreakdown(value: value, count: count);
    }).toList(growable: false);
  }

  void _appendDigit(int digit) {
    if (_amount == 0 && digit == 0) {
      return;
    }
    final currentLength = _amount == 0 ? 0 : _amount.toString().length;
    if (currentLength >= kMaxDigits) {
      return;
    }
    setState(() {
      _amount = _amount * 10 + digit;
    });
  }

  void _clearAmount() {
    setState(() {
      _amount = 0;
    });
  }

  void _backspace() {
    if (_amount == 0) {
      return;
    }
    setState(() {
      _amount = _amount ~/ 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 600;
            final orientation = MediaQuery.of(context).orientation;

            return Padding(
              padding: const EdgeInsets.all(kOuterPadding),
              child: orientation == Orientation.portrait
                  ? _buildPortraitLayout(isTablet)
                  : _buildLandscapeLayout(isTablet),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AmountDisplay(amount: _formattedAmount),
        const SizedBox(height: kSectionSpacing),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: isTablet ? 4 : 3,
                fit: FlexFit.loose,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isTablet
                          ? kTabletChangeCardMaxWidth
                          : kPhoneChangeCardMaxWidth,
                    ),
                    child: _ChangeSummary(
                      amount: _amount,
                      breakdown: _noteBreakdown,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: kSectionSpacing),
              Expanded(
                flex: isTablet ? 6 : 5,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isTablet
                          ? kTabletKeypadMaxWidth
                          : kPhoneKeypadMaxWidth,
                    ),
                    child: _NumericKeypad(
                      onDigitPressed: _appendDigit,
                      onClearPressed: _clearAmount,
                      onBackspacePressed: _backspace,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(bool isTablet) {
    return Row(
      children: [
        Expanded(
          flex: isTablet ? 4 : 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AmountDisplay(
                amount: _formattedAmount,
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: kSectionSpacing),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final maxCardWidth = isTablet
                        ? kTabletChangeCardMaxWidth
                        : kPhoneChangeCardMaxWidth;
                    final availableWidth = constraints.maxWidth.isFinite
                        ? constraints.maxWidth
                        : maxCardWidth;
                    final cardWidth = availableWidth < maxCardWidth
                        ? availableWidth
                        : maxCardWidth;
                    final maxHeight = constraints.maxHeight;
                    return Align(
                      alignment: Alignment.topLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: cardWidth,
                        ),
                        child: SizedBox(
                          height: maxHeight.isFinite ? maxHeight : null,
                          child: SingleChildScrollView(
                            padding: EdgeInsets.zero,
                            child: _ChangeSummary(
                              amount: _amount,
                              breakdown: _noteBreakdown,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: kSectionSpacing),
        Expanded(
          flex: isTablet ? 6 : 5,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth:
                    isTablet ? kTabletKeypadMaxWidth : kPhoneKeypadMaxWidth,
              ),
              child: _NumericKeypad(
                onDigitPressed: _appendDigit,
                onClearPressed: _clearAmount,
                onBackspacePressed: _backspace,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AmountDisplay extends StatelessWidget {
  const _AmountDisplay({
    required this.amount,
    this.alignment = Alignment.center,
  });

  final String amount;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: kSectionSpacing,
        horizontal: kCardPadding,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Align(
        alignment: alignment,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Taka:',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: kSectionSpacing),
              Text(
                amount,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontSize: 36,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChangeSummary extends StatelessWidget {
  const _ChangeSummary({
    required this.amount,
    required this.breakdown,
  });

  final int amount;
  final List<_NoteBreakdown> breakdown;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      surfaceTintColor: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(kCardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Change',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: kButtonSpacing),
            for (var i = 0; i < breakdown.length; i++) ...[
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: breakdown[i].count > 0 ? 1.0 : 0.4,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Tk ${breakdown[i].value}',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'x ${breakdown[i].count}',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (i != breakdown.length - 1)
                const Divider(
                  height: 16,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NumericKeypad extends StatelessWidget {
  const _NumericKeypad({
    required this.onDigitPressed,
    required this.onClearPressed,
    required this.onBackspacePressed,
  });

  final ValueChanged<int> onDigitPressed;
  final VoidCallback onClearPressed;
  final VoidCallback onBackspacePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.headlineSmall;
    final orientation = MediaQuery.of(context).orientation;

    Widget digitButton(int digit) => _KeypadButton(
          label: '$digit',
          onPressed: () => onDigitPressed(digit),
          textStyle: textStyle,
        );

    List<int> digitOrder = orientation == Orientation.portrait
        ? const [7, 8, 9, 4, 5, 6, 1, 2, 3]
        : const [1, 2, 3, 4, 5, 6, 7, 8, 9];

    final clearButton = _KeypadButton(
      label: 'Clear',
      onPressed: onClearPressed,
      textStyle: textStyle?.copyWith(
        fontSize: textStyle.fontSize != null ? textStyle.fontSize! - 4 : null,
      ),
      isTonal: true,
    );
    final zeroButton = _KeypadButton(
      label: '0',
      onPressed: () => onDigitPressed(0),
      textStyle: textStyle,
    );
    final backButton = _KeypadButton(
      label: 'Back',
      onPressed: onBackspacePressed,
      textStyle: textStyle,
      isOutlined: true,
    );

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      surfaceTintColor: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(kCardPadding),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth =
                constraints.maxWidth.isFinite ? constraints.maxWidth : 0.0;
            final availableHeight =
                constraints.maxHeight.isFinite ? constraints.maxHeight : 0.0;

            final cellWidth = (availableWidth - (kButtonSpacing * 2)) / 3;
            final cellHeight = (availableHeight - (kButtonSpacing * 3)) / 4;
            final rawAspectRatio =
                cellWidth > 0 && cellHeight > 0 ? cellWidth / cellHeight : 1.0;
            final childAspectRatio =
                rawAspectRatio.isFinite && rawAspectRatio > 0
                    ? math.max(rawAspectRatio, 0.8)
                    : 1.0;

            return GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: kButtonSpacing,
              crossAxisSpacing: kButtonSpacing,
              childAspectRatio: childAspectRatio,
              children: [
                for (final digit in digitOrder) digitButton(digit),
                clearButton,
                zeroButton,
                backButton,
              ],
            );
          },
        ),
      ),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  const _KeypadButton({
    required this.label,
    required this.onPressed,
    this.textStyle,
    this.isTonal = false,
    this.isOutlined = false,
  });

  final String label;
  final VoidCallback onPressed;
  final TextStyle? textStyle;
  final bool isTonal;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    final buttonChild = FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(label, style: textStyle),
    );

    final ButtonStyle style = switch ((isTonal, isOutlined)) {
      (_, true) => OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(kButtonSpacing),
          minimumSize: const Size(0, 0),
        ),
      _ => FilledButton.styleFrom(
          padding: const EdgeInsets.all(kButtonSpacing),
          minimumSize: const Size(0, 0),
        ),
    };

    final Widget button = switch ((isTonal, isOutlined)) {
      (true, _) => FilledButton.tonal(
          onPressed: onPressed,
          style: style,
          child: buttonChild,
        ),
      (_, true) => OutlinedButton(
          onPressed: onPressed,
          style: style,
          child: buttonChild,
        ),
      _ => FilledButton(
          onPressed: onPressed,
          style: style,
          child: buttonChild,
        ),
    };

    return SizedBox.expand(
      child: button,
    );
  }
}

class _NoteBreakdown {
  const _NoteBreakdown({required this.value, required this.count});

  final int value;
  final int count;
}
