import 'package:bytebank/database/app_database.dart';
import 'package:bytebank/models/contact.dart';
import 'package:sqflite/sqflite.dart';

class ContactDao {
  static final String tableSQL = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_name TEXT, '
      '$_accountNumber INTEGER)';

  static final String _tableName = 'contacts';
  static final String _id = 'id';
  static final String _name = 'name';
  static final String _accountNumber = 'account_number';

  Future<int> save(Contact contact) async {
    final Database db = await getDatabase();
    Map<String, dynamic> contactMap = _toMap(contact);
    return db.insert(_tableName, contactMap);
  }

  Map<String, dynamic> _toMap(Contact contact) {
    final Map<String, dynamic> contactMap = Map();
    contactMap[_name] = contact.name;
    contactMap[_accountNumber] = contact.accountNumber;
    return contactMap;
  }

  Future<List<Contact>> findAll() async {
    final Database db = await getDatabase();
    final List<Contact> contacts = List();

    for (Map<String, dynamic> row in await db.query('contacts')) {
      final Contact contact = _toContact(row);
      contacts.add(contact);
    }
    return contacts;
  }

  Contact _toContact(Map<String, dynamic> row) {
    return Contact(
      row[_id],
      row[_name],
      row[_accountNumber],
    );
  }
}
