import 'package:bytebank/models/contact.dart';
import 'package:bytebank/widgets/app_dependencies.dart';
import 'package:flutter/material.dart';

class ContactForm extends StatefulWidget {
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dependencies = AppDependencies.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('New Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: 'Full name',
                    hintText: 'Fill with full name user'),
                style: TextStyle(fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextField(
                controller: _accountNumberController,
                decoration: InputDecoration(
                    labelText: 'Account number',
                    hintText: 'Account number of the contact'),
                style: TextStyle(fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SizedBox(
                width: double.maxFinite,
                child: RaisedButton(
                  child: Text('Create'),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () => saveForm(context, dependencies),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void saveForm(BuildContext context, AppDependencies dependencies) async {
    var name = _nameController.text;
    var accountNumber = int.tryParse(_accountNumberController.text);

    var contact = Contact(0, name, accountNumber);

    await dependencies.contactDao.save(contact);

    Navigator.pop(context);
  }
}
