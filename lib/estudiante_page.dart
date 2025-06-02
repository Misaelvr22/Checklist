import 'dart:convert';

import 'package:check_list/auth/inicio_sesion.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:table_calendar/table_calendar.dart';
import 'componentes/tema.dart';

class EstudianteDashboard extends StatefulWidget {
  @override
  _EstudianteDashboardState createState() => _EstudianteDashboardState();
}

class _EstudianteDashboardState extends State<EstudianteDashboard> {
  int _selectedIndex = 0;
  Map<String, dynamic>? estudianteData;
  String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    _loadEstudianteData();
  }

  Future<void> _loadEstudianteData() async {
    try {
      DocumentSnapshot estudianteDoc = await FirebaseFirestore.instance
          .collection('Registro')
          .doc('Estudiantes')
          .collection('Usuarios')
          .doc(uid)
          .get();

      if (estudianteDoc.exists) {
        setState(() {
          estudianteData = estudianteDoc.data() as Map<String, dynamic>;
        });
      }
    } catch (e) {
      SnackBar(
          content: Text('Error cargando la información del estudiante: $e'));
    }
  }

  List<Widget> get _pages => [
        PerfilEstudiante(estudianteData: estudianteData),
        EscanerQR(key: ValueKey(_selectedIndex)), // Add key to force rebuild
        CalendarioAsistencia(estudianteId: uid),
        RetroalimentacionPage(estudianteId: uid),
      ];

  String get _currentTitle {
    switch (_selectedIndex) {
      case 0:
        return 'Mi Perfil';
      case 1:
        return 'Escanear QR';
      case 2:
        return 'Mi Asistencia';
      case 3:
        return 'Retroalimentación';
      default:
        return 'Dashboard';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blanco,
      appBar: AppBar(
        backgroundColor: azulOscuro,
        centerTitle: true,
        title: Text(_currentTitle, style: titulo.copyWith(color: blanco)),
        elevation: 0,
        actions: _selectedIndex == 0
            ? [
                IconButton(
                  icon: Icon(Icons.logout, color: blanco),
                  tooltip: 'Cerrar sesión',
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => InicioSesion()),
                    );
                    ;
                  },
                ),
              ]
            : null,
        iconTheme: IconThemeData(color: blanco),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: azulOscuro,
        selectedItemColor: blanco,
        unselectedItemColor: blanco.withOpacity(0.7),
        selectedIconTheme: IconThemeData(color: blanco),
        unselectedIconTheme: IconThemeData(color: blanco.withOpacity(0.7)),
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Escanear QR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Asistencia',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Feedback',
          ),
        ],
      ),
    );
  }
}

class PerfilEstudiante extends StatelessWidget {
  final Map<String, dynamic>? estudianteData;

  PerfilEstudiante({required this.estudianteData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Container(
        constraints: BoxConstraints(maxWidth: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            sb20,
            // Profile Header Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [azulITZ, azul],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: azulITZ.withOpacity(0.3),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: blanco,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: azulOscuro,
                      child: Icon(Icons.person, size: 60, color: blanco),
                    ),
                  ),
                  sb20,
                  Text(
                    estudianteData?['Nombre'] ?? 'Estudiante',
                    style: titulo.copyWith(color: blanco, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  sb5,
                  Text(
                    estudianteData?['NumeroControl'] ?? 'N/A',
                    style:
                        TextStyle(color: blanco.withOpacity(0.9), fontSize: 16),
                  ),
                ],
              ),
            ),
            sb25,

            // Info Cards
            _buildInfoCard('Correo Institucional',
                estudianteData?['CorreoInstitucional'] ?? 'N/A', Icons.email),
            sb13,
            _buildInfoCard(
                'Carrera', estudianteData?['Carrera'] ?? 'N/A', Icons.school),
            sb13,
            _buildInfoCard('Semestre',
                estudianteData?['Semestre']?.toString() ?? 'N/A', Icons.grade),
            sb25,

            // Stats Card
            _buildStatsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: gris.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: azulClaro,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: azulITZ, size: 24),
          ),
          sb13,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: grisOscuro, fontSize: 14)),
                sb5,
                Text(value, style: subtitulo.copyWith(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gris.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text('Estadísticas Académicas',
              style: subtitulo.copyWith(fontSize: 18)),
          sb20,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Materias\nInscritas', '5', azulITZ, Icons.book),
              _buildStatItem(
                  'Asistencia\nPromedio', '85%', azul, Icons.check_circle),
              _buildStatItem('Clases\nHoy', '3', azulOscLight, Icons.today),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.8)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: blanco, size: 20),
              sb5,
              Text(value,
                  style: TextStyle(
                      color: blanco,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        sb10,
        Text(label,
            style: texto.copyWith(fontSize: 12), textAlign: TextAlign.center),
      ],
    );
  }
}

