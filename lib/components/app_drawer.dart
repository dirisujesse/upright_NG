import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'text_style.dart';
import '../stores/user.dart';

final usrBloc = UserBloc();

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
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/profile'),
                )
              ],
              leading: Padding(
                padding: EdgeInsets.all(2.0),
                child: StateBuilder(
                  stateID: "authState",
                  blocs: [usrBloc],
                  builder: (_) => CircleAvatar(
                        backgroundImage:
                            NetworkImage(usrBloc.activeUser.avatar),
                      ),
                ),
              ),
              automaticallyImplyLeading: false,
              title: StateBuilder(
                stateID: "authState",
                blocs: [usrBloc],
                builder: (_) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          usrBloc.activeUser.name,
                          style: AppTextStyle.appHeader,
                        ),
                        Text(
                          usrBloc.activeUser.username,
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
              ),
              backgroundColor: Color(0xFFFFFFFF),
              elevation: 0.5,
            ),
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
            StateBuilder(
              stateID: "authState",
              blocs: [usrBloc],
              builder: (_) => ListTile(
                    leading: Icon(
                      usrBloc.isLoggedIn ? LineIcons.sign_out : LineIcons.sign_in,
                    ),
                    title: Text(
                      usrBloc.isLoggedIn ? 'LOGOUT' : 'LOGIN',
                    ),
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
