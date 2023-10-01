import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:aula_18_09_2023/UserProfile.dart';

class UserProfileForm extends StatefulWidget {
  final String? nome;
  final String? profissao;
  final String? dia;
  final String? cidade;
  final String? pais;
  final String? linguagem;
  final XFile? fotoPerfil;
  final bool editar;

  UserProfileForm({
    this.nome,
    this.profissao,
    this.dia,
    this.cidade,
    this.pais,
    this.linguagem,
    this.fotoPerfil,
    required this.editar,
  });

  @override
  _UserProfileFormState createState() => _UserProfileFormState();
}

class _UserProfileFormState extends State<UserProfileForm> {
  final _formKey = GlobalKey<FormState>();
  XFile? _imagemPerfil;
  String? _linguagem;

  late TextEditingController _nomeController;
  late TextEditingController _profissaoController;
  late TextEditingController _dataController;
  late TextEditingController _cidadeController;
  late TextEditingController _paisController;
  late UserProfile userProfile;

  @override
  void initState() {
    super.initState();

    _nomeController = TextEditingController(text: widget.nome ?? "");
    _profissaoController = TextEditingController(text: widget.profissao ?? "");
    _dataController = TextEditingController(text: widget.dia ?? "");
    _cidadeController = TextEditingController(text: widget.cidade ?? "");
    _paisController = TextEditingController(text: widget.pais ?? "");
    _linguagem = widget.linguagem;

    userProfile = UserProfile(
      nome: widget.nome ?? "",
      profissao: widget.profissao,
      dia: widget.dia,
      cidade: widget.cidade,
      pais: widget.pais,
      linguagem: widget.linguagem,
      fotoPerfil: widget.fotoPerfil,
    );

    if (widget.fotoPerfil != null) {
      _imagemPerfil = widget.fotoPerfil;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editar ? 'Editar Perfil' : 'Formulário do Perfil'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(labelText: 'Nome Completo'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório! insira seu nome completo';
                    }
                    final RegExp regex = RegExp(r"^[A-Za-z ]+$");
                    if (!regex.hasMatch(value)) {
                      return 'O nome deve conter apenas letras';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _dataController,
                  decoration: InputDecoration(labelText: 'Data de Nascimento'),
                  onTap: _selectDate,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório! insira sua data de nascimento';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cidadeController,
                  decoration: InputDecoration(labelText: 'Cidade'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório! insira sua cidade';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _paisController,
                  decoration: InputDecoration(labelText: 'País'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório! insira seu país';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _profissaoController,
                  decoration: InputDecoration(labelText: 'Profissão'),
                ),
                DropdownButtonFormField<String>(
                  value: _linguagem,
                  items: ['Português', 'Inglês', 'Espanhol'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _linguagem = newValue;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Idioma Preferido'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório! selecione um idioma';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Upload de Imagem'),
                ),
                if (_imagemPerfil != null)
                  Image.file(File(_imagemPerfil!.path), width: 100, height: 100),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UserProfileScreen(
                          nome: _nomeController.text,
                          fotoPerfil: _imagemPerfil,
                          profissao: _profissaoController.text,
                          dia: _dataController.text,
                          cidade: _cidadeController.text,
                          pais: _paisController.text,
                          linguagem: _linguagem!,
                        ),
                      ));
                    }
                  },
                  child: Text('Atualizar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );
    if (selectedDate != null && selectedDate != DateTime.now()) {
      _dataController.text = '${selectedDate.toLocal()}'.split(' ')[0];
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imagemPerfil = image;
    });
  }
}

class UserProfileScreen extends StatelessWidget {
  final String nome;
  final String? dia;
  final String? cidade;
  final String? pais;
  final String? linguagem;
  final XFile? fotoPerfil;
  final String? profissao;

  UserProfileScreen({
    required this.nome,
    this.dia,
    this.cidade,
    this.pais,
    this.linguagem,
    this.fotoPerfil,
    this.profissao,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Perfil')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (fotoPerfil != null)
                CircleAvatar(
                  radius: 55,
                  backgroundImage: FileImage(File(fotoPerfil!.path)),
                ),
              SizedBox(height: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(nome, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => UserProfileForm(
                      editar: true, 
                      nome: nome,
                      profissao: profissao,
                      dia: dia,
                      cidade: cidade,
                      pais: pais,
                      fotoPerfil: fotoPerfil,
                    ),
                  ));
                },
                child: Text('Editar Perfil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
