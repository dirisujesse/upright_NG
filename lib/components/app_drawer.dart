import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import '../components/text_style.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppBar(
              leading: Padding(
                padding: EdgeInsets.all(2.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/user.png'),
                ),
              ),
              automaticallyImplyLeading: false,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    'Dirisu Jesse',
                    style: AppTextStyle.appHeader,
                  ),
                  Text(
                    'dirisujesse@gmail.com',
                    style: AppTextStyle.appText,
                  ),
                ],
              ),
              backgroundColor: Color(0xFFFFFFFF),
              elevation: 0.5,
            ),
            ListTile(
              leading: Icon(LineIcons.home),
              title: Text(
                'HOME',
                style: AppTextStyle.appText,
              ),
              onTap: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
            ListTile(
              leading: Icon(LineIcons.bullhorn),
              title: Text(
                'ABOUT UPRIGHT_NG',
                style: AppTextStyle.appText,
              ),
              onTap: () => Navigator.pushNamed(context, '/about'),
            ),
            ListTile(
              leading: Icon(LineIcons.user_secret),
              title: Text(
                'ANONYMOUS REPORTING',
                style: AppTextStyle.appText,
              ),
              onTap: () => Navigator.pushNamed(context, '/home'),
            ),
            ListTile(
              leading: Icon(LineIcons.chrome),
              title: Text(
                'AFFILIATE REPORTING',
                style: AppTextStyle.appText,
              ),
              onTap: () => Navigator.pushNamed(context, '/report'),
            ),
            ListTile(
              leading: Icon(LineIcons.bar_chart),
              title: Text(
                'TOP CONTRIBUTORS',
                style: AppTextStyle.appText,
              ),
              onTap: () => Navigator.pushNamed(context, '/topconts'),
            ),
            ListTile(
              leading: Icon(LineIcons.gavel),
              title: Text(
                'TERMS AND CONDITIONS',
                style: AppTextStyle.appText,
              ),
              onTap: () => Navigator.pushNamed(context, '/tncs'),
            ),
            ListTile(
              leading: Icon(LineIcons.comments),
              title: Text(
                'MAKE A SUGGESTION',
                style: AppTextStyle.appText,
              ),
              onTap: () => Navigator.pushNamed(context, '/suggestions'),
            ),
            SizedBox(
              height: 20.0,
            ),
            ListTile(
              leading: Icon(LineIcons.sign_out),
              title: Text(
                'Logout',
                style: AppTextStyle.appText,
              ),
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          ],
        ),
      ),
    );
  }
}
