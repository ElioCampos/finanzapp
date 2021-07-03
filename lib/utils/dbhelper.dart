// ignore: import_of_legacy_library_into_null_safe
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {

  final int version = 1;
  Database? db;

  static final DbHelper dbHelper = DbHelper._internal();
  DbHelper._internal();
  factory DbHelper(){
    return dbHelper;
  }

  Future<Database?> openDb() async {
    if (db == null) {
      db = await openDatabase(join(await getDatabasesPath(), 'finanzapp.db'),
          onCreate: (database, version) {
        database.execute('CREATE TABLE users('
            'id INTEGER PRIMARY KEY,'
            'username TEXT,'
            'password TEXT,'
            'email TEXT,'
            'fullName TEXT)');
        database.execute('CREATE TABLE wallets('
            'id INTEGER PRIMARY KEY,'
            'userId INTEGER,'
            'tipoMoneda INTEGER,'
            'tasaEfec DECIMAL,'
            'fechaDesc TEXT,'
            'gastosInic DECIMAL,'
            'gastosFin DECIMAL,' +
            'FOREIGN KEY(userId) REFERENCES users(id))');
        database.execute('CREATE TABLE letters('
                'id INTEGER PRIMARY KEY,'
                'walletId INTEGER,'
                'fechaGiro TEXT,'
                'fechaVenc TEXT,'
                'valNom DECIMAL,'
                'retencion DECIMAL,' +
            'FOREIGN KEY(walletId) REFERENCES wallets(id))');
      }, version: version);
    }
    return db;
  }

  Future testDB() async {
    db = await openDb();
    // await db!.execute('INSERT INTO users VALUES (1, "admin", "secret", "email@gmail.com", "Juan Rosales")');
    // await db!.execute('INSERT INTO wallets VALUES (1, 1, 14.8, "2021-05-04", 11.7, 17.0)');
    // await db!.execute('INSERT INTO letters VALUES (1, 1, "2021-04-11", "2021-07-10", 8538.0, 0)');
    // await db!.execute('INSERT INTO letters VALUES (2, 1, "2021-04-15", "2021-06-14", 9865.0, 0)');

    List wallets = await db!.rawQuery('select * from wallets');
    List letters = await db!.rawQuery('select * from letters');
    List users = await db!.rawQuery('select * from users');

    print("Wallets:");
    print(wallets);
    print("Letters:");
    print(letters);
    print("Users:");
    print(users);
  }
  Future registerUser(String username, String password, String email, String fullName) async {
    List users = await db!.rawQuery('select * from users');
    int lastId = 0;
    if (users.length > 0) {
      var lastUser = users.last;
      lastId = lastUser['id'];
    }
    await db!.execute('INSERT INTO users VALUES (${lastId+1}, "$username", "$password", "$email", "$fullName")');
    // print('INSERT INTO users VALUES ($lastId, "$username", "$password", "$email", "$fullName")');
    print('Registrado exitosamente');
  }

  Future getAllUsers() async {
    List users = await db!.rawQuery('select * from users');
    print(users);
    return users;
  }

  Future insertWallet(int userId, double tasa, String fechaDesc, double gastosIni, double gastosFin) async {
    List wallets = await db!.rawQuery('select * from wallets');
    int lastId = 0;
    if (wallets.length > 0) {
      var lastWallet = wallets.last;
      lastId = lastWallet['id'];
    }
    await db!.execute('INSERT INTO wallets VALUES (${lastId+1}, $userId, $tasa, "$fechaDesc", $gastosIni, $gastosFin)');
    print("Agregada nueva cartera");
  }
  
  Future updateWallet(int walletId, double tasa, String fechaDesc, double gastosIni, double gastosFin) async {
    // List wallets = await db!.rawQuery('select * from wallets');
    await db!.execute('UPDATE wallets SET tasaEfec=$tasa, fechaDesc="$fechaDesc", gastosInic=$gastosIni, gastosFin=$gastosFin WHERE id=$walletId');
  }

  Future deleteWallet(int walletId) async {
    await db!.execute('delete from wallets where id=$walletId');
    await db!.execute('delete from letters where walletId=$walletId');
    print("Eliminada cartera con id $walletId");
  }

  Future<List<dynamic>> getWallets(int userId) async {
    List wallets = await db!.rawQuery('select * from wallets where userId=$userId');
    print(wallets);
    return wallets;
  }

  Future<List<dynamic>> getWalletById(int id) async {
    List wallets = await db!.rawQuery('select * from wallets where id=$id;');
    print(wallets);
    return wallets;
  }

  Future insertLetter(int walletId, String fechaGiro, String fechaVenc, double valorNom, double retencion) async {
    List letters = await db!.rawQuery('select * from letters');
    print(letters.length);
    int lastId = 0;
    if (letters.length > 0) {
      var lastLetter = letters.last;
      lastId = lastLetter['id'];
    }
    print('INSERT INTO letters VALUES (${lastId+1}, $walletId, "$fechaGiro", "$fechaVenc", $valorNom, $retencion)');
    await db!.execute('INSERT INTO letters VALUES (${lastId+1}, $walletId, "$fechaGiro", "$fechaVenc", $valorNom, $retencion)');
    print("Agregada nueva letra");
  }

  Future<List<dynamic>> getLettersByWalletId(int walletId) async {
    List letters = await db!.rawQuery('select * from letters where walletId=$walletId;');
    print(letters);
    return letters;
  }

  Future<List<dynamic>> getLetterById(int id) async {
    List letters = await db!.rawQuery('select * from letters where id=$id;');
    print(letters);
    return letters;
  }

  Future updateLetter(int letterId, String fechaGiro, String fechaVenc, double valNom, double retencion) async {
    // List wallets = await db!.rawQuery('select * from wallets');
    await db!.execute('UPDATE letters SET fechaGiro="$fechaGiro", fechaVenc="$fechaVenc", valNom=$valNom, retencion=$retencion WHERE id=$letterId');
  }

  Future deleteLetter(int letterId) async {
    await db!.execute('delete from letters where id=$letterId');
    print("Eliminada letra con id $letterId");
  }
}