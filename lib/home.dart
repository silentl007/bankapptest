import 'dart:convert';
import 'package:bankapp/login.dart';
import 'package:bankapp/sendmoney.dart';
import 'package:bankapp/transaction.dart';
import 'package:bankapp/withdraw.dart';
import 'package:flutter/material.dart';
import 'package:bankapp/model.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final UserWidgets userWidgets = UserWidgets();
  var getAccount;
  int balance;
  String accountN;
  SharedPreferences prefs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setPrefs();
    getAccount = getaccount();
  }

  setPrefs() async {
    prefs = await SharedPreferences.getInstance();
    accountN = prefs.getString('account');
  }

  getaccount() async {
    List accountData;
    var decode;
    Uri link = Uri.parse('https://bank.veegil.com/accounts/list');
    try {
      var request = await http.get(link);
      if (request.statusCode == 200) {
        print('account number =====> $accountN');
        decode = jsonDecode(request.body);
        accountData = decode['data'];
        for (var data in accountData) {
          if (data['phoneNumber'] == accountN) {
            balance = data['balance'];
            print('account balance =====> $balance');
          }
        }
        return balance;
      }
    } catch (e) {
      print('error =====> $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      },
      child: Scaffold(
        backgroundColor: UserColors.blackbackground,
        appBar: userWidgets.userappbar(Icons.home),
        body: FutureBuilder(
          future: getAccount,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: UserColors.yellowColor,
                ),
              );
            } else if (snapshot.hasData) {
              return success(accountBalance: snapshot.data);
            } else {
              return Center(
                child: ElevatedButton(
                  child: Text('Retry'),
                  onPressed: () {
                    setState(() {
                      getAccount = getaccount();
                    });
                  },
                ),
              );
            }
          },
        ),
      ),
    ));
  }

  success({int accountBalance}) {
    return Column(
      children: [
        userWidgets.accountDetails(accountBalance),
        Divider(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                return Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SendMoney(accountBalance)));
                              },
                              child: Container(
                                height: double.infinity,
                                width: double.infinity,
                                decoration: decorContainer(),
                                child: columnContainer(
                                  'Send Money',
                                  Icons.send,
                                  70,
                                  30,
                                ),
                              ),
                            )),
                        VerticalDivider(),
                        Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                return Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Withdraw()));
                              },
                              child: Container(
                                height: double.infinity,
                                width: double.infinity,
                                decoration: decorContainer(),
                                child: columnContainer(
                                  'Withdraw',
                                  Icons.transfer_within_a_station,
                                  70,
                                  30,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                Divider(),
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () {
                      return Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Transaction()));
                    },
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: decorContainer(),
                      child: columnContainer(
                          'Transaction History', Icons.history, 80, 35),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  heartBeatAnimation({Widget widget}) {
    return Pulse(
      preferences: AnimationPreferences(autoPlay: AnimationPlayStates.Loop),
      child: widget,
    );
  }

  columnContainer(
      String text, IconData icon, double iconSize, double textSize) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          heartBeatAnimation(
            widget: Icon(
              icon,
              color: UserColors.yellowColor,
              size: iconSize,
            ),
          ),
          Text(
            text,
            style: TextStyle(
                color: UserColors.yellowColor,
                fontSize: textSize,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  decorContainer() {
    return BoxDecoration(
        border: Border.all(
            // color: UserColors.yellowColor,
            ),
        borderRadius: BorderRadius.all(Radius.circular(30)));
  }
}
