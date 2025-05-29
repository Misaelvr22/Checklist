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
      print('Error loading student data: $e');
    }
  }

  List<Widget> get _pages => [
        PerfilEstudiante(estudianteData: estudianteData),
        EscanerQR(),
        CalendarioAsistencia(estudianteId: uid),
        RetroalimentacionPage(estudianteId: uid),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blanco,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 800),
          child: _pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: azulOscuro,
        selectedItemColor: blanco,
        unselectedItemColor: blanco, // <-- todos los íconos blancos
        selectedIconTheme: IconThemeData(color: blanco),
        unselectedIconTheme: IconThemeData(color: blanco),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: azulOscuro,
        centerTitle: true,
        title: Text('Mi Perfil', style: titulo.copyWith(color: blanco)),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: blanco),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
        iconTheme: IconThemeData(color: blanco),
      ),
      backgroundColor: blanco,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sb30,
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: gris.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: azulITZ,
                    child: Icon(Icons.person, size: 50, color: blanco),
                  ),
                  sb25,
                  _buildInfoCard('Nombre', estudianteData?['Nombre'] ?? 'N/A'),
                  sb10,
                  _buildInfoCard('Correo',
                      estudianteData?['CorreoInstitucional'] ?? 'N/A'),
                  sb10,
                  _buildInfoCard('Número de Control',
                      estudianteData?['NumeroControl'] ?? 'N/A'),
                  sb10,
                  _buildInfoCard(
                      'Carrera', estudianteData?['Carrera'] ?? 'N/A'),
                  sb10,
                  _buildInfoCard('Semestre',
                      estudianteData?['Semestre']?.toString() ?? 'N/A'),
                ],
              ),
            ),
            sb25,
            _buildStatsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      decoration: BoxDecoration(
        color: azulClaro,
        borderRadius: BorderRadius.circular(10),
        border: Border(
          left: BorderSide(color: azulITZ, width: 4),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: subtitulo),
          Flexible(
            child: Text(value, style: texto, textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: gris.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Estadísticas', style: subtitulo),
          sb13,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Materias\nInscritas', '5', azulITZ),
              _buildStatItem('Asistencia\nPromedio', '85%', azul),
              _buildStatItem('Clases\nHoy', '3', azulOscLight),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(value,
                style: TextStyle(
                    color: blanco, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
        sb10,
        Text(label, style: texto, textAlign: TextAlign.center),
      ],
    );
  }
}

class EscanerQR extends StatefulWidget {
  @override
  _EscanerQRState createState() => _EscanerQRState();
}

class _EscanerQRState extends State<EscanerQR> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escanear QR', style: TextStyle(color: blanco)),
        backgroundColor: azulOscuro,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: azulOscuro, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('Apunta la cámara hacia el código QR',
                      style: subtitulo, textAlign: TextAlign.center),
                  sb13,
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: azulITZ,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: isScanning
                          ? null
                          : () {
                              controller?.resumeCamera();
                              setState(() {
                                isScanning = true;
                              });
                            },
                      child: Text(
                        isScanning ? 'Escaneando...' : 'Iniciar Escaneo',
                        style: TextStyle(color: blanco, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      _handleQRScan(scanData.code ?? '');
    });
  }

  Future<void> _handleQRScan(String qrData) async {
    setState(() {
      isScanning = false;
    });

    controller?.pauseCamera();

    try {
      // Procesar el QR escaneado
      await _registrarAsistencia(qrData);

      _showSuccessDialog('Asistencia registrada correctamente');
    } catch (e) {
      _showErrorDialog('Error al registrar asistencia: $e');
    }
  }

  Future<void> _registrarAsistencia(String qrData) async {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    // Parsear datos del QR (formato: "materia_id,clase_fecha,profesor_id")
    List<String> qrParts = qrData.split(',');
    if (qrParts.length != 3) throw Exception('Código QR inválido');

    String materiaId = qrParts[0];
    String claseFecha = qrParts[1];
    String profesorId = qrParts[2];

    await FirebaseFirestore.instance
        .collection('Asistencias')
        .doc('$uid\_$materiaId\_$claseFecha')
        .set({
      'estudianteId': uid,
      'materiaId': materiaId,
      'profesorId': profesorId,
      'fecha': DateTime.now(),
      'presente': true,
      'horaRegistro': DateTime.now(),
    });
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Éxito', style: subtitulo),
        content: Text(message, style: texto),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: azulITZ)),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error', style: subtitulo),
        content: Text(message, style: texto),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: azulITZ)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sb30,
          Center(
            child: Text('Mi Asistencia', style: titulo),
          ),
          sb25,
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: gris.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 5),
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
                titleTextStyle: subtitulo,
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
    );
  }

  Widget _buildAsistenciasDia() {
    DateTime key =
        DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    List<Map<String, dynamic>> asistenciasDia = _asistencias[key] ?? [];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: gris.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'Asistencias del ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
              style: subtitulo),
          sb13,
          if (asistenciasDia.isEmpty)
            Text('No hay asistencias registradas para este día', style: texto)
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
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: azulClaro,
        borderRadius: BorderRadius.circular(10),
        border: Border(
          left: BorderSide(color: azulITZ, width: 4),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Materia: ${asistencia['materiaId']}', style: subtitulo),
                sb5,
                Text(
                    'Hora: ${horaRegistro.hour.toString().padLeft(2, '0')}:${horaRegistro.minute.toString().padLeft(2, '0')}',
                    style: texto),
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
    // Cargar materias del estudiante (esto dependería de tu estructura de datos)
    setState(() {
      _materias = ['Matemáticas', 'Física', 'Química', 'Historia', 'Inglés'];
      if (_materias.isNotEmpty) _selectedMateria = _materias[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sb30,
          Center(
            child: Text('Retroalimentación', style: titulo),
          ),
          sb25,
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: gris.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nueva Retroalimentación', style: subtitulo),
                sb25,
                Text('Materia:', style: texto),
                sb10,
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: azulClaro,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedMateria.isEmpty ? null : _selectedMateria,
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
                Text('Calificación:', style: texto),
                sb10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _calificacion = index + 1;
                        });
                      },
                      child: Icon(
                        Icons.star,
                        size: 40,
                        color: index < _calificacion ? Colors.amber : gris,
                      ),
                    );
                  }),
                ),
                sb25,
                Text('Comentarios:', style: texto),
                sb10,
                Container(
                  decoration: BoxDecoration(
                    color: azulClaro,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _feedbackController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Escribe tus comentarios aquí...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
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
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _enviarRetroalimentacion,
                    child: Text(
                      'Enviar Retroalimentación',
                      style: TextStyle(color: blanco, fontSize: 16),
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

      _showSuccessDialog('Retroalimentación enviada correctamente');
    } catch (e) {
      _showErrorDialog('Error al enviar retroalimentación: $e');
    }
  }

  Widget _buildHistorialRetroalimentacion() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: gris.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Historial de Retroalimentaciones', style: subtitulo),
          sb13,
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Retroalimentaciones')
                .where('estudianteId', isEqualTo: widget.estudianteId)
                .orderBy('fecha', descending: true)
                .limit(5)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Text('No hay retroalimentaciones anteriores',
                    style: texto);
              }

              return Column(
                children: snapshot.data!.docs.map((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  DateTime fecha = (data['fecha'] as Timestamp).toDate();

                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: azulClaro,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(data['materia'], style: subtitulo),
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  Icons.star,
                                  size: 16,
                                  color: index < data['calificacion']
                                      ? Colors.amber
                                      : gris,
                                );
                              }),
                            ),
                          ],
                        ),
                        sb5,
                        Text(data['comentarios'], style: texto),
                        sb5,
                        Text(
                          '${fecha.day}/${fecha.month}/${fecha.year}',
                          style: TextStyle(color: grisOscuro, fontSize: 12),
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
        title: Text('Éxito', style: subtitulo),
        content: Text(message, style: texto),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: azulITZ)),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error', style: subtitulo),
        content: Text(message, style: texto),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: azulITZ)),
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
