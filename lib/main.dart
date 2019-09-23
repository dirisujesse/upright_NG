import 'package:Upright_NG/models/post.dart';
import 'package:Upright_NG/pages/feeds.dart';
import 'package:Upright_NG/pages/membership_page.dart';
import 'package:Upright_NG/pages/pledge_page.dart';
import 'package:Upright_NG/pages/settings.dart';
import 'package:Upright_NG/pages/store_page.dart';
import 'package:Upright_NG/pages/testimonial_create_page.dart';
import 'package:Upright_NG/pages/testimonials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'styles/theme.dart';

import 'pages/splash.dart';
import 'pages/onboarding.dart';
import 'pages/profile.dart';
import 'pages/auth.dart';
import 'pages/about.dart';
import 'pages/report.dart';
import 'pages/tnc.dart';
import 'pages/suggestions.dart';
import 'pages/top_contributors.dart';
import 'pages/feed_detail.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upright_NG',
      theme: appThemeData(),
      home: const SplashWidget(),
      routes: {
        '/welcome': (BuildContext context) => OnboardingPage(),
        '/profile': (BuildContext context) => ProfilePage(),
        '/store': (BuildContext context) => StorePage(),
        '/settings': (BuildContext context) => SettingsPage(),
        '/gifts': (BuildContext context) => StorePage(initialRoute: "/store/orders", shouldPop: false,),
        '/pledge': (BuildContext context) => PledgePage(isMembership: true,),
        '/membership': (BuildContext context) => MembershipPage(),
        '/login': (BuildContext context) => AuthPage(),
        '/home': (BuildContext context) => FeedsPage(),
        '/tncs': (BuildContext context) => const TnCPage(),
        // '/testimonials': (BuildContext context) => TestimonialPage(),
        '/testimonials/create': (BuildContext context) => TestimonialCreationPage(),
        '/about': (BuildContext context) => const AboutPage(),
        '/report': (BuildContext context) => const ReportPage(),
        '/suggestions': (BuildContext context) => SuggestionPage(),
        '/topconts': (BuildContext context) => TopcontributorsPage(),
        '/post/add/anon': (BuildContext context) => FeedsPage(activePage: 1, isAnon: true),
        '/post/add/notanon': (BuildContext context) => FeedsPage(activePage: 1,),
      },
      onGenerateRoute: (RouteSettings settings) {
        final path = settings.name;
        if (path.startsWith('/post')) {
          // final pathArr = path.split('/');
          final Post post = Post.fromJson(settings.arguments);
          return MaterialPageRoute(builder: (BuildContext context) {
            return FeedPage(
              title: post.title,
              id: post.id,
              post: post,
            );
          });
        } else if (path == '/testimonials') {
          final List<dynamic> posts = settings.arguments;
          return MaterialPageRoute(builder: (BuildContext context) {
            return TestimonialPage(posts: posts,);
          });
        } else {
          return MaterialPageRoute(
            builder: (BuildContext context) => FeedsPage(),
          );
        }
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (BuildContext context) => FeedsPage(),
        );
      },
    );
  }
}
