import 'package:cogboardmobileapp/models/dashboard_tab_model.dart';
import 'package:cogboardmobileapp/providers/config_provider.dart';
import 'package:cogboardmobileapp/screens/widgets_list_screen.dart';
import 'package:cogboardmobileapp/widgets/screen_with_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeWidgetScreen extends StatefulWidget {
  @override
  _HomeWidgetScreenState createState() => _HomeWidgetScreenState();
}

class _HomeWidgetScreenState extends State<HomeWidgetScreen> {
  PageController _controller = PageController(
    initialPage: 0,
  );
  String boardTitle;
  int pageNumber = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context, listen: false);
    boardTitle = configProvider.boards[pageNumber].title;
    return ScreenWithAppBar(
      appBarTitle: boardTitle,
      body: PageView(
        controller: _controller,
        onPageChanged: (boardIndex) {
          setState(() {
            pageNumber = boardIndex;
          });
        },
        children: configProvider.boards
            .map(
              (board) => WidgetsListScreen(
                dashboardType: DashboardType.Home,
                board: board,
              ),
            )
            .toList(),
      ),
    );
  }
}
