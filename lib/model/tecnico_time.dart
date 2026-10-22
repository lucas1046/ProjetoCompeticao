class TecnicoTime {
  final int? idTecnicoTime;
  final int idTecnico;
  final int idTime;
  final int? idFoto;

  TecnicoTime({
    this.idTecnicoTime,
    required this.idTecnico,
    required this.idTime,
    this.idFoto,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_tecnico_time': idTecnicoTime,
      'id_tecnico': idTecnico,
      'id_time': idTime,
      'id_foto': idFoto,
    };
  }

  factory TecnicoTime.fromMap(Map<String, dynamic> map) {
    return TecnicoTime(
      idTecnicoTime: map['id_tecnico_time'],
      idTecnico: map['id_tecnico'],
      idTime: map['id_time'],
      idFoto: map['id_foto'],
    );
  }
}
