import 'package:bytebank/components/centered_message.dart';
import 'package:bytebank/components/progress.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:bytebank/screens/transaction_form.dart';
import 'package:bytebank/widgets/app_dependencies.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatefulWidget {
  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  @override
  Widget build(BuildContext context) {
    final dependencies = AppDependencies.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer'),
      ),
      body: FutureBuilder<List<Contact>>(
        initialData: List(),
        future: dependencies.contactDao.findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.waiting:
              return Progress();
            case ConnectionState.done:
              if (snapshot.data != null)
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) => ContactItem(
                          contact: snapshot.data[index],
                          onClick: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TransactionForm(snapshot.data[index]))),
                        ));
          }
          return CenteredMessage('Unknow error');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToNewContact(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void goToNewContact(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ContactForm()))
        .then((value) => this.setState(() {}));
  }
}

class ContactItem extends StatelessWidget {
  final Contact contact;
  final Function onClick;

  ContactItem({this.contact, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onClick,
        title: Text(
          contact.name,
          style: TextStyle(fontSize: 24),
        ),
        subtitle: Text(
          contact.accountNumber.toString(),
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
