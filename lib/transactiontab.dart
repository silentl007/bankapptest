import 'package:flutter/material.dart';
import 'package:bankapp/model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransactionTabs extends StatefulWidget {
  final String transType;
  TransactionTabs({this.transType});
  @override
  _TransactionTabsState createState() => _TransactionTabsState();
}

class _TransactionTabsState extends State<TransactionTabs> {
  var gettrans;
  List transData = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettrans = getTrans();
  }

  getTrans() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: gettrans,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            // return Center(
            //   child: CircularProgressIndicator(
            //     backgroundColor: UserColors.yellowColor,
            //   ),
            // );
            return UserWidgets().loadingIndicator();
          } else if (snapshot.hasData) {
            return success(context: context, data: snapshot.data);
          } else {
            return Center(
              child: ElevatedButton(
                child: Text('Retry'),
                onPressed: () {
                  setState(() {
                    gettrans = getTrans();
                  });
                },
              ),
            );
          }
        },
      ),
    );
  }

  success({BuildContext context, List data}) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) => Card(
        child: ListTile(),
      ),
    );
  }
}

class TransModel {
  String transtype;
  int amount;
  String accountNumber;
  String date;
  TransModel({this.accountNumber, this.amount, this.date, this.transtype});
}