class EscanerQR extends StatefulWidget {
  const EscanerQR({Key? key}) : super(key: key);

  @override
  _EscanerQRState createState() => _EscanerQRState();
}

class _EscanerQRState extends State<EscanerQR> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isScanning = false;
  bool isFlashOn = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(), // Para un scroll más suave
            child: Column(
              children: [
                // Scanner QR - altura fija
                Container(
                  height: MediaQuery.of(context).size.height *
                      0.55, // Reducido de 0.6 a 0.55
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: azulOscuro.withOpacity(0.3),
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        QRView(
                          key: qrKey,
                          onQRViewCreated: _onQRViewCreated,
                          overlay: QrScannerOverlayShape(
                            borderColor: azulITZ,
                            borderRadius: 15,
                            borderLength: 40,
                            borderWidth: 8,
                            cutOutSize: 280,
                          ),
                        ),
                        Positioned(
                          top: 20,
                          right: 20,
                          child: FloatingActionButton(
                            mini: true,
                            backgroundColor: azulOscuro.withOpacity(0.8),
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {
                                isFlashOn = !isFlashOn;
                              });
                            },
                            child: Icon(
                              isFlashOn ? Icons.flash_off : Icons.flash_on,
                              color: blanco,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Área de controles - ahora sin Flexible
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 15), // Reducido padding vertical
                  child: Column(
                    mainAxisSize: MainAxisSize
                        .min, // Importante: usar el mínimo espacio necesario
                    children: [
                      Container(
                        padding: EdgeInsets.all(15), // Reducido de 20 a 15
                        decoration: BoxDecoration(
                          color: azulClaro,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: azulITZ),
                            SizedBox(
                                width: 10), // Usar SizedBox en lugar de sb10
                            Expanded(
                              child: Text(
                                'Apunta la cámara hacia el código QR de tu clase',
                                style: texto,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15), // Reducido de 20 a 15
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isScanning ? gris : azulITZ,
                            padding: EdgeInsets.symmetric(
                                vertical: 15), // Reducido de 18 a 15
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: isScanning ? 0 : 8,
                          ),
                          onPressed: isScanning
                              ? null
                              : () {
                                  controller?.resumeCamera();
                                  setState(() {
                                    isScanning = true;
                                  });
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize:
                                MainAxisSize.min, // Usar el mínimo espacio
                            children: [
                              if (isScanning)
                                Container(
                                  width: 20,
                                  height: 20,
                                  margin: EdgeInsets.only(right: 10),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(blanco),
                                  ),
                                ),
                              Text(
                                isScanning
                                    ? 'Escaneando...'
                                    : 'Iniciar Escaneo',
                                style: TextStyle(
                                    color: blanco,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20), // Espacio adicional al final
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      if (isScanning) {
        _handleQRScan(scanData.code ?? '');
      }
    });
  }

  Future<void> _handleQRScan(String qrData) async {
    setState(() {
      isScanning = false;
    });

    controller?.pauseCamera();

    try {
      await _registrarAsistencia(qrData);
      _showSuccessDialog('¡Asistencia registrada correctamente!');
    } catch (e) {
      _showErrorDialog('Error al registrar asistencia: $e');
    }
  }

  Future<void> _registrarAsistencia(String qrData) async {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    String nombre =
        FirebaseAuth.instance.currentUser?.displayName ?? 'Estudiante';
    String correo = FirebaseAuth.instance.currentUser?.email ?? '';

    // Decodifica el QR (espera un JSON)
    Map<String, dynamic> data;
    try {
      data = jsonDecode(qrData);
    } catch (e) {
      throw Exception('Código QR inválido');
    }

    String claseId = data['claseId'];
    String materia = data['materia'] ?? 'Materia';
    String grupo = data['grupo'] ?? 'Grupo';

    // Verifica si ya está registrado
    final docRef = FirebaseFirestore.instance
        .collection('clases')
        .doc(claseId)
        .collection('asistencias')
        .doc(uid);

    final doc = await docRef.get();
    if (doc.exists) {
      throw Exception('Ya registraste tu asistencia en esta clase');
    }

    // Registra la asistencia
    await docRef.set({
      'uid': uid,
      'nombre': nombre,
      'correo': correo,
      'materia': materia,
      'grupo': grupo,
      'fecha': DateTime.now(),
    });

    // Opcional: Puedes guardar también en /Registro/Estudiantes/Usuarios/uid/asistencias
    await FirebaseFirestore.instance
        .collection('Registro')
        .doc('Estudiantes')
        .collection('Usuarios')
        .doc(uid)
        .collection('asistencias')
        .doc(claseId)
        .set({
      'claseId': claseId,
      'materia': materia,
      'grupo': grupo,
      'fecha': DateTime.now(),
    });
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            sb10,
            Text('Éxito', style: subtitulo),
          ],
        ),
        content: Text(message, style: texto),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                isScanning = false;
              });
            },
            child: Text('OK',
                style: TextStyle(color: azulITZ, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            sb10,
            Text('Error', style: subtitulo),
          ],
        ),
        content: Text(message, style: texto),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                isScanning = false;
              });
            },
            child: Text('OK',
                style: TextStyle(color: azulITZ, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class CalendarioAsistencia extends StatefulWidget {
  final String estudianteId;

  CalendarioAsistencia({required this.estudianteId});

  @override
  _CalendarioAsistenciaState createState() => _CalendarioAsistenciaState();
}

class _CalendarioAsistenciaState extends State<CalendarioAsistencia> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Map<String, dynamic>>> _asistencias = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _loadAsistencias();
  }

  Future<void> _loadAsistencias() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Asistencias')
          .where('estudianteId', isEqualTo: widget.estudianteId)
          .get();

      Map<DateTime, List<Map<String, dynamic>>> asistenciasMap = {};

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        DateTime fecha = (data['fecha'] as Timestamp).toDate();
        DateTime fechaKey = DateTime(fecha.year, fecha.month, fecha.day);

        if (!asistenciasMap.containsKey(fechaKey)) {
          asistenciasMap[fechaKey] = [];
        }
        asistenciasMap[fechaKey]!.add(data);
      }

      setState(() {
        _asistencias = asistenciasMap;
      });
    } catch (e) {
      print('Error loading attendance: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              sb20,
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: gris.withOpacity(0.2),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: TableCalendar<Map<String, dynamic>>(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  eventLoader: (day) {
                    DateTime key = DateTime(day.year, day.month, day.day);
                    return _asistencias[key] ?? [];
                  },
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    selectedDecoration: BoxDecoration(
                      color: azulITZ,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: azul,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: azulOscLight,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: subtitulo.copyWith(fontSize: 18),
                    leftChevronIcon:
                        Icon(Icons.chevron_left, color: azulOscuro),
                    rightChevronIcon:
                        Icon(Icons.chevron_right, color: azulOscuro),
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                ),
              ),
              sb25,
              if (_selectedDay != null) _buildAsistenciasDia(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAsistenciasDia() {
    DateTime key =
        DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    List<Map<String, dynamic>> asistenciasDia = _asistencias[key] ?? [];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gris.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event, color: azulITZ),
              sb10,
              Text(
                  'Asistencias del ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                  style: subtitulo.copyWith(fontSize: 18)),
            ],
          ),
          sb20,
          if (asistenciasDia.isEmpty)
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: azulClaro,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: azulITZ),
                  sb10,
                  Text('No hay asistencias registradas para este día',
                      style: texto),
                ],
              ),
            )
          else
            ...asistenciasDia
                .map((asistencia) => _buildAsistenciaItem(asistencia))
                .toList(),
        ],
      ),
    );
  }

  Widget _buildAsistenciaItem(Map<String, dynamic> asistencia) {
    DateTime horaRegistro = (asistencia['horaRegistro'] as Timestamp).toDate();

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [azulClaro, azulClaro.withOpacity(0.5)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border(
          left: BorderSide(color: azulITZ, width: 4),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: azulITZ,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.school, color: blanco, size: 20),
          ),
          sb13,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Materia: ${asistencia['materiaId']}', style: subtitulo),
                sb5,
                Text(
                    'Hora: ${horaRegistro.hour.toString().padLeft(2, '0')}:${horaRegistro.minute.toString().padLeft(2, '0')}',
                    style: texto.copyWith(color: grisOscuro)),
              ],
            ),
          ),
          Icon(
            asistencia['presente'] ? Icons.check_circle : Icons.cancel,
            color: asistencia['presente'] ? Colors.green : Colors.red,
            size: 30,
          ),
        ],
      ),
    );
  }
}

