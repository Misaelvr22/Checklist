import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../componentes/tema.dart';
import 'inicio_sesion.dart';

class RegistroEstudiante extends StatefulWidget {
  const RegistroEstudiante({super.key});

  @override
  _RegistroEstudianteState createState() => _RegistroEstudianteState();
}

class _RegistroEstudianteState extends State<RegistroEstudiante> {
  final _formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final apellidoPatController = TextEditingController();
  final apellidoMatController = TextEditingController();
  final numControlController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasController = TextEditingController();

  String? selectedCarrera;
  String? selectedSemestre;
  bool _isLoading = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  final List<String> carreras = [
    'Ingeniería en Sistemas Computacionales',
    'Ingeniería Industrial',
    'Ingeniería Electromecánica',
    'ingeniería Civil',
    'Ingenieria en Administración',
    'Ingeniería en Gestión Empresarial',
    'Ingeniería Bioquímica',
    'Ingeniería Química',
    'Licenciatura en turismo',
  ];

  final List<String> semestres = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
  ];

  void registerUser(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    if (passwordController.text != confirmPasController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Las contraseñas no coinciden")),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await FirebaseFirestore.instance
          .collection('Registro')
          .doc('Estudiantes')
          .collection('Usuarios')
          .doc(userCredential.user!.uid)
          .set({
        'NumeroControl': numControlController.text.trim(),
        'Nombre': nombreController.text.trim(),
        'ApellidoPaterno': apellidoPatController.text.trim(),
        'ApellidoMaterno': apellidoMatController.text.trim(),
        'CorreoInstitucional': emailController.text.trim(),
        'Carrera': selectedCarrera ?? '',
        'Semestre': selectedSemestre ?? '',
        'UserType': 'Estudiante',
        'FechaRegistro': FieldValue.serverTimestamp(),
      });
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Registro exitoso!')),
      );
      Future.delayed(Duration(seconds: 2), () {
        Get.offAll(() => InicioSesion());
      });
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      String msg = "Error de registro";
      if (e.code == 'email-already-in-use') {
        msg = "Este correo ya está registrado";
      } else if (e.code == 'weak-password') {
        msg = "La contraseña es demasiado débil";
      } else if (e.message != null) {
        msg = e.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } on FirebaseException catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Error inesperado de Firebase")),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error inesperado: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Scaffold(
      backgroundColor: blanco,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 800,
                ),
                width: isMobile
                    ? MediaQuery.of(context).size.width * 0.95
                    : double.infinity,
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
                        Center(
                          child: Text(
                            'Registro de Estudiante',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: azulOscuro,
                            ),
                          ),
                        ),
                        sb25,
                        TextFormField(
                          controller: numControlController,
                          decoration: InputDecoration(
                            labelText: 'Número de Control',
                            prefixIcon:
                                Icon(Icons.perm_identity, color: azulOscuro),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Ingrese su número de control';
                            }
                            return null;
                          },
                        ),
                        sb13,
                        TextFormField(
                          controller: nombreController,
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                            prefixIcon:
                                Icon(Icons.perm_identity, color: azulOscuro),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z\s]')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese su nombre';
                            }
                            return null;
                          },
                        ),
                        sb13,
                        TextFormField(
                          controller: apellidoPatController,
                          decoration: InputDecoration(
                            labelText: 'Apellido Paterno',
                            prefixIcon:
                                Icon(Icons.perm_identity, color: azulOscuro),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z\s]')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese su apellido paterno';
                            }
                            return null;
                          },
                        ),
                        sb13,
                        TextFormField(
                          controller: apellidoMatController,
                          decoration: InputDecoration(
                            labelText: 'Apellido Materno',
                            prefixIcon:
                                Icon(Icons.perm_identity, color: azulOscuro),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z\s]')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese su apellido materno';
                            }
                            return null;
                          },
                        ),
                        sb13,
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Correo Institucional',
                            prefixIcon:
                                Icon(Icons.email_outlined, color: azulOscuro),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese su correo institucional';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Correo electrónico no válido';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: selectedCarrera,
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: 'Carrera',
                            prefixIcon: Icon(Icons.school, color: azulOscuro),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: carreras.map((carrera) {
                            return DropdownMenuItem<String>(
                              value: carrera,
                              child: Text(carrera),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCarrera = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Seleccione su carrera';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: selectedSemestre,
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: 'Semestre',
                            prefixIcon:
                                Icon(Icons.calendar_today, color: azulOscuro),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: semestres.map((sem) {
                            return DropdownMenuItem<String>(
                              value: sem,
                              child: Text(sem),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedSemestre = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Seleccione su semestre';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon:
                                Icon(Icons.lock_outline, color: azulOscuro),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: azulOscuro,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          obscureText: !_passwordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese una contraseña';
                            }
                            if (value.length < 8) {
                              return 'La contraseña debe tener al menos 8 caracteres';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: confirmPasController,
                          decoration: InputDecoration(
                            labelText: 'Confirmar Contraseña',
                            prefixIcon:
                                Icon(Icons.lock_outline, color: azulOscuro),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _confirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: azulOscuro,
                              ),
                              onPressed: () {
                                setState(() {
                                  _confirmPasswordVisible =
                                      !_confirmPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          obscureText: !_confirmPasswordVisible,
                          validator: (value) {
                            if (value != passwordController.text) {
                              return 'Las contraseñas no coinciden';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        Center(
                          child: SizedBox(
                            width: 180,
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () => registerUser(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: azulOscuro,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    )
                                  : Text(
                                      'Registrarse',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    numControlController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasController.dispose();
    super.dispose();
  }
}
