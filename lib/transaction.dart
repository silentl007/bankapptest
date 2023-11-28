import 'package:bankapp/home.dart';
import 'package:bankapp/model.dart';
import 'package:bankapp/transactiontab.dart';
import 'package:flutter/material.dart';

class Transaction extends StatelessWidget {
  final List transType = ['Credit', 'All', 'Debit'];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double f18 = size.height * .0225;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
          return true;
        },
        child: DefaultTabController(
          length: transType.length,
          initialIndex: 1,
          child: Scaffold(
            backgroundColor: UserColors.blackbackground,
            appBar: AppBar(
              title: Padding(
                padding: EdgeInsets.all(f18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.history,
                      color: UserColors.yellowColor,
                    ),
                  ],
                ),
              ),
              backgroundColor: UserColors.blackbackground,
              bottom: TabBar(
                indicatorColor: UserColors.yellowColor,
                labelColor: UserColors.yellowColor,
                // isScrollable: true,
                tabs: transType
                    .map((tabText) => Tab(
                          child: Text(
                            tabText,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ))
                    .toList(),
              ),
            ),
            body: TabBarView(
              children: transType
                  .map((tabText) => TransactionTabs(
                        transType: tabText,
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
