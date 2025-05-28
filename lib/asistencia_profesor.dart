import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'componentes/tema.dart';
import 'dart:typed_data'; // <-- IMPORTANTE
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final classes = ['Matemáticas', 'Programación', 'Base de Datos', 'Software'];
  String selectedClass = 'Programación';

  // Mock attendance data
  int attendanceToday = 0;
  int attendanceWeek = 0;
  int attendanceMonth = 0;
  int attendancePrevMonth = 0;

  @override
  void initState() {
    super.initState();
    fetchAttendanceData();
  }

  Future<void> fetchAttendanceData() async {
    setState(() {
      attendanceToday = 12;
      attendanceWeek = 54;
      attendanceMonth = 210;
      attendancePrevMonth = 198;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Asistencia'),
        backgroundColor: azulOscuro,
        elevation: 0,
      ),
      body: Container(
        color: azulClaro.withOpacity(0.08),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Clase actual:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: azulOscuro,
                        ),
                      ),
                      DropdownButton<String>(
                        value: selectedClass,
                        items: classes
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedClass = value!;
                            fetchAttendanceData();
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ───────────────────────────────────────────
                  // Estadísticas de asistencia
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _buildStatCard('Hoy', attendanceToday,
                                  Icons.today, Colors.blue),
                              _buildStatCard('Semana', attendanceWeek,
                                  Icons.calendar_view_week, Colors.green),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildStatCard('Mes', attendanceMonth,
                                  Icons.calendar_month, Colors.orange),
                              _buildStatCard(
                                  'Mes anterior',
                                  attendancePrevMonth,
                                  Icons.history,
                                  Colors.purple),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  const SizedBox(height: 32),
                  // ───────────────────────────────────────────
                  // Acciones principales
                  Text(
                    'Acciones rápidas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: azulOscuro,
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    height: 110,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      children: [
                        const SizedBox(width: 0),
                        _buildActionButton(
                          icon: Icons.qr_code,
                          label: 'Generar QR',
                          color: Colors.blue,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    QRGeneratorPage(className: selectedClass),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        _buildActionButton(
                          icon: Icons.person_add_alt_1,
                          label: 'Añadir estudiantes',
                          color: Colors.green,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddStudentsPage(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        _buildActionButton(
                          icon: Icons.bar_chart,
                          label: 'Ver retroalimentación',
                          color: Colors.orange,
                          onTap: () {Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FeedbackPage(),
                          ),
                        );
                      },
                        ),
                        const SizedBox(width: 16),
                        _buildActionButton(
                          icon: Icons.description,
                          label: 'Reporte de asistencia',
                          color: Colors.purple,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AttendanceReport(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ───────────────────────────────────────────
                  // Lista de estudiantes (igual que antes)
                  Text(
                    'Lista rápida de estudiantes (ejemplo)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: azulOscuro,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 300,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: azulClaro,
                            child:
                                const Icon(Icons.person, color: Colors.white),
                          ),
                          title: const Text('Juan Pérez'),
                          subtitle: const Text('18320100'),
                          trailing:
                              Icon(Icons.check_circle, color: Colors.green),
                        ),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: azulClaro,
                            child:
                                const Icon(Icons.person, color: Colors.white),
                          ),
                          title: const Text('María González'),
                          subtitle: const Text('18320101'),
                          trailing: Icon(Icons.cancel, color: Colors.red),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 150,
          height: 90,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildStatCard(String label, int value, IconData icon, Color color) {
  return Expanded(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
                fontSize: 14, color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );
}

Widget _buildActionButton({
  required IconData icon,
  required String label,
  required Color color,
  required VoidCallback onTap,
}) {
  return Material(
    color: color.withOpacity(0.12),
    borderRadius: BorderRadius.circular(12),
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 150,
        height: 90,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

// ───────────────────────────────────────────────────────────────
// Add Students Page
class AddStudentsPage extends StatefulWidget {
  const AddStudentsPage({super.key});

  @override
  _AddStudentsPageState createState() => _AddStudentsPageState();
}

class _AddStudentsPageState extends State<AddStudentsPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final idController = TextEditingController();

  List<Map<String, dynamic>> students = [
    {'id': '18320100', 'name': 'Juan Pérez', 'present': false},
    {'id': '18320101', 'name': 'María González', 'present': false},
    {'id': '18320102', 'name': 'Carlos Rodríguez', 'present': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Estudiantes'),
        backgroundColor: azulOscuro,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del estudiante',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese un nombre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: idController,
                    decoration: const InputDecoration(
                      labelText: 'Número de control',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese un número de control';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            students.add({
                              'id': idController.text,
                              'name': nameController.text,
                              'present': false,
                            });
                            nameController.clear();
                            idController.clear();
                          });
                        }
                      },
                      //here save the data pa la bd
                      style: ElevatedButton.styleFrom(
                        backgroundColor: azul,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'Añadir Estudiante',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Lista de Estudiantes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(students[index]['name']),
                      subtitle: Text('ID: ${students[index]['id']}'),
                      trailing: Switch(
                        value: students[index]['present'],
                        onChanged: (value) {
                          setState(() {
                            students[index]['present'] = value;
                          });
                        },
                        activeColor: azul,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Asistencia guardada')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: azul,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Guardar Asistencia',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    super.dispose();
  }
}

// ───────────────────────────────────────────────────────────────
// QR Code Generator Page (sin cambios)
class QRGeneratorPage extends StatefulWidget {
  final String className;

  const QRGeneratorPage({super.key, required this.className});

  @override
  _QRGeneratorPageState createState() => _QRGeneratorPageState();
}

class _QRGeneratorPageState extends State<QRGeneratorPage> {
  String qrData = '';
  final azul = const Color.fromARGB(255, 33, 150, 243);

  @override
  void initState() {
    super.initState();
    // Generar datos del QR con nombre de clase y timestamp
    final now = DateTime.now();
    qrData = 'class:${widget.className}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Código QR'),
        backgroundColor: azulOscuro,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Clase: ${widget.className}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 250.0,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Los estudiantes pueden escanear este código para registrar su asistencia',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // compartirías el QR
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Compartiendo código QR')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: azul,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  icon: const Icon(Icons.share, color: Colors.white),
                  label: const Text(
                    'Compartir Código QR',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
class AttendanceReport extends StatefulWidget {
  const AttendanceReport({super.key});

  @override
  State<AttendanceReport> createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxHeight: 850, maxWidth: 390),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(199, 237, 238, 245),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          AppBar(
                            title: const Text('Reporte de Asistencia'),
                            foregroundColor: Colors.white,
                            backgroundColor: azulOscuro,
                          ),
                          //Padding(padding: const EdgeInsets.all(15.0)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'images/TecNM.png',
                                width: 100,
                              ),
                              SizedBox(width: 20),
                              Image.asset(
                                'images/ITZ.png',
                                width: 100,
                              ),
                            ],
                          ),
                          Text('INSTITUTO TECNOLOGICO DE ZACATEPEC ITZ',
                              style: GoogleFonts.arimo(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              )),
                          Padding(padding: const EdgeInsets.all(10.0)),
                          Text(
                            'DOCENTE: ALEJANDRA CALYPSO ',
                            style: GoogleFonts.arimo(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(padding: const EdgeInsets.all(10.0)),
                          Text(
                            'ASIGNATURA: INGENIERIA DE SOFTWARE',
                            style: GoogleFonts.arimo(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(padding: const EdgeInsets.all(10.0)),
                          Text(
                            'PERIODO: ENERO-FEBRERO 2025',
                            style: GoogleFonts.arimo(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(padding: const EdgeInsets.all(10.0)),
                          Text(
                            'GRUPO: XA',
                            style: GoogleFonts.arimo(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(padding: const EdgeInsets.all(10.0)),
                          Text(
                            'Generado el: ${DateTime.now().toString().substring(0, 16)}',
                            style: GoogleFonts.arimo(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(padding: const EdgeInsets.all(10.0)),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: [
                                DataColumn(label: Text('Numero Control')),
                                DataColumn(label: Text('Nombre Alumno')),
                                DataColumn(label: Text('20-MAY')),
                                DataColumn(label: Text('15-MAY')),
                                DataColumn(label: Text('16-MAY')),
                                DataColumn(label: Text('% Asistencia')),
                                DataColumn(label: Text('Observaciones')),
                              ],
                              rows: [
                                DataRow(cells: [
                                  DataCell(Text('2090597')),
                                  DataCell(Text('Yamil Barbosa')),
                                  DataCell(Text('✓')),
                                  DataCell(Text('✗')),
                                  DataCell(Text('✓')),
                                  DataCell(Text('66,67%')),
                                  DataCell(Text('')),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('2090598')),
                                  DataCell(Text('Ana García')),
                                  DataCell(Text('✓')),
                                  DataCell(Text('✓')),
                                  DataCell(Text('✗')),
                                  DataCell(Text('66,67%')),
                                  DataCell(Text('')),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('2090599')),
                                  DataCell(Text('Carlos López')),
                                  DataCell(Text('✗')),
                                  DataCell(Text('✓')),
                                  DataCell(Text('✓')),
                                  DataCell(Text('66,67%')),
                                  DataCell(Text('')),
                                ]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}

class FeedbackPage extends StatefulWidget {
  final String? initialSubject; // Para abrir directamente en una materia
  
  const FeedbackPage({super.key, this.initialSubject});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedFilter = 'Todos';
  final List<String> filters = ['Todos', 'Opiniones', 'Dudas', 'Sugerencias', 'Quejas'];
  final List<String> subjects = ['Todas', 'Matemáticas', 'Programación', 'Base de Datos', 'Software'];
  
  // Mock data de retroalimentación
  List<Map<String, dynamic>> feedbackData = [
    {
      'id': '1',
      'studentName': 'Juan Pérez',
      'studentId': '18320100',
      'type': 'Opiniones',
      'message': 'Me gusta mucho la clase de programación, especialmente cuando vemos ejemplos prácticos. Los ejercicios son muy útiles.',
      'date': '2025-05-27 10:30',
      'rating': 5,
      'className': 'Programación',
      'isAnonymous': false,
    },
    {
      'id': '2',
      'studentName': 'Anónimo',
      'studentId': '',
      'type': 'Dudas',
      'message': '¿Podrían explicar mejor el tema de recursividad? Me cuesta trabajo entender los casos base.',
      'date': '2025-05-27 09:15',
      'rating': null,
      'className': 'Programación',
      'isAnonymous': true,
    },
    {
      'id': '3',
      'studentName': 'María González',
      'studentId': '18320101',
      'type': 'Sugerencias',
      'message': 'Sería genial si pudiéramos tener más tiempo para los laboratorios prácticos.',
      'date': '2025-05-26 16:45',
      'rating': 4,
      'className': 'Base de Datos',
      'isAnonymous': false,
    },
    {
      'id': '4',
      'studentName': 'Carlos Rodríguez',
      'studentId': '18320102',
      'type': 'Opiniones',
      'message': 'Las clases están muy bien estructuradas. Me ayuda mucho la forma en que explican los conceptos.',
      'date': '2025-05-26 14:20',
      'rating': 5,
      'className': 'Software',
      'isAnonymous': false,
    },
    {
      'id': '5',
      'studentName': 'Anónimo',
      'studentId': '',
      'type': 'Quejas',
      'message': 'El ritmo de la clase es un poco rápido, a veces no alcanzamos a tomar apuntes.',
      'date': '2025-05-25 11:10',
      'rating': 2,
      'className': 'Matemáticas',
      'isAnonymous': true,
    },
    {
      'id': '6',
      'studentName': 'Ana López',
      'studentId': '18320103',
      'type': 'Dudas',
      'message': '¿Pueden proporcionar más ejemplos del tema de normalización en bases de datos?',
      'date': '2025-05-25 08:30',
      'rating': null,
      'className': 'Base de Datos',
      'isAnonymous': false,
    },
    {
      'id': '7',
      'studentName': 'Luis Martín',
      'studentId': '18320104',
      'type': 'Opiniones',
      'message': 'Los ejercicios de matemáticas están muy bien planteados, me ayudan a entender mejor.',
      'date': '2025-05-24 15:20',
      'rating': 4,
      'className': 'Matemáticas',
      'isAnonymous': false,
    },
    {
      'id': '8',
      'studentName': 'Sofia Cruz',
      'studentId': '18320105',
      'type': 'Sugerencias',
      'message': 'Podrían usar más herramientas visuales para explicar los algoritmos de software.',
      'date': '2025-05-24 11:45',
      'rating': 3,
      'className': 'Software',
      'isAnonymous': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: subjects.length, vsync: this);
    
    // Si se pasa una materia inicial, cambiar al tab correspondiente
    if (widget.initialSubject != null) {
      int initialIndex = subjects.indexOf(widget.initialSubject!);
      if (initialIndex != -1) {
        _tabController.index = initialIndex;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> getFilteredFeedback(String subject) {
    List<Map<String, dynamic>> subjectFiltered;
    
    // Filtrar por materia
    if (subject == 'Todas') {
      subjectFiltered = feedbackData;
    } else {
      subjectFiltered = feedbackData.where((feedback) => feedback['className'] == subject).toList();
    }
    
    // Filtrar por tipo
    if (selectedFilter == 'Todos') {
      return subjectFiltered;
    }
    return subjectFiltered.where((feedback) => feedback['type'] == selectedFilter).toList();
  }

  Map<String, int> getSubjectStats(String subject) {
    List<Map<String, dynamic>> subjectData;
    if (subject == 'Todas') {
      subjectData = feedbackData;
    } else {
      subjectData = feedbackData.where((feedback) => feedback['className'] == subject).toList();
    }
    
    return {
      'total': subjectData.length,
      'opiniones': subjectData.where((f) => f['type'] == 'Opiniones').length,
      'dudas': subjectData.where((f) => f['type'] == 'Dudas').length,
      'sugerencias': subjectData.where((f) => f['type'] == 'Sugerencias').length,
      'quejas': subjectData.where((f) => f['type'] == 'Quejas').length,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retroalimentación de Estudiantes'),
        backgroundColor: azulOscuro,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: subjects.map((subject) => Tab(text: subject)).toList(),
        ),
      ),
      body: Container(
        color: azulClaro.withOpacity(0.08),
        child: TabBarView(
          controller: _tabController,
          children: subjects.map((subject) => _buildSubjectView(subject)).toList(),
        ),
      ),
    );
  }

  Widget _buildSubjectView(String subject) {
    final stats = getSubjectStats(subject);
    final filteredData = getFilteredFeedback(subject);
    
    return Column(
      children: [
        // Header con estadísticas específicas de la materia
        Container(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (subject != 'Todas')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        subject,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: azulOscuro,
                        ),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('Total', stats['total']!, Icons.comment, azul),
                      _buildStatItem('Opiniones', stats['opiniones']!, Icons.thumb_up, Colors.green),
                      _buildStatItem('Dudas', stats['dudas']!, Icons.help, Colors.orange),
                      _buildStatItem('Sugerencias', stats['sugerencias']!, Icons.lightbulb, Colors.blue),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Filtros por tipo
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            itemBuilder: (context, index) {
              final filter = filters[index];
              final isSelected = filter == selectedFilter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      selectedFilter = filter;
                    });
                  },
                  selectedColor: azul.withOpacity(0.2),
                  checkmarkColor: azul,
                  labelStyle: TextStyle(
                    color: isSelected ? azul : null,
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                ),
              );
            },
          ),
        ),
        
        // Lista de retroalimentación filtrada
        Expanded(
          child: filteredData.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'No hay retroalimentación para mostrar',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    final feedback = filteredData[index];
                    return _buildFeedbackCard(feedback);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, int count, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackCard(Map<String, dynamic> feedback) {
    Color typeColor = _getTypeColor(feedback['type']);
    IconData typeIcon = _getTypeIcon(feedback['type']);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header del feedback
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(typeIcon, size: 16, color: typeColor),
                      const SizedBox(width: 4),
                      Text(
                        feedback['type'],
                        style: TextStyle(
                          color: typeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (feedback['rating'] != null)
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < feedback['rating'] ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      );
                    }),
                  ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Mensaje de retroalimentación
            Text(
              feedback['message'],
              style: const TextStyle(
                fontSize: 16,
                height: 1.4,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Footer con información del estudiante
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: azulClaro,
                  child: Icon(
                    feedback['isAnonymous'] ? Icons.person_outline : Icons.person,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feedback['studentName'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      if (!feedback['isAnonymous'] && feedback['studentId'].isNotEmpty)
                        Text(
                          feedback['studentId'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      feedback['className'],
                      style: TextStyle(
                        color: azul,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      _formatDate(feedback['date']),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Opiniones':
        return Colors.green;
      case 'Dudas':
        return Colors.orange;
      case 'Sugerencias':
        return Colors.blue;
      case 'Quejas':
        return Colors.red;
      default:
        return azul;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Opiniones':
        return Icons.thumb_up;
      case 'Dudas':
        return Icons.help;
      case 'Sugerencias':
        return Icons.lightbulb;
      case 'Quejas':
        return Icons.warning;
      default:
        return Icons.comment;
    }
  }

  String _formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    return '${date.day}/${date.month} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
