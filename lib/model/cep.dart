class Cep {
  final String cep;
  final String logradouro;
  final String bairro;
  final String localidade;
  final String uf;

  Cep({
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.localidade,
    required this.uf,
  });

  factory Cep.fromMap(Map<String, dynamic> map) {
    return Cep(
      cep: map['cep'] ?? '',
      logradouro: map['logradouro'] ?? '',
      bairro: map['bairro'] ?? '',
      localidade: map['localidade'] ?? '',
      uf: map['uf'] ?? '',
    );
  }

  String get enderecoFormatado {
    final partes = <String>[];
    if (logradouro.isNotEmpty) partes.add(logradouro);
    if (bairro.isNotEmpty) partes.add(bairro);
    if (localidade.isNotEmpty) partes.add('$localidade - $uf');
    if (cep.isNotEmpty) partes.add('CEP: $cep');
    return partes.join(', ');
  }
}
