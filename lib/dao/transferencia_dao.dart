import 'package:bytebank/models/transferencia.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String _bancoDeDados = 'bytebank.db';
final String _nomeTabela = 'transferencias';
final String _campoId = 'id';
final String _campoValor = 'valor';
final String _campoNumeroConta = 'numero_conta';

final String _sqlTabelaTransferencia = 'CREATE TABLE $_nomeTabela('
    '$_campoId INTEGER PRIMARY KEY AUTOINCREMENT, '
    '$_campoValor REAL, '
    '$_campoNumeroConta INTEGER)';

class TransferenciaDao {
  TransferenciaDao() {
    criaBanco();
  }

  Future<Database> criaBanco() async {
    return openDatabase(
      join(
        await getDatabasesPath(),
        _bancoDeDados,
      ),
      onCreate: (db, version) {
        return db.execute(
          _sqlTabelaTransferencia,
        );
      },
      version: 1,
    );
  }

  Future<int> salva(Transferencia transferencia) async {
    final db = await criaBanco();

    return db.insert(_nomeTabela, _converteParaMapa(transferencia),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Transferencia>> todasTransferencias() async {
    final db = await criaBanco();
    final List<Map<String, dynamic>> maps = await db.query(_nomeTabela);
    return List.generate(
      maps.length,
      (i) {
        return Transferencia(
          maps[i][_campoValor],
          maps[i][_campoNumeroConta],
          id: maps[i][_campoId],
        );
      },
    );
  }

  Map<String, dynamic> _converteParaMapa(Transferencia transferencia) {
    return {
      _campoId: transferencia.id,
      _campoNumeroConta: transferencia.numeroConta,
      _campoValor: transferencia.valor,
    };
  }

  Future<void> edita(Transferencia transferencia) async {
    final db = await criaBanco();
    final mapa = _converteParaMapa(transferencia);
    return db.update(
      _nomeTabela,
      mapa,
      where: "id = ?",
      whereArgs: [transferencia.id],
    );
  }

  Future<void> remove(Transferencia transferencia) async {
    final db = await criaBanco();
    return db.delete(
      _nomeTabela,
      where: "id = ?",
      whereArgs: [transferencia.id],
    );
  }
}
