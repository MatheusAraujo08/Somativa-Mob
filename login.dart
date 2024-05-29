import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_somativa/main.dart';


class Login extends StatefulWidget {
  Login({Key? key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController user = TextEditingController();
  final TextEditingController senha = TextEditingController();
  List<dynamic>? usuarios;

  final String url = 'http://10.109.83.15:3000/usuarios';

  Future<void> _verificarlogin() async {
    try {
      final http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          usuarios = jsonResponse['usuarios'];
        });

        for (var usuario in usuarios!) {
          if (usuario['nome'] == user.text && usuario['Senha'] == senha.text) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => TelaView()));
            return;
          }
        }

        print("Usuário ou senha incorretos.");
      } else {
        print("Erro ao carregar usuários: ${response.statusCode}");
      }
    } catch (e) {
      print("Erro no login: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red[600],
        title: const Text("Mange Flix"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextField(
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide(width: 50),
                      ),
                      icon: Icon(Icons.person_sharp),
                      labelText: "Digite o usuário",
                      labelStyle: TextStyle(backgroundColor: Colors.grey),
                    ),
                    controller: user,
                  ),
                  TextField(
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        borderSide: BorderSide(width: 50),
                      ),
                      labelText: "Digite sua senha",
                      icon: Icon(Icons.key),
                    ),
                    controller: senha,
                    obscureText: true,
                    obscuringCharacter: "*",
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _verificarlogin().then((_) {
                  // Navega para TelaView se as credenciais estiverem corretas
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TelaView()));
                });
              },
              child: const Text("Entrar", style: TextStyle(color: Colors.grey)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
