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
              color: Theme.of(context).colorScheme.background,
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
                      FlatButton(
                        onPressed: () => {
                          Navigator.of(context)
                              .pushReplacementNamed(DashboardsScreen.routeName)
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text('CONNECT'),
                        ),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      FlatButton(
                        color: Theme.of(context).colorScheme.secondary,
                        onPressed: () => {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddConnectionScreen(),
                            ),
                          )
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text('+'),
                        ),
                      ),
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
