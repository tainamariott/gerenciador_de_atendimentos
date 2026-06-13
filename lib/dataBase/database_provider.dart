import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/atendimento.dart';

class DatabaseProvider {
  static const String databaseName = 'atendimentos.db';
  static const int databaseVersion = 1;

  DatabaseProvider._init();

  static final DatabaseProvider instance = DatabaseProvider._init();

  Database? _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDatabase();
    }
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, databaseName);

    return await openDatabase(
      path,
      version: databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${Atendimento.NOME_TABELA} (
        ${Atendimento.CAMPO_ID} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Atendimento.CAMPO_DESCRICAO} TEXT,
        ${Atendimento.CAMPO_DATA} TEXT,
        ${Atendimento.CAMPO_HORA} TEXT,
        ${Atendimento.CAMPO_VALOR} REAL,
        ${Atendimento.CAMPO_LOCALIZACAO} TEXT
      )
    ''');
  }
}