class RetroalimentacionPage extends StatefulWidget {
  final String estudianteId;

  RetroalimentacionPage({required this.estudianteId});

  @override
  _RetroalimentacionPageState createState() => _RetroalimentacionPageState();
}

class _RetroalimentacionPageState extends State<RetroalimentacionPage> {
  final TextEditingController _feedbackController = TextEditingController();
  String _selectedMateria = '';
  List<String> _materias = [];
  int _calificacion = 5;

  @override
  void initState() {
    super.initState();
    _loadMaterias();
  }

  Future<void> _loadMaterias() async {
    setState(() {
      _materias = ['Matemáticas', 'Física', 'Química', 'Historia', 'Inglés'];
      if (_materias.isNotEmpty) _selectedMateria = _materias[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              sb20,
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: gris.withOpacity(0.2),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.rate_review, color: azulITZ),
                        sb10,
                        Text('Nueva Retroalimentación',
                            style: subtitulo.copyWith(fontSize: 18)),
                      ],
                    ),
                    sb25,
                    Text('Materia:',
                        style: texto.copyWith(fontWeight: FontWeight.w600)),
                    sb10,
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                        color: azulClaro,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: azulITZ.withOpacity(0.3)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedMateria.isEmpty
                              ? null
                              : _selectedMateria,
                          onChanged: (value) {
                            setState(() {
                              _selectedMateria = value ?? '';
                            });
                          },
                          items: _materias.map((materia) {
                            return DropdownMenuItem(
                              value: materia,
                              child: Text(materia, style: texto),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    sb25,
                    Text('Calificación:',
                        style: texto.copyWith(fontWeight: FontWeight.w600)),
                    sb13,
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: azulClaro,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _calificacion = index + 1;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: Icon(
                                Icons.star,
                                size: 45,
                                color:
                                    index < _calificacion ? Colors.amber : gris,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    sb25,
                    Text('Comentarios:',
                        style: texto.copyWith(fontWeight: FontWeight.w600)),
                    sb10,
                    Container(
                      decoration: BoxDecoration(
                        color: azulClaro,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: azulITZ.withOpacity(0.3)),
                      ),
                      child: TextField(
                        controller: _feedbackController,
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText: 'Escribe tus comentarios sobre la clase...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(20),
                        ),
                        style: texto,
                      ),
                    ),
                    sb25,
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: azulITZ,
                          padding: EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 8,
                        ),
                        onPressed: _enviarRetroalimentacion,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send, color: blanco),
                            sb10,
                            Text(
                              'Enviar Retroalimentación',
                              style: TextStyle(
                                  color: blanco,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              sb25,
              _buildHistorialRetroalimentacion(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _enviarRetroalimentacion() async {
    if (_selectedMateria.isEmpty || _feedbackController.text.trim().isEmpty) {
      _showErrorDialog('Por favor completa todos los campos');
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('Retroalimentaciones').add({
        'estudianteId': widget.estudianteId,
        'materia': _selectedMateria,
        'calificacion': _calificacion,
        'comentarios': _feedbackController.text.trim(),
        'fecha': DateTime.now(),
      });

      _feedbackController.clear();
      setState(() {
        _calificacion = 5;
      });

      _showSuccessDialog('¡Retroalimentación enviada correctamente!');
    } catch (e) {
      _showErrorDialog('Error al enviar retroalimentación: $e');
    }
  }

  Widget _buildHistorialRetroalimentacion() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gris.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history, color: azulITZ),
              sb10,
              Text('Historial de Retroalimentaciones',
                  style: subtitulo.copyWith(fontSize: 18)),
            ],
          ),
          sb20,
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Retroalimentaciones')
                .where('estudianteId', isEqualTo: widget.estudianteId)
                .orderBy('fecha', descending: true)
                .limit(5)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(azulITZ),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: azulClaro,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: azulITZ),
                      sb10,
                      Text('No hay retroalimentaciones anteriores',
                          style: texto),
                    ],
                  ),
                );
              }

              return Column(
                children: snapshot.data!.docs.map((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  DateTime fecha = (data['fecha'] as Timestamp).toDate();

                  return Container(
                    margin: EdgeInsets.only(bottom: 15),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [azulClaro, azulClaro.withOpacity(0.5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      border: Border(
                        left: BorderSide(color: azulITZ, width: 4),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(data['materia'],
                                  style: subtitulo.copyWith(fontSize: 16)),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: azulITZ,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(5, (index) {
                                  return Icon(
                                    Icons.star,
                                    size: 14,
                                    color: index < data['calificacion']
                                        ? Colors.amber
                                        : blanco.withOpacity(0.5),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                        sb10,
                        Text(data['comentarios'], style: texto),
                        sb10,
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 16, color: grisOscuro),
                            sb5,
                            Text(
                              '${fecha.day}/${fecha.month}/${fecha.year} - ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(color: grisOscuro, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            sb10,
            Text('Éxito', style: subtitulo),
          ],
        ),
        content: Text(message, style: texto),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK',
                style: TextStyle(color: azulITZ, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            sb10,
            Text('Error', style: subtitulo),
          ],
        ),
        content: Text(message, style: texto),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK',
                style: TextStyle(color: azulITZ, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }
}
