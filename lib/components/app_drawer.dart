import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import '../components/text_style.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppBar(
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, color: Colors.black,),
                  onPressed: () => Navigator.pushNamed(context, '/profile'),
                )
              ],
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
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
              backgroundColor: Color(0xFFFFFFFF),
              elevation: 0.5,
            ),
            // ButtonBar(
            //   alignment: MainAxisAlignment.start,
            //   children: <Widget>[
            //     FlatButton(
            //       color: Color(0xFF3D8B37),
            //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            //       child: Text("View Profile", style: TextStyle(color: Colors.white),),
            //       onPressed: () =>
            //           Navigator.pushNamed(context, '/profile'),
            //     ),
            //   ],
            // ),
            ListTile(
              leading: Icon(LineIcons.home),
              title: Text(
                'HOME',
              ),
              onTap: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
            ListTile(
              leading: Icon(LineIcons.bullhorn),
              title: Text(
                'ABOUT UPRIGHT_NG',
              ),
              onTap: () => Navigator.pushNamed(context, '/about'),
            ),
            ListTile(
              leading: Icon(LineIcons.user_secret),
              title: Text(
                'ANONYMOUS REPORTING',
              ),
              onTap: () => Navigator.pushNamed(context, '/home'),
            ),
            ListTile(
              leading: Icon(LineIcons.chrome),
              title: Text(
                'AFFILIATE REPORTING',
              ),
              onTap: () => Navigator.pushNamed(context, '/report'),
            ),
            ListTile(
              leading: Icon(LineIcons.bar_chart),
              title: Text(
                'TOP CONTRIBUTORS',
              ),
              onTap: () => Navigator.pushNamed(context, '/topconts'),
            ),
            ListTile(
              leading: Icon(LineIcons.gavel),
              title: Text(
                'TERMS AND CONDITIONS',
              ),
              onTap: () => Navigator.pushNamed(context, '/tncs'),
            ),
            ListTile(
              leading: Icon(LineIcons.comments),
              title: Text(
                'MAKE A SUGGESTION',
              ),
              onTap: () => Navigator.pushNamed(context, '/suggestions'),
            ),
            SizedBox(
              height: 20.0,
            ),
            ListTile(
              leading: Icon(LineIcons.sign_out),
              title: Text(
                'LOGOUT',
              ),
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          ],
        ),
      ),
    );
  }
}
