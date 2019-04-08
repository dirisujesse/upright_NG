import 'package:flutter/material.dart';
import '../components/app_drawer.dart';
import '../components/app_bar_default.dart';
import 'webview.dart';

class ReportPage extends StatelessWidget {
  void launchWebPage(context, String url, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => WebPage(
              url: url,
              title: title,
            ),
      ),
    );
  }

  List<Widget> grids(context) {
    return <Widget>[
      GestureDetector(
        onTap: () => launchWebPage(
              context,
              "http://whistle.finance.gov.ng/Pages/default.aspx",
              "Min. Fin. Whistleblowing Portal",
            ),
        child: Container(
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: Colors.grey),
              bottom: BorderSide(color: Colors.grey),
            ),
            color: Colors.white,
          ),
          child: Image.asset("assets/images/firslogo.png", fit: BoxFit.contain),
        ),
      ),
      GestureDetector(
        onTap: () => launchWebPage(
              context,
              "https://leaks.ng",
              "LEAKS.NG",
            ),
        child: Container(
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            border: Border(
              // left: BorderSide(color: Colors.grey),
              bottom: BorderSide(color: Colors.grey),
            ),
            color: Colors.white,
          ),
          child:
              Image.asset("assets/images/leaksnglogo.png", fit: BoxFit.contain),
        ),
      ),
      GestureDetector(
        onTap: () => launchWebPage(
              context,
              "http://reportyourself.org",
              "REPORT YOURSELF NIGERIA",
            ),
        child: Container(
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: Colors.grey),
              // top: BorderSide(color: Colors.grey),
              bottom: BorderSide(color: Colors.grey),
            ),
            color: Colors.white,
          ),
          child:
              Image.asset("assets/images/repselflogo.png", fit: BoxFit.contain),
        ),
      ),
      GestureDetector(
        onTap: () => launchWebPage(
              context,
              "http://voiceagainstcorruption.org",
              "Voice Against Corruption",
            ),
        child: Container(
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            border: Border(
              // left: BorderSide(color: Colors.grey),
              // top: BorderSide(color: Colors.grey),
              bottom: BorderSide(color: Colors.grey),
            ),
            color: Colors.white,
          ),
          child: Image.asset("assets/images/voicesagainstcorruption_logo.png",
              fit: BoxFit.contain),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var items = grids(context);
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: AppDrawer(),
      appBar: appBarDefault(title: 'Affiliate Reporting', context: context),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          GridView.builder(
            padding: EdgeInsets.all(0),
            itemCount: items.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) => items[index],
          ),
        ],
      ),
    );
  }
}
