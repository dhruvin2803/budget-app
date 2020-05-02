import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {

  final List<Transaction> recentTranscations;
  Chart(this.recentTranscations);



  List <Map<String, Object>> get groupedTransactionValues{
    return List.generate(7, (index){
      final weekDay = DateTime.now().subtract(Duration(days: index)); 
      var totalSum = 0.0;

      for(int i = 0; i < recentTranscations.length ; i++){
        if(recentTranscations[i].date.day == weekDay.day &&
          recentTranscations[i].date.month == weekDay.month &&
          recentTranscations[i].date.year == weekDay.year){
            totalSum +=  recentTranscations[i].amount;
          }
      }

      return{'day' : DateFormat.E().format(weekDay).substring(0, 1) , 'amount' : totalSum };
    }).reversed.toList();
  }


  double get maxSpending{
    return groupedTransactionValues.fold(0.0 , (sum, item){
      return sum + item['amount'];
    });
  }


  @override
  Widget build(BuildContext context) {
    
    return Card(
      elevation: 8,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: groupedTransactionValues.map((data){
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(data['day'], data['amount'], maxSpending == 0.0 ? 0.0 : (data['amount'] as double) / maxSpending ));
          }).toList(), 
        ),
      ),
    );
  }
}