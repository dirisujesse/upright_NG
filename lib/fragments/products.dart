import 'package:Upright_NG/components/app_activity_indicator.dart';
import 'package:Upright_NG/fragments/order.dart';
import 'package:Upright_NG/models/product.dart';
import 'package:Upright_NG/stores/market.dart';
import 'package:Upright_NG/styles/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:auto_size_text/auto_size_text.dart';

final storeBloc = StoreBloc.getInstance();

class ProductsFragment extends StatefulWidget {
  final Function router;
  final Function navToTop;

  ProductsFragment({@required this.router, @required this.navToTop})
      : assert(router != null),
        assert(navToTop != null);

  @override
  State<StatefulWidget> createState() {
    return _ProductsState(router: router, navToTop: navToTop);
  }
}

class _ProductsState extends State<ProductsFragment> {
  final Function router;
  final Function navToTop;

  _ProductsState({@required this.router, @required this.navToTop})
      : assert(router != null),
        assert(navToTop != null);

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      initState: (state) =>
          storeBloc.fetchProducts(state: state, context: context),
      blocs: [storeBloc],
      stateID: "storeState",
      builder: (_) {
        final products = storeBloc.products;
        if (storeBloc.loading && products.length == 0) {
          return Center(
            child: const AppSpinner(),
          );
        }
        if (!storeBloc.loading && products.length == 0) {
          return Container(
            alignment: Alignment.center,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AutoSizeText(
                    "Ooops, we couldn't fetch products due to a network failure",
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    color: appGreen,
                    onPressed: () =>
                        storeBloc.fetchProducts(state: this, context: context),
                  )
                ],
              ),
            ),
          );
        }
        return Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      StateBuilder(
                        blocs: [storeBloc],
                        stateID: "orderState",
                        builder: (_) {
                          final product = storeBloc.selectedProduct;
                          if (product == null) {
                            return SizedBox();
                          }
                          return OrderFragment(
                            product: product,
                            router: router,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(25, 20, 25, 100),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      crossAxisSpacing: 15,
                      maxCrossAxisExtent: 300,
                      mainAxisSpacing: 15,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, idx) {
                        final product = Product.fromJson(products[idx]);
                        return GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
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
                                  child: FadeInImage(
                                    placeholder:
                                        AssetImage("assets/images/Logomin.jpg"),
                                    image: NetworkImage(product.image),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                                  child: Table(
                                    columnWidths: {
                                      0: FlexColumnWidth(2),
                                      1: FlexColumnWidth(1)
                                    },
                                    children: [
                                      TableRow(
                                        children: [
                                          AutoSizeText(
                                            product.name,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              padding: EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: appGreen,
                                                  width: 1.5,
                                                ),
                                              ),
                                              constraints: BoxConstraints(
                                                maxWidth: 15,
                                                maxHeight: 15,
                                              ),
                                              height: 15,
                                              width: 15,
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
                                      TableRow(
                                        children: [
                                          AutoSizeText(
                                            "Points",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: appBlack.withOpacity(0.7),
                                              fontSize: 11,
                                            ),
                                          ),
                                          AutoSizeText(
                                            product.points.toString(),
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            storeBloc.selectProduct(productIndex: idx);
                            navToTop();
                          },
                        );
                      },
                      childCount: storeBloc.products.length,
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: StateBuilder(
                blocs: [storeBloc],
                stateID: "orderState",
                builder: (_) {
                  final product = storeBloc.selectedProduct;
                  if (product == null) {
                    return SizedBox();
                  }
                  if (storeBloc.activeUser.activeUser.points <
                      product.product.points) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 50,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      child: AutoSizeText(
                        "You do not have enough points to purchase this product",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: appWhite,
                        ),
                      ),
                      color: appGreen,
                    );
                  }
                  return Container(
                    color: appGreen,
                    child: ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            height: 60,
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: AutoSizeText(
                              "PICKUP ADDRESS",
                              style: TextStyle(
                                color: appWhite,
                              ),
                            ),
                            color: appGreen,
                          ),
                          onTap: () {
                            router("/store/pickup");
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            height: 60,
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: AutoSizeText(
                              "REDEEM",
                              style: TextStyle(
                                color: appWhite,
                              ),
                            ),
                            color: appAsh,
                          ),
                          onTap: () {
                            storeBloc.makeOrder();
                            router("/store/redeem");
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }
}
