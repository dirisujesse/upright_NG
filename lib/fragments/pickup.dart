import 'package:Upright_NG/stores/market.dart';
import 'package:flutter/material.dart';
import 'package:Upright_NG/styles/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';

final storeBloc = StoreBloc.getInstance();

class PickupFragment extends StatefulWidget {
  final Function router;
  PickupFragment({@required this.router}) : assert(router != null);
  @override
  State<StatefulWidget> createState() {
    return _PickupFragmentState(router: router);
  }
}

class _PickupFragmentState extends State<PickupFragment> {
  TextEditingController state;
  TextEditingController address;
  final List<String> states = [
    "Abuja",
    "Lagos",
    "Kaduna",
    "Kano",
    "Enugu",
    "Jigawa",
  ];
  final List<String> addresses = [
    "CCSI 16b, P.O.W Mafemi Crescent,Utako, Abuja, Mobile: 09022210504",
    "CCSI Mafemi Crescent,Ogba, Lagos, Mobile: 09022210504",
  ];
  final Function router;

  _PickupFragmentState({@required this.router}) : assert(router != null);

  @override
  void initState() {
    super.initState();
    storeBloc.pickupAddress();
    state = TextEditingController(text: storeBloc.pickupData["state"]);
    address = TextEditingController(text: storeBloc.pickupData["address"]);
  }

  void showModal(BuildContext context, bool isState) {
    final list = isState ? states : addresses;
    showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          backgroundColor: Color(0x00),
          body: Center(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: appWhite,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.6,
                  alignment: Alignment.center,
                  child: ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (context, idx) {
                      if (idx != list.length - 1) {
                        return Container(
                          height: isState ? 1 : 0,
                          color: appGreen,
                        );
                      }
                      return SizedBox(
                        height: isState ? 0 : 20,
                      );
                    },
                    itemBuilder: (context, idx) {
                      if (isState) {
                        return FlatButton(
                          padding: EdgeInsets.all(10),
                          child: AutoSizeText(
                            list[idx],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: appBlack,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            state.value = TextEditingValue(text: list[idx]);
                          },
                        );
                      } else {
                        return ValueListenableBuilder(
                          valueListenable: address,
                          builder: (context, val, child) {
                            return RadioListTile<TextEditingValue>(
                              groupValue: address.value,
                              activeColor: appGreen,
                              value: TextEditingValue(text: list[idx]),
                              title: AutoSizeText(
                                list[idx],
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: appBlack,
                                ),
                              ),
                              onChanged: (value) {
                                address.value =
                                    TextEditingValue(text: list[idx]);
                              },
                              selected: val == list[idx],
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 20,
                  child: GestureDetector(
                    child: Container(
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: appGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          color: appWhite,
                        ),
                      ),
                    ),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(25, 30, 25, 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AutoSizeText(
                  "State",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: appBlack,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    showModal(context, true);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    decoration: BoxDecoration(
                      color: formInputGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: ValueListenableBuilder(
                            valueListenable: state,
                            builder: (context, val, child) {
                              return AutoSizeText(val.text);
                            },
                          ),
                        ),
                        RotatedBox(
                          quarterTurns: 1,
                          child: Icon(
                            Icons.chevron_right,
                            color: appGreen,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                AutoSizeText(
                  "Address",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: appBlack,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    showModal(context, !true);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    decoration: BoxDecoration(
                      color: formInputGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: ValueListenableBuilder(
                            valueListenable: address,
                            builder: (context, val, child) {
                              return AutoSizeText(val.text);
                            },
                          ),
                        ),
                        RotatedBox(
                          quarterTurns: 1,
                          child: Icon(
                            Icons.chevron_right,
                            color: appGreen,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              child: Container(
                height: 60,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: AutoSizeText(
                  "SELECT PICKUP ADDRESS",
                  style: TextStyle(
                    color: appWhite,
                  ),
                ),
                color: appGreen,
              ),
              onTap: () {
                storeBloc.setAddress(address.text, state.text);
                storeBloc.selectedProduct.pickupLocation = address.text;
                router("", isPop: true);
              },
            ),
          )
        ],
      ),
    );
  }
}
