import 'package:cogboardmobileapp/providers/filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Filters extends StatefulWidget {
  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> with TickerProviderStateMixin  {

  bool isOpened = false;
  bool isWarningFilterChecked = false;
  bool isErrorFilterChecked = false;
  AnimationController _filterToggleAnimationController;
  Animation<Color> _inactiveFilterButtonColor;
  Animation<Color> _activeFilterButtonColor;
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
    _inactiveFilterButtonColor = filterButtonColor(Theme.of(context).primaryColor, Colors.red);
    _activeFilterButtonColor = filterButtonColor(Colors.blue, Colors.red);
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _filterToggleAnimationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
  }

  @override
  dispose() {
    _filterToggleAnimationController.dispose();
    super.dispose();
  }

  Animation<Color> filterButtonColor(MaterialColor beginColor, MaterialColor endColor) {
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

  Widget error(FilterProvider filterProvider) {
    return Container(
      padding: const EdgeInsets.only(right: 25.0),
      child: FloatingActionButton(
        heroTag: 'error',
        foregroundColor: Colors.white,
        backgroundColor: filterProvider.isErrorFilterPresent ? Colors.blue: Colors.blueGrey[800],
        child: Icon(
          Icons.error,
          size: 25,
        ),
        onPressed: () => filterProvider.toggleErrorFilter(),
      ),
    );
  }

  Widget warning(FilterProvider filterProvider) {
    return Container(
      padding: const EdgeInsets.only(right: 25.0),
      child: FloatingActionButton(
        heroTag: 'warning',
        foregroundColor: Colors.white,
        backgroundColor:  filterProvider.isWarningFilterPresent ? Colors.blue : Colors.blueGrey[800],
        child: Icon(
          Icons.warning,
          size: 25,
        ),
        onPressed: () => filterProvider.toggleWarningFilter(),
      ),
    );
  }

  Widget filter(FilterProvider filterProvider) {
    return Container(
      padding: const EdgeInsets.only(right: 25.0),
      child: FloatingActionButton(
        heroTag: 'filter',
        backgroundColor: filterProvider.isAnyFilterPresent ? _activeFilterButtonColor.value: _inactiveFilterButtonColor.value,
        onPressed: animateFilterToggle,
        child: !this.isOpened
            ? Image.asset(
                'assets/images/filter_icon.png',
                width: 25,
                height: 25,
              )
            : Image.asset(
                'assets/images/cancel_icon.png',
                width: 25,
                height: 25,
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
          child: Consumer<FilterProvider>(
            builder: (ctx, filterProvider, child) =>  error(filterProvider)
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: Consumer<FilterProvider>(
              builder: (ctx, filterProvider, child) =>  warning(filterProvider)
          ),
        ),
        Consumer<FilterProvider>(
            builder: (ctx, filterProvider, child) =>  filter(filterProvider)
        ),
      ],
    );
  }
}
