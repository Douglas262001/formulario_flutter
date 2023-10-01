import 'package:image_picker/image_picker.dart';

class UserProfile {
  final String nome;
  final String? profissao;
  final String? dia;
  final String? cidade;
  final String? pais;
  final String? linguagem;
  final XFile? fotoPerfil;

  UserProfile({
    required this.nome,
    this.profissao,
    this.dia,
    this.cidade,
    this.pais,
    this.linguagem,
    this.fotoPerfil,
  });
}
