import 'package:Upright_NG/components/page_scaffold.dart';
import 'package:Upright_NG/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class TnCPage extends StatelessWidget {
  const TnCPage();
  List<Widget> itemList(context) {
    return <Widget>[
      // Image.asset(
      //   "assets/images/logo.jpg",
      //   height: 200,
      //   fit: BoxFit.cover,
      //   width: MediaQuery.of(context).size.width,
      // ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AutoSizeText("Terms and conditions",
              style: Theme.of(context)
                  .textTheme
                  .body2
                  .copyWith(color: appGreen, fontSize: 18)),
          SizedBox(
            height: 10.0,
          ),
          AutoSizeText(
            """These terms and conditions ("Terms", "Agreement") are an agreement between ("Upright4Nigeria", "us", "we" or "our") and you ("User", "you" or "your"). This Agreement sets forth the general terms and conditions of your use of the Upright4Nigeria mobile application and any of its products or services (collectively, "Mobile Application" or "Services")""",
            style: Theme.of(context)
                .textTheme
                .body1
                .copyWith(color: appBlack.withOpacity(0.6), fontSize: 20),
            textAlign: TextAlign.start,
          ),
        ],
      ),
      SizedBox(
        height: 40.0,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AutoSizeText("Accounts and membership",
              style: Theme.of(context)
                  .textTheme
                  .body2
                  .copyWith(color: appGreen, fontSize: 18)),
          SizedBox(
            height: 10.0,
          ),
          AutoSizeText(
            """You must be at least 18 years of age to use this Mobile Application. By using this Mobile Application and by agreeing to this Agreement you warrant and represent that you are at least 18 years of age. If you create an account in the Mobile Application, you are responsible for maintaining the security of your account and you are fully responsible for all activities that occur under the account and any other actions taken in connection with it. We may monitor and review new accounts before you may sign in and use our Services. Providing false contact information of any kind may result in the termination of your account. You must immediately notify us of any unauthorized uses of your account or any other breaches of security. We will not be liable for any acts or omissions by you, including any damages of any kind incurred as a result of such acts or omissions. We may suspend, disable, or delete your account (or any part thereof) if we determine that you have violated any provision of this Agreement or that your conduct or content would tend to damage our reputation and goodwill. If we delete your account for the foregoing reasons, you may not re-register for our Services. We may block your email address and Internet protocol address to prevent further registration.User contentWe do not own any data, information or material ("Content") that you submit in the Mobile Application in the course of using the Service. You shall have sole responsibility for the accuracy, quality, integrity, legality, reliability, appropriateness, and intellectual property ownership or right to use of all submitted Content. We may monitor and review Content in the Mobile Application submitted or created using our Services by""",
            style: Theme.of(context)
                .textTheme
                .body1
                .copyWith(color: appBlack.withOpacity(0.6), fontSize: 20),
            textAlign: TextAlign.start,
          ),
        ],
      ),
      // SizedBox(
      //   height: 14.0,
      // ),
      // Padding(
      //   padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: <Widget>[
      //       AutoSizeText("CHANGES TO TERMS AND CONDITIONS",
      //           style: Theme.of(context)
      //               .textTheme
      //               .body2
      //               .copyWith(color: appGreen, fontSize: 20)),
      //       SizedBox(
      //         height: 10.0,
      //       ),
      //       AutoSizeText(
      //         "We may update our Terms and Conditions from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Terms and Conditions on this page. These changes are effective immediately after they are posted on this page.",
      //         style: Theme.of(context)
      //             .textTheme
      //             .body1
      //             .copyWith(color: appBlack.withOpacity(0.6), fontSize: 20),
      //         textAlign: TextAlign.justify,
      //       ),
      //     ],
      //   ),
      // ),
      // SizedBox(
      //   height: 14.0,
      // ),
      // Padding(
      //   padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: <Widget>[
      //       AutoSizeText("CONTACT US",
      //           style: Theme.of(context)
      //               .textTheme
      //               .body2
      //               .copyWith(color: appGreen, fontSize: 20)),
      //       SizedBox(
      //         height: 10.0,
      //       ),
      //       AutoSizeText(
      //         "If you have any questions or suggestions about our Terms and Conditions, do not hesitate to contact us.",
      //         style: Theme.of(context)
      //             .textTheme
      //             .body1
      //             .copyWith(color: appBlack.withOpacity(0.6), fontSize: 20),
      //         textAlign: TextAlign.justify,
      //       ),
      //     ],
      //   ),
      // ),
      // SizedBox(
      //   height: 14.0,
      // ),
      // Padding(
      //   padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: <Widget>[
      //       AutoSizeText("PRIVACY POLICY",
      //           style: Theme.of(context)
      //               .textTheme
      //               .body2
      //               .copyWith(color: appGreen, fontSize: 20)),
      //       SizedBox(
      //         height: 10.0,
      //       ),
      //       AutoSizeText(
      //         "We built the Upright for Nigeria app as a Free app. This SERVICE is provided by at no cost and is intended for use as is. This page is used to inform website visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service. If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy. The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at Upright for Nigeria unless otherwise defined in this Privacy Policy.",
      //         style: Theme.of(context)
      //             .textTheme
      //             .body1
      //             .copyWith(color: appBlack.withOpacity(0.6), fontSize: 20),
      //         textAlign: TextAlign.justify,
      //       ),
      //     ],
      //   ),
      // ),
      // SizedBox(
      //   height: 14.0,
      // ),
      // Padding(
      //   padding:
      //       EdgeInsets.only(top: 10.0, left: 40.0, bottom: 10.0, right: 30.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: <Widget>[
      //       AutoSizeText("Information Collection and Use",
      //           style: Theme.of(context)
      //               .textTheme
      //               .body2
      //               .copyWith(color: appGreen, fontSize: 20)),
      //       SizedBox(
      //         height: 10.0,
      //       ),
      //       AutoSizeText(
      //         "For a better experience, while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to Name, email. The information that we request is will be retained by us and used as described in this privacy policy. The app does use third party services that may collect information used to identify you. Link to privacy policy of third party service providers used by the app.",
      //         style: Theme.of(context)
      //             .textTheme
      //             .body1
      //             .copyWith(color: appBlack.withOpacity(0.6), fontSize: 20),
      //         textAlign: TextAlign.justify,
      //       ),
      //     ],
      //   ),
      // ),
      // SizedBox(
      //   height: 14.0,
      // ),
      // Padding(
      //   padding:
      //       EdgeInsets.only(top: 10.0, left: 40.0, bottom: 10.0, right: 30.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: <Widget>[
      //       AutoSizeText("Log Data",
      //           style: Theme.of(context)
      //               .textTheme
      //               .body2
      //               .copyWith(color: appGreen, fontSize: 20)),
      //       SizedBox(
      //         height: 10.0,
      //       ),
      //       AutoSizeText(
      //         "We want to inform you that whenever you use our Service, in a case of an error in the app we collect data and information (through third party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing our Service, the time and date of your use of the Service, and other statistics.",
      //         style: Theme.of(context)
      //             .textTheme
      //             .body1
      //             .copyWith(color: appBlack.withOpacity(0.6), fontSize: 20),
      //         textAlign: TextAlign.justify,
      //       ),
      //     ],
      //   ),
      // ),
      // SizedBox(
      //   height: 14.0,
      // ),
      // Padding(
      //   padding:
      //       EdgeInsets.only(top: 10.0, left: 40.0, bottom: 10.0, right: 30.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: <Widget>[
      //       AutoSizeText("Cookies",
      //           style: Theme.of(context)
      //               .textTheme
      //               .body2
      //               .copyWith(color: appGreen, fontSize: 20)),
      //       SizedBox(
      //         height: 10.0,
      //       ),
      //       AutoSizeText(
      //         "Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory. This Service does not use these “cookies” explicitly. However, the app may use third party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.",
      //         style: Theme.of(context)
      //             .textTheme
      //             .body1
      //             .copyWith(color: appBlack.withOpacity(0.6), fontSize: 20),
      //         textAlign: TextAlign.justify,
      //       ),
      //     ],
      //   ),
      // ),
      // SizedBox(
      //   height: 14.0,
      // ),
      // Padding(
      //   padding:
      //       EdgeInsets.only(top: 10.0, left: 40.0, bottom: 10.0, right: 30.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: <Widget>[
      //       AutoSizeText("Service Providers",
      //           style: Theme.of(context)
      //               .textTheme
      //               .body2
      //               .copyWith(color: appGreen, fontSize: 20)),
      //       SizedBox(
      //         height: 10.0,
      //       ),
      //       AutoSizeText(
      //         "We may employ third-party companies and individuals due to the following reasons:",
      //         style: Theme.of(context)
      //             .textTheme
      //             .body1
      //             .copyWith(color: appBlack.withOpacity(0.6), fontSize: 20),
      //         textAlign: TextAlign.justify,
      //       ),
      //       SizedBox(
      //         height: 10.0,
      //       ),
      //       Padding(
      //         padding: EdgeInsets.only(left: 8.0),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: <Widget>[
      //             AutoSizeText(
      //               "• To facilitate our Service;",
      //               style: Theme.of(context).textTheme.body1.copyWith(
      //                   color: appBlack.withOpacity(0.6), fontSize: 20),
      //               textAlign: TextAlign.justify,
      //             ),
      //             SizedBox(
      //               height: 5.0,
      //             ),
      //             AutoSizeText(
      //               "• To provide the Service on our behalf;",
      //               style: Theme.of(context).textTheme.body1.copyWith(
      //                   color: appBlack.withOpacity(0.6), fontSize: 20),
      //               textAlign: TextAlign.justify,
      //             ),
      //             SizedBox(
      //               height: 5.0,
      //             ),
      //             AutoSizeText(
      //               "• To perform Service-related services; or",
      //               style: Theme.of(context).textTheme.body1.copyWith(
      //                   color: appBlack.withOpacity(0.6), fontSize: 20),
      //               textAlign: TextAlign.justify,
      //             ),
      //             SizedBox(
      //               height: 5.0,
      //             ),
      //             AutoSizeText(
      //               "• To assist us in analyzing how our Service is used.",
      //               style: Theme.of(context).textTheme.body1.copyWith(
      //                   color: appBlack.withOpacity(0.6), fontSize: 20),
      //               textAlign: TextAlign.justify,
      //             ),
      //           ],
      //         ),
      //       ),
      //       SizedBox(
      //         height: 10.0,
      //       ),
      //       AutoSizeText(
      //         "We want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.",
      //         style: Theme.of(context)
      //             .textTheme
      //             .body1
      //             .copyWith(color: appBlack.withOpacity(0.6), fontSize: 20),
      //         textAlign: TextAlign.justify,
      //       ),
      //     ],
      //   ),
      // ),
      // SizedBox(
      //   height: 14.0,
      // ),
      // Padding(
      //   padding:
      //       EdgeInsets.only(top: 10.0, left: 40.0, bottom: 10.0, right: 30.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: <Widget>[
      //       AutoSizeText("Security",
      //           style: Theme.of(context)
      //               .textTheme
      //               .body2
      //               .copyWith(color: appGreen, fontSize: 20)),
      //       SizedBox(
      //         height: 10.0,
      //       ),
      //       AutoSizeText(
      //         "We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.",
      //         style: Theme.of(context)
      //             .textTheme
      //             .body1
      //             .copyWith(color: appBlack.withOpacity(0.6), fontSize: 20),
      //         textAlign: TextAlign.justify,
      //       ),
      //     ],
      //   ),
      // ),
      // SizedBox(
      //   height: 14.0,
      // ),
      // Padding(
      //   padding:
      //       EdgeInsets.only(top: 10.0, left: 40.0, bottom: 10.0, right: 30.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: <Widget>[
      //       AutoSizeText("Links to Other Sites",
      //           style: Theme.of(context)
      //               .textTheme
      //               .body2
      //               .copyWith(color: appGreen, fontSize: 20)),
      //       SizedBox(
      //         height: 10.0,
      //       ),
      //       AutoSizeText(
      //         "This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by us. Therefore, we strongly advise you to review the Privacy Policy of these websites. We have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.",
      //         style: Theme.of(context)
      //             .textTheme
      //             .body1
      //             .copyWith(color: appBlack.withOpacity(0.6), fontSize: 20),
      //         textAlign: TextAlign.justify,
      //       ),
      //     ],
      //   ),
      // ),
      // SizedBox(
      //   height: 14.0,
      // ),
      // Padding(
      //   padding:
      //       EdgeInsets.only(top: 10.0, left: 40.0, bottom: 10.0, right: 30.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: <Widget>[
      //       AutoSizeText("Childrens Privacy",
      //           style: Theme.of(context)
      //               .textTheme
      //               .body2
      //               .copyWith(color: appGreen, fontSize: 20)),
      //       SizedBox(
      //         height: 10.0,
      //       ),
      //       AutoSizeText(
      //         "These Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do necessary actions.",
      //         style: Theme.of(context)
      //             .textTheme
      //             .body1
      //             .copyWith(color: appBlack.withOpacity(0.6), fontSize: 20),
      //         textAlign: TextAlign.justify,
      //       ),
      //     ],
      //   ),
      // ),
      // SizedBox(
      //   height: 14.0,
      // ),
      // Padding(
      //   padding:
      //       EdgeInsets.only(top: 10.0, left: 40.0, bottom: 10.0, right: 30.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: <Widget>[
      //       AutoSizeText("Changes to Privacy Policy",
      //           style: Theme.of(context)
      //               .textTheme
      //               .body2
      //               .copyWith(color: appGreen, fontSize: 20)),
      //       SizedBox(
      //         height: 10.0,
      //       ),
      //       AutoSizeText(
      //         "We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page. These changes are effective immediately after they are posted on this page.",
      //         style: Theme.of(context)
      //             .textTheme
      //             .body1
      //             .copyWith(color: appBlack.withOpacity(0.6), fontSize: 20),
      //         textAlign: TextAlign.justify,
      //       ),
      //     ],
      //   ),
      // ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final items = itemList(context);
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      "Terms & Conditions",
                      style: Theme.of(context).textTheme.title.copyWith(
                            color: appGreen,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AutoSizeText(
                      "By using this mobile app, you agree to these terms and conditions; if you do not agree, do not use this app.",
                      style: TextStyle(
                          color: appGreen, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return items[index];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
