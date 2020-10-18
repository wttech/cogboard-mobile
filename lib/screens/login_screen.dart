import 'package:cogboardmobileapp/screens/add_connection_screen.dart';
import 'package:cogboardmobileapp/screens/dashboards_screen.dart';
import 'package:cogboardmobileapp/widgets/url_select_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    // TODO #1, #24, #2, #23
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: new Container(
              color: Colors.white,
              width: double.infinity,
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: Theme.of(context).primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [UrlSelect()],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                        color: Colors.blue,
                        child: InkWell(
                          onTap: () => {
                            Navigator.of(context).pushReplacementNamed(
                                DashboardsScreen.routeName)
                          },
                          child: Container(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: Text(
                                  "Connect",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Material(
                        color: Colors.green,
                        child: InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddConnectionScreen(),
                            ),
                          ),
                          child: Container(
                            child: Center(
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  child: Text(
                                    "+",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w300),
                                  )),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
