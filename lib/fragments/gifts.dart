import 'package:Upright_NG/components/app_activity_indicator.dart';
import 'package:Upright_NG/models/order.dart';
import 'package:Upright_NG/stores/market.dart';
import 'package:Upright_NG/styles/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:intl/intl.dart';

final storeBloc = StoreBloc.getInstance();

class OrdersFragment extends StatefulWidget {
  final Function router;
  OrdersFragment({@required this.router}) : assert(router != null);
  @override
  State<StatefulWidget> createState() {
    return _OrdersFragmentState(router: router);
  }
}

class _OrdersFragmentState extends State<OrdersFragment> {
  final Function router;
  _OrdersFragmentState({@required this.router}) : assert(router != null);
  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      initState: (state) =>
          storeBloc.fetchGifts(state: state, context: context),
      stateID: "cartState",
      blocs: [storeBloc],
      builder: (_) {
        if (storeBloc.loadingGifts) {
          return Center(
            child: const AppSpinner(),
          );
        }
        if (storeBloc.noGifts) {
          return Container(
            alignment: Alignment.center,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AutoSizeText(
                    "Your order list is empty",
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    color: appGreen,
                    onPressed: () =>
                        storeBloc.fetchGifts(state: this, context: context),
                  )
                ],
              ),
            ),
          );
        }
        if (!storeBloc.loadingGifts && (storeBloc.gifts.length <= 0)) {
          return Container(
            alignment: Alignment.center,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AutoSizeText(
                    "Ooops, we couldn't fetch orders due to a network failure",
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    color: appGreen,
                    onPressed: () =>
                        storeBloc.fetchGifts(state: this, context: context),
                  )
                ],
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: storeBloc.gifts.length,
          itemBuilder: (context, idx) {
            final order = Order.fromJson(storeBloc.gifts[idx]);
            return Container(
              margin: EdgeInsets.fromLTRB(25, 20, 25, 20),
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              height: 300,
              constraints: BoxConstraints(maxHeight: 300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
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
                  Table(
                    children: [
                      TableRow(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: AutoSizeText(
                              "Gift #${order.id.substring(0, 7)}",
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: AutoSizeText(
                              DateFormat("EEE, M/d/y, HH:MM")
                                  .format(DateTime.parse(order.createdAt)),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 15,
                                color: appBlack.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 2,
                    color: appShadow,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: FadeInImage(
                            placeholder:
                                AssetImage("assets/images/Logomin.jpg"),
                            image: NetworkImage(order.product.image),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width * 0.4,
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.4),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  AutoSizeText(
                                    order.purchaser.name,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  AutoSizeText(
                                    order.pickupLocation,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: appBlack.withOpacity(0.6)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  AutoSizeText(
                                    "Coins Paid: ${order.product.points}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 2,
                    color: appShadow,
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
                                AutoSizeText(
                                  "Status",
                                  style: TextStyle(
                                    color: appBlack.withOpacity(0.7),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                AutoSizeText(
                                  order.hasBeenDelivered
                                      ? "DELIVERED"
                                      : "UNDELIVERED",
                                  style: TextStyle(
                                    color: appGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.end,
                              direction: Axis.vertical,
                              children: <Widget>[
                                AutoSizeText(
                                  "Delivery Date",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: appBlack.withOpacity(0.7),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                AutoSizeText(
                                  order.hasBeenDelivered
                                      ? DateFormat("EEE, M/d/y, HH:MM").format(
                                          DateTime.parse(order.deliveryDate))
                                      : "PENDING",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: appGreen,
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
            );
          },
        );
      },
    );
  }
}
