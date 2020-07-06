import 'package:bytebank/components/response_dialog.dart';
import 'package:bytebank/components/transaction_auth_dialog.dart';
import 'package:bytebank/main.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:bytebank/screens/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../matchers/matchers.dart';
import '../mocks/mock_contact_dao.dart';
import '../mocks/transaction_web_client_mock.dart';
import 'actions.dart';

void main() {
  testWidgets('Should transfer to a contact', (tester) async {
    final mockContactDao = MockContactDao();
    final mockTransactionWebClient = TransactionWebClientMock();

    await tester.pumpWidget(ByteBankApp(
      contactDao: mockContactDao,
      transactionWebClient: mockTransactionWebClient,
    ));

    final dashboard = find.byType(Dashboard);

    expect(dashboard, findsOneWidget);

    final orlando = Contact(0, 'Orlando', 1000);

    when(mockContactDao.findAll())
        .thenAnswer((invocation) => Future.value([orlando]));

    await clickOnTrransferFeatureItem(tester);
    await tester.pumpAndSettle();

    final contactsList = find.byType(ContactsList);

    expect(contactsList, findsOneWidget);

    verify(mockContactDao.findAll()).called(1);

    final contactItem = find.byWidgetPredicate((widget) {
      if (widget is ContactItem) {
        return widget.contact.name == 'Orlando' &&
            widget.contact.accountNumber == 1000;
      }
      return false;
    });

    expect(contactItem, findsOneWidget);

    await tester.tap(contactItem);
    await tester.pumpAndSettle();

    final transactionForm = find.byType(TransactionForm);
    expect(transactionForm, findsOneWidget);

    final contactName = find.text('Orlando');
    expect(contactName, findsOneWidget);

    final contactAccountName = find.text('1000');
    expect(contactAccountName, findsOneWidget);

    final textFieldValue =
        find.byWidgetPredicate((widget) => textFieldMatcher(widget, 'Value'));

    await tester.enterText(textFieldValue, '200.99');

    final transferButton = find.widgetWithText(RaisedButton, 'Transfer');
    expect(transferButton, findsOneWidget);

    await tester.tap(transferButton);
    await tester.pump();
    await tester.pump();
    await tester.pump();

    final transactionAuthDialog = find.byType(TransactionAuthDialog);
    expect(transactionAuthDialog, findsOneWidget);

    var textFieldPassword = find.byKey(transactionAuthDialogTextFieldPassword);
    expect(textFieldPassword, findsOneWidget);
    await tester.enterText(textFieldPassword, '1000');

    var cancelButton = find.widgetWithText(FlatButton, 'CANCEL');
    expect(cancelButton, findsOneWidget);

    var confirmButton = find.widgetWithText(FlatButton, 'CONFIRM');
    expect(confirmButton, findsOneWidget);

    when(mockTransactionWebClient.save(any, '1000')).thenAnswer(
        (realInvocation) => Future.value(Transaction(null, 200.99, orlando)));

    await tester.tap(confirmButton);
    await tester.pump();
    await tester.pump();

    final successDialog = find.byType(SuccessDialog);
    expect(successDialog, findsOneWidget);

    final okButton = find.widgetWithText(FlatButton, 'Ok');

    await tester.tap(okButton);
    await tester.pumpAndSettle();

    final contactsListBack = find.byType(ContactsList);
    expect(contactsListBack, findsOneWidget);
  });
}
