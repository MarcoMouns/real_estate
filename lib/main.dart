import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:realestate/pages/options/notifications.dart';

import 'I10n/AppLanguage.dart';
import 'I10n/app_localizations.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(MyApp(appLanguage: appLanguage));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final AppLanguage appLanguage;
  MyApp({this.appLanguage});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => appLanguage,
      child: Consumer<AppLanguage>(builder: (context, model, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate
          ],
          supportedLocales: [
            Locale("en", "US"),
            Locale("ar", ""),
          ],
          locale: model.appLocal,
          title: 'نفذ',
          theme: ThemeData(
            primaryColor: Colors.white,
            textTheme: Theme.of(context).textTheme.apply(
                  fontFamily: 'coconext',
                  fontSizeFactor: 1.3,
                  bodyColor: Color(0xFF555555),
                  displayColor: Color(0xFF555555),
                  decorationColor: Color(0xFF555555),
                ),
          ),
          home: Notifications(),
        );
      }),
    );
  }
}
