import 'package:flutter/material.dart';
import 'package:realestate/I10n/app_localizations.dart';
import 'package:realestate/widgets/notification_card.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("${"${AppLocalizations.of(context).translate('notifications')}"}"),
        centerTitle: true,
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          return NotificationCard();
        },
      ),
    );
  }
}
