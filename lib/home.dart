import 'dart:convert';
import 'package:bankapp/login.dart';
import 'package:bankapp/sendmoney.dart';
import 'package:bankapp/transaction.dart';
import 'package:bankapp/Deposit.dart';
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
  int balance = 0;
  String accountN = '';
  @override
  void initState() {
    super.initState();
    setPrefs();
    getAccount = getaccount();
  }

  setPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accountN = prefs.getString('account') ?? '';
  }

  getaccount() async {
    List accountData;
    var decode;
    Uri link = Uri.parse('$baseUrl/accounts/list');
    try {
      var request = await http.get(link);
      if (request.statusCode == 200) {
        print('account number =====> $accountN');
        decode = jsonDecode(request.body);
        accountData = decode['data'];
        for (var data in accountData) {
          if (data['phoneNumber'] == accountN ) {
            balance = data['balance'];
            print('account balance =====> $balance');
          }
        }
         return true;
      } else {
        return false;
      }
    } catch (e) {
      print('error =====> $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double f18 = size.height * .0225;
    return SafeArea(
        child: WillPopScope(
      onWillPop: ()async  {
         Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
            return true;
      },
      child: Scaffold(
        backgroundColor: UserColors.blackbackground,
        appBar: userWidgets.userappbar(Icons.home, f18, 'Home'),
        body: FutureBuilder(
          future: getAccount,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
           
              return UserWidgets().loadingIndicator();
            } else if (snapshot.data == true) {
              return success(accountBalance: balance, context: context);
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

  success({required int accountBalance,required  BuildContext context}) {
    Size size = MediaQuery.of(context).size;
   
    double f8 = size.height * .01;
    double f30 = size.height * .0375;
    double f70 = size.height * .08761;
    return Column(
      children: [
        userWidgets.accountDetails(accountBalance, context),
        Divider(),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(f8),
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
                                 Navigator.pushReplacement(
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
                                  f70,
                                  f30,
                                ),
                              ),
                            )),
                        VerticalDivider(),
                        Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                 Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Deposit()));
                              },
                              child: Container(
                                height: double.infinity,
                                width: double.infinity,
                                decoration: decorContainer(),
                                child: columnContainer(
                                  'Deposit',
                                  Icons.arrow_circle_down,
                                  f70,
                                  f30,
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
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                             Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WithDraw()));
                          },
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: decorContainer(),
                            child: columnContainer(
                                'Withdraw', Icons.atm, f70, f30),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                             Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Transaction()));
                          },
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: decorContainer(),
                            child: columnContainer(
                                'Transactions', Icons.history, f70, f30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  heartBeatAnimation({required Widget widget}) {
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
