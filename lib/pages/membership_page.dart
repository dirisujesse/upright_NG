import 'package:Upright_NG/components/form_scaffold.dart';
import 'package:Upright_NG/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../services/storage_service.dart';

class MembershipPage extends StatelessWidget {
  final List<String> roles =
      "Refuse to participate in corrupt practices.Refuse to take bribes or receive gratification before carrying out services.Uphold values of Honesty, Integrity, Transparency and Hardwork.Speak out against corruption.Hold yourself and colleagues accountable.Engage in campaign activities to promote anti-corruption by encouraging other people.Identify and report corrupt practices.Always remember that corruption is not all about money."
          .split('.')
          .toList()
          .where((it) => it.isNotEmpty)
          .toList();

  void attachUser(BuildContext context) {
    LocalStorage.setItem("isPrevUser", true)
        .then(
          (val) => Navigator.pushReplacementNamed(context, "/home"),
        )
        .catchError(
          (val) => Navigator.pushReplacementNamed(context, "/home"),
        );
  }

  @override
  Widget build(BuildContext context) {
    return FormScaffold(
      bottomInset: 20,
      willPop: false,
      pageHyt: 0.25,
      navIcon: SizedBox(),
      content: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AutoSizeText(
                "Membership Roles",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: appGreen,
                  fontWeight: FontWeight.w900,
                  fontSize: 25,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              AutoSizeText(
                "Thank you for joining the Upright4Nigeria campaign against Corruption in all its forms – Economic, Moral, Political or any other form.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 25,
                  ),
                  itemCount: roles.length,
                  itemBuilder: (context, idx) {
                    return AutoSizeText(
                      roles[idx] + ".",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: appBlack.withOpacity(0.6),
                      ),
                    );
                  },
                  separatorBuilder: (context, idx) {
                    if (idx != roles.length - 1) {
                      return Container(
                        height: 1,
                        margin: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 20,
                        ),
                        color: appAsh,
                      );
                    } else {
                      return SizedBox(
                        height: 0,
                      );
                    }
                  },
                ),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.45,
                ),
                decoration: BoxDecoration(
                  color: formInputGreen,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                child: AutoSizeText("Feeds"),
                onPressed: () => attachUser(context),
                padding: EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              )
            ],
          ),
        ),
      ),
      bannerImage: "assets/images/man_pose.png",
    );
  }
}
