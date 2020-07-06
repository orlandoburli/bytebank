import 'dart:convert';

import 'package:bytebank/models/transaction.dart';

import '../webclient.dart';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async =>
      _toTransactions((await client.get(url)).body);

  List<Transaction> _toTransactions(String json) {
    final List<dynamic> maps = jsonDecode(json);

    return maps.map((e) => Transaction.fromJson(e)).toList();
  }

  Future<Transaction> save(Transaction transaction, String password) async {
    final response = await client.post(url,
        headers: {'Content-Type': 'application/json', 'password': password},
        body: jsonEncode(transaction.toJson()));

    if (response.statusCode >= 200 && response.statusCode <= 299)
      return Transaction.fromJson(jsonDecode(response.body));

    throw Exception(_getMessage(response.statusCode));
  }

  String _getMessage(int statusCode) =>
      _statusCodeResponses.containsKey(statusCode)
          ? _statusCodeResponses[statusCode]
          : 'Unknow error';

  static final Map<int, String> _statusCodeResponses = {
    400: 'There was an error sending the transaction',
    401: 'Authentication failed',
    409: 'Transaction already exists'
  };
}
