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
        database.execute('CREATE TABLE wallets('
            'id INTEGER PRIMARY KEY,'
            'tasaEfec DECIMAL,'
            'fechaDesc TEXT,'
            'gastosInic DECIMAL,'
            'gastosFin DECIMAL)');
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

    await db!.execute('INSERT INTO wallets VALUES (1, 14.8, "2021-05-04", 11.7, 17.0)');
    await db!.execute('INSERT INTO letters VALUES (1, 1, "2021-04-11", "2021-07-10", 8538.0, 0)');
    await db!.execute('INSERT INTO letters VALUES (2, 1, "2021-04-15", "2021-06-14", 9865.0, 0)');

    List wallets = await db!.rawQuery('select * from wallets');
    List letters = await db!.rawQuery('select * from letters');

    print("Wallets:");
    print(wallets);
    print("Letters:");
    print(letters);
  }

  Future insertWallet(double tasa, String fechaDesc, double gastosIni, double gastosFin) async {
    List wallets = await db!.rawQuery('select * from wallets');
    var lastWallet = wallets.last;
    int lastId = lastWallet['id'];
    // String dateString ="${fechaDesc.year.toString()}-${fechaDesc.month.toString().padLeft(2,'0')}-${fechaDesc.day.toString().padLeft(2,'0')}";
    // print(dateString);

    print('INSERT INTO wallets VALUES (${lastId+1}, $tasa, "$fechaDesc", $gastosIni, $gastosFin)');
    await db!.execute('INSERT INTO wallets VALUES (${lastId+1}, $tasa, "$fechaDesc", $gastosIni, $gastosFin)');
    print("Agregada nueva cartera");
  }

  Future<List<dynamic>> getWallets() async {
    List wallets = await db!.rawQuery('select * from wallets');
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

}