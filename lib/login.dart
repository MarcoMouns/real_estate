import 'package:flutter/material.dart';
import 'package:realestate/I10n/app_localizations.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text("${AppLocalizations.of(context).translate('skip')}"),
          )
        ],
      ),
    );
  }
}
