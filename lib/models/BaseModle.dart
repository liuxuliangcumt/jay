import 'package:flutter/cupertino.dart';

class BaseModel extends ChangeNotifier {



  void refresh(){
    notifyListeners();
  }
}
