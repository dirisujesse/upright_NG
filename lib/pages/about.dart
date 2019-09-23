import 'package:Upright_NG/components/page_scaffold.dart';
import 'package:Upright_NG/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AboutPage extends StatelessWidget {
  const AboutPage();
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      color: Color(0xFFF9F9F9),
      activeRoute: 4,
      appBar: AppBar(
        backgroundColor: appWhite,
        leading: BackButton(
          color: appBlack,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.of(context).pushNamed("/settings"),
          )
        ],
        elevation: 0,
      ),
      child: Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: appWhite,
                boxShadow: [
                  BoxShadow(
                    color: appShadow,
                    blurRadius: 10,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Text(
                  "About Upright_NG",
                  style: Theme.of(context).textTheme.title.copyWith(
                        color: appGreen,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // Image.asset(
                    //   "assets/images/logo.jpg",
                    //   height: 200,
                    //   fit: BoxFit.cover,
                    //   width: MediaQuery.of(context).size.width,
                    // ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: MediaQuery.of(context).size.width * 0.085,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AutoSizeText(
                            "Motivation",
                            style: Theme.of(context)
                                .textTheme
                                .body2
                                .copyWith(color: appGreen, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          AutoSizeText(
                            "There is a near universal concensus in Nigeria, among Nigerians and within the international community that corruption is endemic and all pervasive in the country. The scourge of corruption has assumed an existential threat to the country, becoming a major obstacle to human and natinal development.",
                            style: Theme.of(context).textTheme.body1.copyWith(
                                color: appBlack.withOpacity(0.6), fontSize: 20),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          AutoSizeText(
                            "Thus, the Strenghtening Citizen's Resistance Against Prevelance of Corruption (SCRAP-C) through its Upright for Nigeria; Stand against corruption campaign aims to influence social norms and attitudes that help corruption thrive in Nigeria with a view to effect social change. The campaign leveraging on social capital and social networks to promote a corruption averse mentality.",
                            style: Theme.of(context).textTheme.body1.copyWith(
                                color: appBlack.withOpacity(0.6), fontSize: 20),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: MediaQuery.of(context).size.width * 0.085,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AutoSizeText(
                            "Goal",
                            style: Theme.of(context)
                                .textTheme
                                .body2
                                .copyWith(color: appGreen, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          AutoSizeText(
                            "To contribute to a reduction in corruption as a result of changes in public attitudes that increasingly disapprove of corrupt activities.",
                            style: Theme.of(context).textTheme.body1.copyWith(
                                color: appBlack.withOpacity(0.6), fontSize: 20),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
