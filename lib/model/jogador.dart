class Jogador {
  final int? id;
  final String cpf;
  final String nome;
  final String dataNascimento;
  final int idResponsavel;
  final int? idFoto;
  final int? idPosicao;
  final int? numeroCamisa;

  Jogador({
    this.id,
    required this.cpf,
    required this.nome,
    required this.dataNascimento,
    required this.idResponsavel,
    this.idFoto,
    this.idPosicao,
    this.numeroCamisa,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cpf': cpf,
      'nome': nome,
      'data_nascimento': dataNascimento,
      'id_responsavel': idResponsavel,
      'id_foto': idFoto,
      'id_posicao': idPosicao,
      'numero_camisa': numeroCamisa,
    };
  }

  factory Jogador.fromMap(Map<String, dynamic> map) {
    return Jogador(
      id: map['id'],
      cpf: map['cpf'],
      nome: map['nome'],
      dataNascimento: map['data_nascimento'],
      idResponsavel: map['id_responsavel'],
      idFoto: map['id_foto'],
      idPosicao: map['id_posicao'],
      numeroCamisa: map['numero_camisa'],
    );
  }
}