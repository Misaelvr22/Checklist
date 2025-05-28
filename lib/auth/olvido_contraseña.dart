import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../componentes/tema.dart';
import 'inicio_sesion.dart';

class OlvidoContrasena extends StatefulWidget {
  const OlvidoContrasena({super.key});

  @override
  _OlvidoContrasenaState createState() => _OlvidoContrasenaState();
}

class _OlvidoContrasenaState extends State<OlvidoContrasena> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future pwReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text('Email enviado'),
            content: Text(
              'Si el email está registrado, el correo se enviará entonces a ${emailController.text.trim()}',
              style: TextStyle(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Aceptar',
                  style: TextStyle(
                    color: azulOscuro,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Show a dialog with the error message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text('Error'),
            content: Text(
              'Ha ocurrido un error. Por favor, inténtalo de nuevo.',
              style: TextStyle(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  //Get.to();
                },
                child: Text(
                  'Aceptar',
                  style: TextStyle(
                    color: Color(0xFF0A66C2),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      child: Scaffold(
        backgroundColor: blanco,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: isMobile ? MediaQuery.of(context).size.width * 0.95 : 400,
              constraints: BoxConstraints(maxWidth: 700),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isMobile) sb13,

                      Text('Olvidaste tu contraseña', style: titulo),

                      sb13,

                      Text(
                          'Ingresa tu email para recibir un enlace de recuperación',
                          style: subtitulo),

                      sb25,

                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          filled: true,
                          fillColor: blanco,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: gris),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: grisClaro),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: azulITZ, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu email';
                          }
                          return null;
                        },
                      ),

                      sb25,

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              pwReset();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: azulOscuro,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Continuar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: blanco,
                            ),
                          ),
                        ),
                      ),

                      sb13,

                      // Back button
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Get.to(InicioSesion());
                          },
                          child: Text(
                            'Volver',
                            style: TextStyle(
                              color: azulOscuro,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
