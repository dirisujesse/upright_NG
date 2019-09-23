import 'package:states_rebuilder/states_rebuilder.dart';
import './user.dart';

class NavigationBloc extends StatesRebuilder {
  static NavigationBloc instance;
  final usrData = UserBloc.getInstance();
  int activePage = 0;

  static NavigationBloc getInstance() {
    if (instance == null) {
      instance = NavigationBloc();
    }
    return instance;
  }

  void navToPage({int pageIndex = 0}) {
    activePage = pageIndex;
    // rebuildStates(ids: ["navState"]);
  }
}
