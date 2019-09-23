import 'package:Upright_NG/models/order.dart';
import 'package:Upright_NG/models/product.dart';
import 'package:Upright_NG/services/http_service.dart';
import 'package:Upright_NG/services/storage_service.dart';
import 'package:Upright_NG/stores/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class StoreBloc extends StatesRebuilder {
  static StoreBloc instance;
  List<dynamic> products = [];
  List<dynamic> gifts = [];
  Order selectedProduct;
  bool loading = false;
  bool loadingGifts = false;
  bool noGifts = false;
  bool makingOrder = false;
  UserBloc activeUser = UserBloc.getInstance();
  Map<String, dynamic> pickupData = {"state": "Abuja", "address": "CCSI 16b, P.O.W Mafemi Crescent,Utako, Abuja, Mobile: 09022210504"};

  setAddress(String address, String state) async {
    await LocalStorage.setItem("pickupAddress", {"address": address, "state": state});
  }

  void pickupAddress() async {
    var address = await LocalStorage.getItem("pickupAddress");
    address = !(address is bool) ? address as Map<String, dynamic> : pickupData;
    pickupData = address;
  }

  static StoreBloc getInstance() {
    if (instance == null) {
      instance = StoreBloc();
    }
    return instance;
  }

  dynamic getFromCache({@required String key}) async {
    return await LocalStorage.getItem("products");
  }

  void makeOrder() async {
    makingOrder = true;
    rebuildStates(ids: ["orderState"]);
    HttpService.makeOrder(selectedProduct).then((val) {
      if (val is int) {
        makingOrder = false;
        rebuildStates(ids: ["orderState"]);
      } else {
        selectedProduct = null;
        makingOrder = false;
        rebuildStates(ids: ["orderState"]);
      }
    }, onError: (err) {
      makingOrder = false;
      rebuildStates(ids: ["orderState"]);
    });
  }

  void setProducts({bool cache = true, State state, List<dynamic> val, bool isFreshFetch}) async {
    if (cache) {
      var data = await getFromCache(key: "products");
      data = !(data is bool) ? data : [];
      products =
          data == [] ? data : [];
    } else {
      products = val;
    }
    loading = isFreshFetch;
    selectedProduct = null;
    rebuildStates(states: [state], ids: ["storeState"]);
  }

  void selectProduct({@required int productIndex, bool multi = false}) {
    final product = Product.fromJson(products[productIndex]);
    selectedProduct = Order(
      eDD: 5,
      product: product,
      purchaser: activeUser.activeUser,
    );
    rebuildStates(ids: ["orderState", "storeState"]);
  }

  void setGifts({bool cache = true, State state, List<dynamic> val, bool isFreshFetch}) async {
    noGifts = false;
    rebuildStates(states: [state], ids: ["cartState"]);
    if (cache) {
      var data = await getFromCache(key: "gifts");
      data = !(data is bool) ? data : [];
      gifts =
          data == [] ? data : [];
    } else {
      gifts = val;
      noGifts = val.length <= 0;
    }
    loadingGifts = isFreshFetch;
    selectedProduct = null;
    rebuildStates(states: [state], ids: ["cartState"]);
  }

  void fetchProducts({
    @required State state,
    @required BuildContext context,
  }) async {
    setProducts(cache: true, state: state, isFreshFetch: true);
    HttpService.getProducts().then(
      (val) async {
        if (val is int) {
          setProducts(cache: true, state: state, isFreshFetch: false);
        } else {
          setProducts(cache: false, state: state, isFreshFetch: false, val: val);
        }
      },
      onError: (err) async {
        setProducts(cache: true, state: state, isFreshFetch: false);
      },
    );
  }

  void fetchGifts({
    @required State state,
    @required BuildContext context,
  }) async {
    setGifts(cache: true, state: state, isFreshFetch: true);
    HttpService.getGifts(activeUser.activeUser.id).then(
      (val) async {
        if (val is int) {
          setGifts(cache: true, state: state, isFreshFetch: false);
        } else {
          setGifts(cache: false, state: state, isFreshFetch: false, val: val);
        }
      },
      onError: (err) async {
        setGifts(cache: true, state: state, isFreshFetch: false);
      },
    );
  }
}
