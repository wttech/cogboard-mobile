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
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: FittedBox(
                        child: Image.asset(
                          'assets/images/cogboard_icon.png',
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 24, 0, 24),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            UrlSelect(
                              newlyAddedConnection: newlyAddedConnection,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            ),
                            if (settingsProvider.connections != null && settingsProvider.connections.length > 0)
                              FlatButton(
                                minWidth: 0,
                                // color: Theme.of(context).colorScheme.secondary,
                                onPressed: () => {
                                  Navigator.pushNamed(
                                    context,
                                    AddConnectionScreen.routeName,
                                  )
                                },
                                child: Padding(
                                  // padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                                  padding: const EdgeInsets.fromLTRB(1, 3, 1, 3),
                                  child: Text(
                                    '+',
                                    style: TextStyle(
                                      // color: Theme.of(context).colorScheme.onSecondary,
                                      color: Theme.of(context).colorScheme.secondary,
                                      fontSize: 40,
                                    ),
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                  borderRadius: new BorderRadius.circular(STANDARD_BORDER_RADIOUS),
                                ),
                              ),
                          ],
                        ),
                        Padding(
                          padding: settingsProvider.currentConnection != null
                              ? EdgeInsets.fromLTRB(0, 13, 0, 13)
                              : EdgeInsets.fromLTRB(0, 22, 0, 22),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 230,
                              height: 45,
                              child: FlatButton(
                                onPressed: settingsProvider.currentConnection != null
                                    ? () => Navigator.of(context).pushReplacementNamed(DashboardsScreen.routeName)
                                    : () => Navigator.pushNamed(
                                          context,
                                          AddConnectionScreen.routeName,
                                        ),
                                disabledColor: Colors.grey,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: settingsProvider.currentConnection != null
                                      ? Text(
                                          AppLocalizations.of(context).getTranslation('loginScreen.connect'),
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black,
                                          ),
                                        )
                                      : Text(
                                    AppLocalizations.of(context).getTranslation('loginScreen.add.new.connection'),
                                          style: TextStyle(
                                            fontSize: 15,
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
                                color: Theme.of(context).colorScheme.primary
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
