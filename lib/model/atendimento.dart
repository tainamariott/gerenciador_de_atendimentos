class Atendimento {

  static const String NOME_TABELA = 'atendimentos';
  static const String CAMPO_ID = 'id';
  static const String CAMPO_DESCRICAO = 'descricao';
  static const String CAMPO_DATA = 'data';
  static const String CAMPO_HORA = 'hora';
  static const String CAMPO_VALOR = 'valor';
  static const String CAMPO_LOCALIZACAO = 'localizacao';

  int? id;
  String descricao;
  String data;
  String hora;
  double valor;
  String localizacao;

  Atendimento({
    this.id,
    required this.descricao,
    required this.data,
    required this.hora,
    required this.valor,
    required this.localizacao,
  });

  Map<String, dynamic> toMap() {
    return {
      CAMPO_ID: id,
      CAMPO_DESCRICAO: descricao,
      CAMPO_DATA: data,
      CAMPO_HORA: hora,
      CAMPO_VALOR: valor,
      CAMPO_LOCALIZACAO: localizacao,
    };
  }

  factory Atendimento.fromMap(Map<String, dynamic> map) {
    return Atendimento(
      id: map[CAMPO_ID],
      descricao: map[CAMPO_DESCRICAO],
      data: map[CAMPO_DATA],
      hora: map[CAMPO_HORA],
      valor: map[CAMPO_VALOR],
      localizacao: map[CAMPO_LOCALIZACAO],
    );
  }
}