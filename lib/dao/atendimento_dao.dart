import '../dataBase/database_provider.dart';
import '../model/atendimento.dart';

class AtendimentoDao {

  final dbProvider = DatabaseProvider.instance;

  Future<bool> salvar(Atendimento atendimento) async {
    final db = await dbProvider.database;

    if (atendimento.id == null) {
      final id = await db.insert(
        Atendimento.NOME_TABELA,
        atendimento.toMap(),
      );
      atendimento.id = id;
      return true;
    } else {
      final result = await db.update(
        Atendimento.NOME_TABELA,
        atendimento.toMap(),
        where: '${Atendimento.CAMPO_ID} = ?',
        whereArgs: [atendimento.id],
      );
      return result > 0;
    }
  }

  Future<bool> excluir(int id) async {
    final db = await dbProvider.database;

    final result = await db.delete(
      Atendimento.NOME_TABELA,
      where: '${Atendimento.CAMPO_ID} = ?',
      whereArgs: [id],
    );

    return result > 0;
  }

  Future<List<Atendimento>> listar({String filtro = ''}) async {
    final db = await dbProvider.database;

    String? where;
    List<dynamic>? whereArgs;

    if (filtro.isNotEmpty) {
      where = "${Atendimento.CAMPO_DATA} = ?";
      whereArgs = [filtro];
    }

    final result = await db.query(
      Atendimento.NOME_TABELA,
      where: where,
      whereArgs: whereArgs,
      orderBy: Atendimento.CAMPO_ID,
    );

    return result.map((map) => Atendimento.fromMap(map)).toList();
  }
}