import 'package:flutter/material.dart';
import '../components/text_style.dart';
import '../components/app_drawer.dart';
import '../components/app_bar_default.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      backgroundColor: Colors.white,
      appBar: appBarDefault(title: 'ABOUT', context: context),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset(
              "assets/images/logo.jpg",
              height: 200,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0,  vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Motivation",
                    style: AppTextStyle.appHeader,
                  ),
                  SizedBox(height: 10.0,),
                  Text(
                    "There is a near universal concesus in Nigeria, among Nigerians and within the international community that corruption is endemic and all pervasive in the country. The scourge of corruption has assumed an existential threat to the country, becoming a major obstacle to human and natinal development.",
                    style: AppTextStyle.appText,
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 10.0,),
                  Text(
                    "Thus, the Strenghtening Citizen's Resistance Against Prevelance of Corruption (SCRAP-C) through its Upright for Nigeria; Stand against corruption campaign aims to influence social norms and attitudes that help corruption thrive in Nigeria with a view to effect social change. The campaign leveraging on social capital and social networks to promote a corruption averse mentality.",
                    style: AppTextStyle.appText,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0,  vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Goal",
                    style: AppTextStyle.appHeader,
                  ),
                  SizedBox(height: 10.0,),
                  Text(
                    "To contribute to a reduction in corruption as a result of changes in public attitudes that increasingly disapprove of corrupt activities.",
                    style: AppTextStyle.appText,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
