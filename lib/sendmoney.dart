import 'dart:convert';
import 'package:bankapp/home.dart';
import 'package:bankapp/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SendMoney extends StatefulWidget {
  final int balance;
  SendMoney(this.balance);
  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  final accountControl = TextEditingController();
  final amountControl = TextEditingController();
  SendMoneyLogic sendMoneyClass = SendMoneyLogic();
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
    final node = FocusScope.of(context);
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          return Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        },
        child: Scaffold(
          backgroundColor: UserColors.blackbackground,
          appBar: UserWidgets().userappbar(Icons.send),
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
                return success(context, snapshot.data);
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
      ),
    );
  }

  success(BuildContext context, int amount) {
    Size size = MediaQuery.of(context).size;
    double h40 = size.height * .05;
    double f24 = size.height * .03;
    double f16 = size.height * .02;
    double f32 = size.height * .04;
    double w200 = size.height * .25;
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          UserWidgets().accountDetails(amount),
          TextFormField(
              controller: accountControl,
              keyboardType: TextInputType.number,
              validator: (text) {
                if (text.isEmpty) {
                  return 'This field is empty';
                }
              },
              onSaved: (text) {
                sendMoneyClass.username = text;
              },
              decoration: UserWidgets().inputdecor('Account Number', f16)),
          Divider(),
          TextFormField(
              controller: amountControl,
              keyboardType: TextInputType.number,
              validator: (text) {
                if (text.isEmpty) {
                  return 'This field is empty';
                } else if (text.contains(',')) {
                  return 'Please remove the ,';
                } else if (text.contains('.')) {
                  return 'Please remove the .';
                }
              },
              onSaved: (text) {
                sendMoneyClass.amount = num.tryParse(text);
              },
              decoration: UserWidgets().inputdecor('Amount', f16)),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              button('Transfer', context, h40, w200, f24),
              VerticalDivider(),
              UserWidgets().welcomeText(
                  text: "Select Beneficiaries",
                  sizeFont: f16,
                  height: 2,
                  bold: false),
            ],
          )
        ],
      ),
    );
  }

  button(String text, BuildContext context, double containerH,
      double containerW, double sizefont) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0),
        child: Container(
          height: containerH,
          width: containerW,
          decoration: BoxDecoration(
            color: UserColors.yellowColor,
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFF3D657).withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 4,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: sizefont,
                fontWeight: FontWeight.bold,
                color: UserColors.blackbackground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
