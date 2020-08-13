import 'package:cogboardmobileapp/screens/dashboards_screen.dart';
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Material(
                      color: Colors.blue,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed(DashboardsScreen.routeName);
                        },
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                          ),
                          child: Center(
                            child: Text(
                              "Submit",
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
