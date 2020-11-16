import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/board_model.dart';
import 'package:cogboardmobileapp/models/dashboard_tab_model.dart';
import 'package:cogboardmobileapp/providers/config_provider.dart';
import 'package:cogboardmobileapp/screens/widgets_list_screen.dart';
import 'package:cogboardmobileapp/widgets/screen_with_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

  bool isWidgetBoard(Board board) {
    return board.type == BoardTypes.WIDGET_BOARD;
  }

  String getIframeUrl(Board board) {
    return board.iframeUrl;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context, listen: false);
    configProvider.setCurrentBoard(configProvider.boards[pageNumber]);
    boardTitle = configProvider.boards[pageNumber].title;
    return ScreenWithAppBar(
      appBarTitle: boardTitle,
      body: PageView(
        controller: _controller,
        onPageChanged: (boardIndex) {
          configProvider.setCurrentBoard(configProvider.boards[pageNumber]);
          setState(() {
            pageNumber = boardIndex;
          });
        },
        children: configProvider.boards
            .map(
              (board) => isWidgetBoard(configProvider.boards[pageNumber])
                  ? WidgetsListScreen(
                      dashboardType: DashboardType.Home,
                      board: board,
                    )
                  : Container(
                      child: WebView(
                        initialUrl: Uri.dataFromString(
                                '<html><body><iframe src="${getIframeUrl(board)}" width="100%" height="100%"></iframe></body></html>',
                                mimeType: 'text/html')
                            .toString(),
                        javascriptMode: JavascriptMode.unrestricted,
                      ),
                    ),
            )
            .toList(),
      ),
    );
  }
}
