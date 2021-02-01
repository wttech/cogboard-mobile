import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/providers/filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Filters extends StatefulWidget {
  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> with TickerProviderStateMixin {
  bool isOpened = false;
  bool isWarningFilterChecked = false;
  bool isErrorFilterChecked = false;
  AnimationController _filterToggleAnimationController;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _filterToggleAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _filterToggleAnimationController,
      curve: Interval(
        0.0,
        1,
        curve: _curve,
      ),
    ));
  }

  @override
  dispose() {
    _filterToggleAnimationController.dispose();
    super.dispose();
  }

  Animation<Color> filterButtonColor(Color beginColor, Color endColor) {
    return ColorTween(
      begin: beginColor,
      end: endColor,
    ).animate(CurvedAnimation(
      parent: _filterToggleAnimationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
  }

  void animateFilterToggle() {
    if (!isOpened) {
      _filterToggleAnimationController.forward();
    } else {
      _filterToggleAnimationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget error(FilterProvider filterProvider, BuildContext context) {
    return Container(
      child: FloatingActionButton(
        heroTag: 'error',
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        backgroundColor: filterProvider.isErrorFilterPresent ? Theme.of(context).colorScheme.secondary : Colors.grey,
        child: Icon(
          Icons.error,
          size: FILTER_ICON_SIZE,
        ),
        onPressed: () => filterProvider.toggleErrorFilter(),
      ),
    );
  }

  Widget warning(FilterProvider filterProvider, BuildContext context) {
    return Container(
      child: FloatingActionButton(
        heroTag: 'warning',
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        backgroundColor: filterProvider.isWarningFilterPresent ? Theme.of(context).colorScheme.secondary : Colors.grey,
        child: Icon(
          Icons.warning,
          size: FILTER_ICON_SIZE,
        ),
        onPressed: () => filterProvider.toggleWarningFilter(),
      ),
    );
  }

  Widget filter(FilterProvider filterProvider) {
    if (filterProvider.shouldResetFilterView) {
      filterProvider.markRestarted();
      Future.delayed(const Duration(milliseconds: 0), () {
        setState(() {
          this.isOpened = false;
        });
      });
    }

    return Container(
      padding: EdgeInsets.only(right: 0),
      child: FloatingActionButton(
        heroTag: 'filter',
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: animateFilterToggle,
        child: Image.asset(
          'assets/images/filter_icon.png',
          width: 22,
          height: 22,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: Consumer<FilterProvider>(builder: (ctx, filterProvider, child) => error(filterProvider, context)),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: Consumer<FilterProvider>(builder: (ctx, filterProvider, child) => warning(filterProvider, context)),
        ),
        Consumer<FilterProvider>(builder: (ctx, filterProvider, child) => filter(filterProvider)),
      ],
    );
  }
}
