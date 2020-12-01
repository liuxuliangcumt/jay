import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:data_plugin/bmob/response/bmob_registered.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jay/common/constants.dart';
import 'package:jay/pages/musiclist/MusicList.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlashPage extends StatefulWidget {
  @override
  _FlashPageState createState() => _FlashPageState();
}

class _FlashPageState extends State<FlashPage> {
  bool isLogin = true;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> _userName;
  Timer _timer;
  String i_userName = "", i_password = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        height: 280,
        padding: EdgeInsets.only(top: 10, right: 20, left: 20),
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Color(0x80ffffff), borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: <Widget>[
            TextField(
              maxLength: 11,
              keyboardType: TextInputType.phone,
              onChanged: (text) {
                setState(() {
                  i_userName = text;
                });
              },
              decoration: InputDecoration(
                  fillColor: Colors.red,
                  labelText: "请输入手机号",
                  icon: Icon(Icons.account_circle)),
            ),
            TextField(
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              onChanged: (text) {
                setState(() {
                  i_password = text;
                });
              },
              decoration: InputDecoration(
                  fillColor: Colors.red,
                  labelText: "请输入密码",
                  icon: Icon(Icons.account_balance)),
            ),
            Container(
              width: 400,
              margin: EdgeInsets.only(top: 20),
              child: CupertinoButton(
                onPressed: () {
                  login();
                },
                color: Colors.blue,
                child: Text(
                  isLogin ? "登录" : "注册",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
           /* Container(
              child: FlatButton(
                child: Text(
                  isLogin ? "注册" : "登录",
                ),
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
              ),
              alignment: Alignment.topLeft,
            )*/
          ],
        ),
      ),
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1588489400051&di=86a10674ecb668af7d8560ab3820deb6&imgtype=0&src=http%3A%2F%2Fimg1.imgtn.bdimg.com%2Fit%2Fu%3D132687831%2C3067309699%26fm%3D214%26gp%3D0.jpg"))),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    const oneSec = const Duration(seconds: 5);
    var callback = (timer) {
      print("倒计时结束$_userName");
      _incrementCounter();
      _timer.cancel();
    };
    _timer = Timer.periodic(oneSec, callback);
  }

  Future<void> _incrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    final String userName = prefs.getString(Constants.userName);
    if (userName == null) {
      showLogin();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MusicList()),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  void showLogin() {}

  void login() async {
    if (i_password.isEmpty || i_userName.length != 11) {
      BotToast.showText(text: "请输入11位手机号和密码");
      return;
    }
    print("登录前 $i_password  username $i_userName");
    BmobUser bmobUser = BmobUser();
    bmobUser.username = i_userName;
    bmobUser.password = i_password;
    if (isLogin) {
      try {
        BmobUser bmobUserlogin = await bmobUser.login();
        print(bmobUserlogin.username);
        BotToast.showText(text: "登录成功");
        final SharedPreferences prefs = await _prefs;
        prefs.setString(Constants.userName, bmobUserlogin.username);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MusicList()),
        );
      } catch (e) {
        print("登录失败  ${e.toString()}");
        BotToast.showText(text: "登录失败");
      }
    } else {
      try {
        BmobRegistered bmobUserlogin = await bmobUser.register();
        BotToast.showText(text: "注册成功,请登录");
        setState(() {
          isLogin = true;
        });
      } catch (e) {
        print("注册失败  ${e.toString()}");

        BotToast.showText(text: "注册失败");
      }
    }
  }
}
