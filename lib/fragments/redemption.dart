import 'package:Upright_NG/components/app_activity_indicator.dart';
import 'package:Upright_NG/models/product.dart';
import 'package:Upright_NG/stores/market.dart';
import 'package:Upright_NG/styles/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:auto_size_text/auto_size_text.dart';

final storeBloc = StoreBloc.getInstance();

class RedemptionFragment extends StatelessWidget {
  final ValueNotifier<Product> selectionState = ValueNotifier(null);
  final Function router;

  RedemptionFragment({@required this.router}) : assert(router != null);

  // void showSheet(context, [bool isNull = false]) {
  //   Timer(
  //     Duration(seconds: 1),
  //     () {
  //       Scaffold.of(context).showBottomSheet(
  //         (context) {
  //           return isNull
  //               ? SizedBox(
  //                   height: 0,
  //                 )
  //               : GestureDetector(
  //                   child: Container(
  //                     height: 60,
  //                     alignment: Alignment.center,
  //                     width: MediaQuery.of(context).size.width,
  //                     child: AutoSizeText(
  //                       "BACK TO PROFILE",
  //                       style: TextStyle(
  //                         color: appWhite,
  //                       ),
  //                     ),
  //                     color: appGreen,
  //                   ),
  //                   onTap: () {
  //                     Navigator.of(context).pop();
  //                     router("/store/products");
  //                   },
  //                 );
  //         },
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // showSheet(context);
    return StateBuilder(
      blocs: [storeBloc],
      stateID: "orderState",
      builder: (_) {
        final product = storeBloc.selectedProduct;
        if (product == null && !storeBloc.makingOrder) {
          return Container(
            padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Image.asset("assets/images/done_icon.png"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AutoSizeText(
                    "Congratulations. Your Request has been accepted!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: appBlack,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AutoSizeText(
                    "Your Gift has been sent.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: appBlack.withOpacity(0.7),
                      fontSize: 17,
                    ),
                  ),
                  FlatButton(
                    child: AutoSizeText(
                      "Your Gifts",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: appBlack,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onPressed: () {
                      // showSheet(context, true);
                      router('/store/orders');
                    },
                  )
                ],
              ),
            ),
          );
        } else if (product != null && !storeBloc.makingOrder) {
          return Container(
            alignment: Alignment.center,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AutoSizeText(
                    "Ooops, we couldn't place your order due to a network failure",
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    color: appGreen,
                    onPressed: () =>
                        storeBloc.makeOrder(),
                  )
                ],
              ),
            ),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const AppSpinner(),
                  AutoSizeText(
                    "Please wait as we place your order",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
