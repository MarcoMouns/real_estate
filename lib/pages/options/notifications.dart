import 'package:flutter/material.dart';
import 'package:realestate/I10n/app_localizations.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${"${AppLocalizations.of(context).translate('notifications')}"}"),
        centerTitle: true,
      ),
    );
  }
}
