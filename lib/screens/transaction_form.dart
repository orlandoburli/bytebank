import 'dart:async';
import 'dart:io';

import 'package:bytebank/components/progress.dart';
import 'package:bytebank/components/response_dialog.dart';
import 'package:bytebank/components/transaction_auth_dialog.dart';
import 'package:bytebank/http/webclients/transaction_webclient.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:bytebank/widgets/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm(this.contact);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();

  final String transactionId = Uuid().v4();
  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    final dependencies = AppDependencies.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                visible: _sending,
                child: Progress(),
              ),
              Text(
                widget.contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contact.accountNumber.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: RaisedButton(
                    child: Text('Transfer'),
                    onPressed: () =>
                        saveTransaction(dependencies.transactionWebClient),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void saveTransaction(TransactionWebClient client) async {
    setState(() {
      _sending = true;
    });
    showDialog(
        context: context,
        builder: (context) => TransactionAuthDialog(
              onConfirm: (password) => confirmSaveTransaction(password, client),
            ));
  }

  void confirmSaveTransaction(
      String password, TransactionWebClient client) async {
    final double value = double.tryParse(_valueController.text);
    final transactionCreated =
        Transaction(transactionId, value, widget.contact);

    final transaction = await client
        .save(transactionCreated, password)
        .catchError(
            (e) => _showFailureMessage('Error when communicating transaction'),
            test: (e) => e is HttpException)
        .catchError(
            (e) => _showFailureMessage('Timeout when sending transaction'),
            test: (e) => e is TimeoutException)
        .catchError((e) => _showFailureMessage(e.message));

    if (transaction != null) {
      await showDialog(
          context: context,
          builder: (contextDialog) {
            return SuccessDialog('Successfully transaction');
          });
      Navigator.pop(context);
    }
    setState(() {
      _sending = false;
    });
  }

  Future _showFailureMessage(String message) => showDialog(
      context: context, builder: (contextDialog) => FailureDialog(message));
}
