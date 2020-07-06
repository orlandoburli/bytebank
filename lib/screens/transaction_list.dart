import 'package:bytebank/components/centered_message.dart';
import 'package:bytebank/components/progress.dart';
import 'package:bytebank/http/webclients/transaction_webclient.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionsList extends StatelessWidget {
  final TransactionWebClient client = TransactionWebClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: FutureBuilder<List<Transaction>>(
          initialData: List(),
          future: client.findAll(),
          builder: (context, snapshot) {

            switch (snapshot.connectionState) {
              case ConnectionState.none:
                break;
              case ConnectionState.waiting:
                return Progress();
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    if (snapshot.data.isNotEmpty) {
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          final Transaction transaction = snapshot.data[index];
                          return Card(
                            child: ListTile(
                              leading: Icon(Icons.monetization_on),
                              title: Text(
                                transaction.value.toString(),
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${transaction.contact.name} - ${transaction.contact.accountNumber.toString()}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount:
                            snapshot.data != null ? snapshot.data.length : 0,
                      );
                    }
                  }
                }
                return CenteredMessage(
                  'No transactions found',
                  icon: Icons.warning,
                );
            }

            return CenteredMessage('Unknow error');
          }),
    );
  }
}
