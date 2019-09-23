import 'package:Upright_NG/models/order.dart';
import 'package:flutter/material.dart';
import 'package:Upright_NG/styles/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';

class OrderFragment extends StatelessWidget {
  final Order product;
  final Function router;
  OrderFragment({this.product, this.router});

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      SizedBox();
    }
    return Container(
      margin: EdgeInsets.fromLTRB(25, 20, 25, 20),
      height: 300,
      constraints: BoxConstraints(maxHeight: 300),
      decoration: BoxDecoration(
        color: appWhite,
        boxShadow: [
          BoxShadow(
            color: appShadow,
            blurRadius: 3,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: <Widget>[
                Image.network(
                  product.product.image,
                  fit: BoxFit.fill,
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: appGreen,
                        width: 1.5,
                      ),
                    ),
                    constraints: BoxConstraints(
                      maxWidth: 20,
                      maxHeight: 20,
                    ),
                    height: 20,
                    width: 20,
                    alignment: Alignment.centerRight,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: appGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Table(
                  children: [
                    TableRow(
                      children: [
                        AutoSizeText(
                          "Upright4Nigeria " + product.product.name,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Table(
                  children: [
                    TableRow(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: appShadow,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            direction: Axis.vertical,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.star,
                                    color: appGreen,
                                    size: 15,
                                  ),
                                  AutoSizeText(
                                    " " + product.product.rating.toString(),
                                    style: TextStyle(
                                      color: appGreen,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                              AutoSizeText(
                                "100+ Ratings",
                                style: TextStyle(
                                  color: appBlack.withOpacity(0.7),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 10),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            direction: Axis.vertical,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.timer,
                                    color: appGreen,
                                    size: 15,
                                  ),
                                  AutoSizeText(
                                    " ${product.eDD} Days",
                                    style: TextStyle(
                                      color: appGreen,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                              AutoSizeText(
                                "Delivery Day",
                                style: TextStyle(
                                  color: appBlack.withOpacity(0.7),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: appShadow,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            direction: Axis.vertical,
                            children: <Widget>[
                              AutoSizeText(
                                "Points",
                                style: TextStyle(
                                  color: appGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              AutoSizeText(
                                product.product.points.toString(),
                                style: TextStyle(
                                  color: appBlack.withOpacity(0.7),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
