import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:cogboardmobileapp/screens/add_connection_screen.dart';
import 'package:cogboardmobileapp/screens/dashboards_screen.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:cogboardmobileapp/widgets/url_select_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    String newlyAddedConnection = ModalRoute.of(context).settings.arguments;
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      body: FutureBuilder(
        future: settingsProvider.fetchSettingsPreferences(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return Column(
              children: [
                Expanded(
                  flex: 3,
                  child: new Container(
                    color: Colors.white,
                    width: double.infinity,
                    child: FittedBox(
                      child: Image.asset(
                        'assets/images/cogboard_icon.png',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            UrlSelect(
                              newlyAddedConnection: newlyAddedConnection,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              onPressed: settingsProvider.currentConnection != null
                                  ? () => Navigator.of(context).pushReplacementNamed(DashboardsScreen.routeName)
                                  : null,
                              disabledColor: Colors.grey,
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  AppLocalizations.of(context).getTranslation('loginScreen.connect'),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.black12,
                                ),
                                borderRadius: new BorderRadius.circular(STANDARD_BORDER_RADIOUS),
                              ),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            FlatButton(
                              color: Theme.of(context).colorScheme.secondary,
                              onPressed: () => {
                                Navigator.pushNamed(
                                  context,
                                  AddConnectionScreen.routeName,
                                )
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  '+',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSecondary,
                                  ),
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.black12,
                                ),
                                borderRadius: new BorderRadius.circular(STANDARD_BORDER_RADIOUS),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
