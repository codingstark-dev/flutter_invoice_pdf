import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class SqlDb extends GetxController {
  //create a db instance
  late Database sqlDb;
  RxBool ifCompanyDetails = false.obs;
  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    // Open the database
    //Gather Company Details:
// Prompt the user to input the following:
// Company Name
// Company Logo (image file) option
// Company Address
// QR Code (image file for payment)
// Signature Image (to add below the total amount)
    if (await sqlDb.isOpen) {
      var companyDetails = await query('company');
      if (companyDetails.isNotEmpty) {
        ifCompanyDetails.value = true;
      }
    }
    sqlDb = await openDatabase(
      // Set the path to the database.
      // Note: Using the `join` function from the `path` package
      // will pre-fix the path with the platform-specific location.
      join(await getDatabasesPath(), 'company_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE company(id INTEGER PRIMARY KEY, name TEXT, logo TEXT, address TEXT, qr_code TEXT, signature TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> close() async {
    // Close the database
    sqlDb.close();
  }

  Future<void> insert(String table, Map<String, dynamic> data) async {
    // Insert data into the table
    await sqlDb.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateDb(String table, Map<String, dynamic> data) async {
    // Update data in the table
    await sqlDb.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
  }

  Future<void> delete(String table, int id) async {
    // Delete data from the table
    await sqlDb.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> query(String table) async {
    // Query data from the table
    return sqlDb.query(table);
    return [];
  }
}
