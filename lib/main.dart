import 'package:flutter/material.dart';

import 'components/colors.dart';

import 'pages/splash.dart';
import 'pages/onboarding.dart';
import 'pages/profile.dart';
import 'pages/auth.dart';
import 'pages/feeds.dart';
import 'pages/about.dart';
import 'pages/report.dart';
import 'pages/tnc.dart';
import 'pages/suggestions.dart';
import 'pages/top_contributors.dart';
import 'pages/feed_detail.dart';

void main() => runApp(MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return MyAppState();
//   }
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upright_NG',
      theme: ThemeData(
          brightness: Brightness.light,
          accentColor: army,
          primarySwatch: white,
          fontFamily: 'OpenSans'),
      home: SplashWidget(),
      routes: {
        '/home': (BuildContext context) => HomePage(),
        '/tncs': (BuildContext context) => TnCPage(),
        '/login': (BuildContext context) => AuthPage(),
        '/about': (BuildContext context) => AboutPage(),
        '/report': (BuildContext context) => ReportPage(),
        '/welcome': (BuildContext context) => OnboardingPage(),
        '/suggestions': (BuildContext context) => SuggestionPage(),
        '/topconts': (BuildContext context) => TopcontributorsPage(),
        '/profile': (BuildContext context) => ProfilePage(),
      },
      onGenerateRoute: (RouteSettings settings) {
        final path = settings.name;
        if (path.startsWith('/post')) {
          final postId = path.split('/')[2];
          final postTitle = path.split('/')[3];
          return MaterialPageRoute(builder: (BuildContext context) {
            return FeedPage(
              title: postTitle,
              id: postId,
            );
          });
        } else {
          return MaterialPageRoute(
            builder: (BuildContext context) => HomePage(),
          );
        }
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (BuildContext context) => HomePage(),
        );
      },
    );
  }
}
