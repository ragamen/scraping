class Articulos {
  final String operador;
  final String numero;
  final String urlimage;
  final String nombre;
  final String hora;
  const Articulos(
      { required this.operador,required this.numero, required this.urlimage,required this.nombre,required this.hora,});
  Map<String, dynamic> toMap() {
    return {'operador'      : operador,
      'urlimage' : urlimage,
      'numero' : numero,
      'nombre' : nombre,
      'hora' : hora
    };

  }

  Articulos.fromMap(Map<String, dynamic> map)
      : operador = map["operador"],
        urlimage = map["urlimage"],
        numero = map["numero"],
        nombre = map["nombre"],
        hora = map["hora"];
}
