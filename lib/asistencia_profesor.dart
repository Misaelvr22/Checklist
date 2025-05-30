import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'auth/inicio_sesion.dart';
import 'componentes/tema.dart';
import 'dart:typed_data'; // <-- IMPORTANTE
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class PaginaProfesor extends StatefulWidget {
  const PaginaProfesor({super.key});

  @override
  _PaginaProfesorState createState() => _PaginaProfesorState();
}

class _PaginaProfesorState extends State<PaginaProfesor> {
  final classes = [
    'Matemáticas',
    'Programación',
    'Base de Datos',
    'Ingenieria de Software'
  ];
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
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: CircleAvatar(
              backgroundColor: Colors.blue[600],
              radius: 16,
              child: Text(
                'A',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => InicioSesion()),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: Text('Cerrar sesión'),
              ),
            ],
          ),
        ],
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
                                builder: (context) => AddClassScreen(),
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
                          onTap: () {
                            Navigator.push(
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
                                builder: (context) =>
                                    const AttendanceReportScreen(),
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
        foregroundColor: Colors.white,
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
        foregroundColor: Colors.white,
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

class FeedbackPage extends StatefulWidget {
  final String? initialSubject; // Para abrir directamente en una materia

  const FeedbackPage({super.key, this.initialSubject});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedFilter = 'Todos';
  final List<String> filters = [
    'Todos',
    'Opiniones',
    'Dudas',
    'Sugerencias',
    'Quejas'
  ];
  final List<String> subjects = [
    'Todas',
    'Matemáticas',
    'Programación',
    'Base de Datos',
    'Ingenieria de Software'
  ];

  // Mock data de retroalimentación
  List<Map<String, dynamic>> feedbackData = [
    {
      'id': '1',
      'studentName': 'Juan Pérez',
      'studentId': '18320100',
      'type': 'Opiniones',
      'message':
          'Me gusta mucho la clase de programación, especialmente cuando vemos ejemplos prácticos. Los ejercicios son muy útiles.',
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
      'message':
          '¿Podrían explicar mejor el tema de recursividad? Me cuesta trabajo entender los casos base.',
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
      'message':
          'Sería genial si pudiéramos tener más tiempo para los laboratorios prácticos.',
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
      'message':
          'Las clases están muy bien estructuradas. Me ayuda mucho la forma en que explican los conceptos.',
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
      'message':
          'El ritmo de la clase es un poco rápido, a veces no alcanzamos a tomar apuntes.',
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
      'message':
          '¿Pueden proporcionar más ejemplos del tema de normalización en bases de datos?',
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
      'message':
          'Los ejercicios de matemáticas están muy bien planteados, me ayudan a entender mejor.',
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
      'message':
          'Podrían usar más herramientas visuales para explicar los algoritmos de software.',
      'date': '2025-05-24 11:45',
      'rating': 3,
      'className': 'Ingenieria de Software',
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
      subjectFiltered = feedbackData
          .where((feedback) => feedback['className'] == subject)
          .toList();
    }

    // Filtrar por tipo
    if (selectedFilter == 'Todos') {
      return subjectFiltered;
    }
    return subjectFiltered
        .where((feedback) => feedback['type'] == selectedFilter)
        .toList();
  }

  Map<String, int> getSubjectStats(String subject) {
    List<Map<String, dynamic>> subjectData;
    if (subject == 'Todas') {
      subjectData = feedbackData;
    } else {
      subjectData = feedbackData
          .where((feedback) => feedback['className'] == subject)
          .toList();
    }

    return {
      'total': subjectData.length,
      'opiniones': subjectData.where((f) => f['type'] == 'Opiniones').length,
      'dudas': subjectData.where((f) => f['type'] == 'Dudas').length,
      'sugerencias':
          subjectData.where((f) => f['type'] == 'Sugerencias').length,
      'quejas': subjectData.where((f) => f['type'] == 'Quejas').length,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retroalimentación de Estudiantes'),
        backgroundColor: azulOscuro,
        foregroundColor: Colors.white,
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
          children:
              subjects.map((subject) => _buildSubjectView(subject)).toList(),
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
                      _buildStatItem(
                          'Total', stats['total']!, Icons.comment, azul),
                      _buildStatItem('Opiniones', stats['opiniones']!,
                          Icons.thumb_up, Colors.green),
                      _buildStatItem(
                          'Dudas', stats['dudas']!, Icons.help, Colors.orange),
                      _buildStatItem('Sugerencias', stats['sugerencias']!,
                          Icons.lightbulb, Colors.blue),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                        index < feedback['rating']
                            ? Icons.star
                            : Icons.star_border,
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
                    feedback['isAnonymous']
                        ? Icons.person_outline
                        : Icons.person,
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
                      if (!feedback['isAnonymous'] &&
                          feedback['studentId'].isNotEmpty)
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

//______________________

class AttendanceReportPDF {
  // Modelo de datos para el alumno
  static List<Map<String, dynamic>> studentsData = [
    {
      'numeroControl': '2090597',
      'nombreAlumno': 'Yamil Barbosa',
      'asistencias': {'20-MAY': true, '15-MAY': false, '16-MAY': true},
      'porcentajeAsistencia': '66,67%',
      'observaciones': '',
    },
    {
      'numeroControl': '2090598',
      'nombreAlumno': 'Ana García',
      'asistencias': {'20-MAY': true, '15-MAY': true, '16-MAY': false},
      'porcentajeAsistencia': '66,67%',
      'observaciones': '',
    },
    {
      'numeroControl': '2090599',
      'nombreAlumno': 'Carlos López',
      'asistencias': {'20-MAY': false, '15-MAY': true, '16-MAY': true},
      'porcentajeAsistencia': '66,67%',
      'observaciones': '',
    },
  ];

  static Future<Uint8List> generateAttendanceReport() async {
    final pdf = pw.Document();

    // Crear el PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Encabezado del reporte
            _buildHeader(),
            pw.SizedBox(height: 20),

            // Información general
            _buildGeneralInfo(),
            pw.SizedBox(height: 20),

            // Tabla de asistencia
            _buildAttendanceTable(),
            pw.SizedBox(height: 20),

            // Resumen estadístico
            _buildStatisticsSummary(),
            pw.SizedBox(height: 20),

            // Pie de página
          ];
        },
      ),
    );

    // Retornar los bytes del PDF
    return pdf.save();
  }

  static pw.Widget _buildHeader() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue100,
        border: pw.Border.all(color: PdfColors.blue300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            'REPORTE DE ASISTENCIA',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Control de Asistencia Estudiantil',
            style: pw.TextStyle(fontSize: 14, color: PdfColors.blue600),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildGeneralInfo() {
    final now = DateTime.now();
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Asignatura:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text('INGENIERIA DE SOWFTA'),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'GRUPO:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text('XA'),
                ],
              ),
            ],
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Fecha de generación:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text('${now.day}/${now.month}/${now.year}'),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Total de estudiantes:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text('${studentsData.length}'),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Período:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text('Semana: ${AutomaticWeekPDF.getCurrentWeekRange()}')
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildAttendanceTable() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Registro de Asistencias',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue800,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey600),
          columnWidths: const {
            0: pw.FixedColumnWidth(80),
            1: pw.FlexColumnWidth(3),
            2: pw.FixedColumnWidth(60),
            3: pw.FixedColumnWidth(60),
            4: pw.FixedColumnWidth(60),
            5: pw.FixedColumnWidth(80),
            6: pw.FlexColumnWidth(2),
          },
          children: [
            // Encabezado de la tabla
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.blue800),
              children: [
                _buildTableCell('N° Control', isHeader: true),
                _buildTableCell('Nombre Alumno', isHeader: true),
                _buildTableCell('20-MAY', isHeader: true),
                _buildTableCell('15-MAY', isHeader: true),
                _buildTableCell('16-MAY', isHeader: true),
                _buildTableCell('% Asist.', isHeader: true),
                _buildTableCell('Observaciones', isHeader: true),
              ],
            ),
            // Filas de datos
            ...studentsData.asMap().entries.map((entry) {
              final index = entry.key;
              final student = entry.value;
              return pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                ),
                children: [
                  _buildTableCell(student['numeroControl'] ?? ''),
                  _buildTableCell(student['nombreAlumno'] ?? ''),
                  _buildTableCell(
                    student['asistencias']['20-MAY'] == true ? 'X' : '-',
                  ),
                  _buildTableCell(
                    student['asistencias']['15-MAY'] == true ? 'X' : '-',
                  ),
                  _buildTableCell(
                    student['asistencias']['16-MAY'] == true ? 'X' : '-',
                  ),
                  _buildTableCell(student['porcentajeAsistencia'] ?? ''),
                  _buildTableCell(student['observaciones'] ?? ''),
                ],
              );
            })
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 10 : 9,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: isHeader ? PdfColors.white : PdfColors.black,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static pw.Widget _buildStatisticsSummary() {
    // Calcular estadísticas
    int totalStudents = studentsData.length;
    int totalClasses = 3; // 20-MAY, 15-MAY, 16-MAY

    Map<String, int> dailyAttendance = {'20-MAY': 0, '15-MAY': 0, '16-MAY': 0};

    for (var student in studentsData) {
      for (var date in dailyAttendance.keys) {
        if (student['asistencias'][date] == true) {
          dailyAttendance[date] = dailyAttendance[date]! + 1;
        }
      }
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.green50,
        border: pw.Border.all(color: PdfColors.green300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Resumen Estadístico',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green800,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard('Total Estudiantes', '$totalStudents'),
              _buildStatCard('Clases Impartidas', '$totalClasses'),
              _buildStatCard('Promedio Asistencia', '66.67%'),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Asistencia por día:',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          ...dailyAttendance.entries.map(
            (entry) => pw.Text(
              '${entry.key}: ${entry.value}/$totalStudents estudiantes',
            ),
          )
        ],
      ),
    );
  }

  static pw.Widget _buildStatCard(String title, String value) {
    return pw.Column(
      children: [
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.green800,
          ),
        ),
        pw.Text(
          title,
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.green600),
        ),
      ],
    );
  }
}

// Widget Flutter simplificado
class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({Key? key}) : super(key: key);

  @override
  _AttendanceReportScreenState createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  bool isGenerating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte de Asistencia'),
        backgroundColor: azulOscuro,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white38,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxHeight: 850, maxWidth: 390),
              decoration: BoxDecoration(
                color: Color.fromARGB(198, 245, 245, 247),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('images/TecNM.png', width: 100),
                      SizedBox(width: 20),
                      Image.asset('images/ITZ.png', width: 100),
                    ],
                  ),
                  Text(
                    'INSTITUTO TECNOLOGICO DE ZACATEPEC ITZ',
                    style: GoogleFonts.arimo(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                    'ASIGNATURA: IGENIERIA DE SOFTWARE',
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
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(azulITZ),
                        headingTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        columns: const [
                          DataColumn(label: Text('Numero Control')),
                          DataColumn(label: Text('Nombre Alumno')),
                          DataColumn(label: Text('20-MAY')),
                          DataColumn(label: Text('15-MAY')),
                          DataColumn(label: Text('16-MAY')),
                          DataColumn(label: Text('% Asistencia')),
                          DataColumn(label: Text('Observaciones')),
                        ],
                        rows: const [
                          DataRow(
                            cells: [
                              DataCell(Text('2090597')),
                              DataCell(Text('Yamil Barbosa')),
                              DataCell(
                                Text(
                                  '✓',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '✗',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '✓',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(Text('66,67%')),
                              DataCell(Text('')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('2090598')),
                              DataCell(Text('Ana García')),
                              DataCell(
                                Text(
                                  '✓',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '✓',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '✗',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(Text('66,67%')),
                              DataCell(Text('')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('2090599')),
                              DataCell(Text('Carlos López')),
                              DataCell(
                                Text(
                                  '✗',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '✓',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '✓',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(Text('66,67%')),
                              DataCell(Text('')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Botones de acción
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: isGenerating ? null : _previewPDF,
                        icon: isGenerating
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.preview),
                        label: Text(
                            isGenerating ? 'Generando...' : 'Vista Previa'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                      Padding(padding: const EdgeInsets.all(10.0)),
                      ElevatedButton.icon(
                        onPressed: isGenerating ? null : _sharePDF,
                        icon: const Icon(Icons.download),
                        label: const Text('Descargar Reporte de Asistencia'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _previewPDF() async {
    setState(() {
      isGenerating = true;
    });

    try {
      final pdfBytes = await AttendanceReportPDF.generateAttendanceReport();

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vista previa generada exitosamente'),
            backgroundColor: Color.fromARGB(255, 47, 74, 131),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al generar vista previa: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isGenerating = false;
        });
      }
    }
  }

  Future<void> _sharePDF() async {
    setState(() {
      isGenerating = true;
    });

    try {
      final pdfBytes = await AttendanceReportPDF.generateAttendanceReport();

      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: 'reporte_asistencia.pdf',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reporte descargado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al descargar PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isGenerating = false;
        });
      }
    }
  }
}

class AutomaticWeekPDF {
  /// Obtiene el rango de la semana actual en formato "dd-MMM"
  static String getCurrentWeekRange() {
    DateTime now = DateTime.now();

    // Encontrar el lunes de esta semana
    DateTime monday = now.subtract(Duration(days: now.weekday - 1));

    // El viernes de esta semana
    DateTime friday = monday.add(Duration(days: 4));

    // Formato dd-MMM (15-MAY, 20-MAY)
    String mondayStr =
        DateFormat('dd-MMM', 'es_ES').format(monday).toUpperCase();
    String fridayStr =
        DateFormat('dd-MMM', 'es_ES').format(friday).toUpperCase();

    return '$mondayStr a $fridayStr';
  }

  /// Obtiene una semana específica (útil para reportes de semanas pasadas)
  static String getWeekRange(DateTime referenceDate) {
    // Encontrar el lunes de la semana de la fecha de referencia
    DateTime monday =
        referenceDate.subtract(Duration(days: referenceDate.weekday - 1));
    DateTime friday = monday.add(Duration(days: 4));

    String mondayStr =
        DateFormat('dd-MMM', 'es_ES').format(monday).toUpperCase();
    String fridayStr =
        DateFormat('dd-MMM', 'es_ES').format(friday).toUpperCase();

    return '$mondayStr a $fridayStr';
  }

  /// Obtiene las fechas individuales de la semana actual para usar en columnas
  static List<String> getCurrentWeekDates() {
    DateTime now = DateTime.now();
    DateTime monday = now.subtract(Duration(days: now.weekday - 1));

    List<String> dates = [];
    for (int i = 0; i < 5; i++) {
      // Lunes a Viernes
      DateTime day = monday.add(Duration(days: i));
      String dateStr = DateFormat('dd-MMM', 'es_ES').format(day).toUpperCase();
      dates.add(dateStr);
    }

    return dates;
  }

  /// Obtiene las fechas de una semana específica
  static List<String> getWeekDates(DateTime referenceDate) {
    DateTime monday =
        referenceDate.subtract(Duration(days: referenceDate.weekday - 1));

    List<String> dates = [];
    for (int i = 0; i < 5; i++) {
      DateTime day = monday.add(Duration(days: i));
      String dateStr = DateFormat('dd-MMM', 'es_ES').format(day).toUpperCase();
      dates.add(dateStr);
    }

    return dates;
  }
}

class AddClassScreen extends StatefulWidget {
  const AddClassScreen({Key? key}) : super(key: key);

  @override
  State<AddClassScreen> createState() => _AddClassScreenState();
}

class _AddClassScreenState extends State<AddClassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _grupoController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _selectedMateria;
  String? _selectedDocente;
  DateTime _fechaCreacion = DateTime.now();
  String? _codigoClase;
  String? _claseId; // ID del documento en Firestore
  bool _claseCreada = false;
  bool _guardandoClase = false; // Para mostrar loading

  // Lista de materias
  final List<String> _materias = [
    'Matemáticas',
    'Física',
    'Química',
    'Historia',
    'Literatura',
    'Inglés',
    'Biología',
    'Geografía',
    'Educación Física',
    'Arte',
  ];

  // Lista de docentes
  final List<Map<String, String>> _docentes = [
    {'id': '1', 'nombre': 'Yamil Barbosa Aguilar'},
    {'id': '2', 'nombre': '22090597'},
    {'id': '3', 'nombre': 'l22090597@zacatepec.tecnamex.mx'},
    {'id': '4', 'nombre': 'Lic. Ana Martínez'},
    {'id': '5', 'nombre': 'Prof. Luis Hernández'},
    {'id': '6', 'nombre': 'Dra. Carmen López'},
    {'id': '7', 'nombre': 'Mtro. Roberto Silva'},
    {'id': '8', 'nombre': 'Lic. Patricia Ruiz'},
  ];

  @override
  void dispose() {
    _grupoController.dispose();
    super.dispose();
  }

  String _generarCodigoClase() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'CLS$random';
  }

  // Método para guardar la clase en Firebase
  Future<void> _guardarClaseEnFirebase() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      final docenteSeleccionado = _docentes.firstWhere(
        (docente) => docente['id'] == _selectedDocente,
      );

      final nuevaClase = {
        'codigo_clase': _codigoClase,
        'materia': _selectedMateria,
        'grupo': _grupoController.text,
        'docente_id': _selectedDocente,
        'docente_nombre': docenteSeleccionado['nombre'],
        'fecha_creacion': Timestamp.fromDate(_fechaCreacion),
        'activa': true,
        'creado_por': user.uid, // ID del usuario que creó la clase
        'creado_por_email': user.email,
        'estudiantes_registrados': [], // Lista de IDs de estudiantes
        'total_estudiantes': 0,
        'fecha_actualizacion': Timestamp.fromDate(DateTime.now()),
      };

      // Guardar en Firestore
      DocumentReference docRef =
          await _firestore.collection('clases').add(nuevaClase);

      _claseId = docRef.id;

      print('Clase guardada en Firebase con ID: $_claseId');
    } catch (e) {
      print('Error al guardar clase en Firebase: $e');
      throw e;
    }
  }

  // Método principal para guardar clase
  Future<void> _guardarClase() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _guardandoClase = true;
      });

      try {
        _codigoClase = _generarCodigoClase();

        // Guardar en Firebase
        await _guardarClaseEnFirebase();

        setState(() {
          _claseCreada = true;
          _guardandoClase = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Clase creada y guardada exitosamente!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } catch (e) {
        setState(() {
          _guardandoClase = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar la clase: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  // Método para actualizar el estado de la clase
  Future<void> _actualizarEstadoClase({bool? activa}) async {
    if (_claseId == null) return;

    try {
      await _firestore.collection('clases').doc(_claseId).update({
        'activa': activa ?? !_claseCreada,
        'fecha_actualizacion': Timestamp.fromDate(DateTime.now()),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Estado de la clase actualizado'),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar estado: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _limpiarFormulario() {
    setState(() {
      _selectedMateria = null;
      _selectedDocente = null;
      _grupoController.clear();
      _fechaCreacion = DateTime.now();
      _codigoClase = null;
      _claseId = null;
      _claseCreada = false;
      _guardandoClase = false;
    });
  }

  void _copiarCodigo() {
    if (_codigoClase != null) {
      Clipboard.setData(ClipboardData(text: _codigoClase!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Código copiado al portapapeles'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _crearNuevaClase() {
    _limpiarFormulario();
  }

  // Método para obtener estadísticas en tiempo real
  Stream<DocumentSnapshot> _obtenerEstadisticasClase() {
    if (_claseId == null) {
      return Stream.empty();
    }
    return _firestore.collection('clases').doc(_claseId).snapshots();
  }

  String _formatearFecha(DateTime fecha) {
    final meses = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre'
    ];
    final dias = [
      'lunes',
      'martes',
      'miércoles',
      'jueves',
      'viernes',
      'sábado',
      'domingo'
    ];

    final diaSemana = dias[fecha.weekday - 1];
    final dia = fecha.day;
    final mes = meses[fecha.month - 1];
    final ano = fecha.year;

    return '$diaSemana, $dia de $mes de $ano';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Nueva Clase'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 2,
        actions: _claseCreada
            ? [
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    switch (value) {
                      case 'desactivar':
                        await _actualizarEstadoClase(activa: false);
                        break;
                      case 'activar':
                        await _actualizarEstadoClase(activa: true);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'desactivar',
                      child: Row(
                        children: [
                          Icon(Icons.pause_circle_outline,
                              color: Colors.orange),
                          SizedBox(width: 8),
                          Text('Desactivar Clase'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'activar',
                      child: Row(
                        children: [
                          Icon(Icons.play_circle_outline, color: Colors.green),
                          SizedBox(width: 8),
                          Text('Activar Clase'),
                        ],
                      ),
                    ),
                  ],
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: _claseCreada ? _buildQRView() : _buildFormulario(),
      ),
    );
  }

  Widget _buildQRView() {
    final qrData = jsonEncode({
      'claseId': _claseId,
      'codigo_clase': _codigoClase,
      'materia': _selectedMateria,
      'grupo': _grupoController.text,
    });

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header de éxito
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green[600],
                  size: 48,
                ),
                SizedBox(height: 12),
                Text(
                  '¡Clase Creada y Guardada!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Los datos están almacenados en Firebase',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Los alumnos pueden escanear este QR para registrarse',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green[600],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Estadísticas en tiempo real
          if (_claseId != null)
            StreamBuilder<DocumentSnapshot>(
              stream: _obtenerEstadisticasClase(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.exists) {
                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  final totalEstudiantes = data['total_estudiantes'] ?? 0;
                  final activa = data['activa'] ?? false;

                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: activa ? Colors.blue[50] : Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color:
                              activa ? Colors.blue[200]! : Colors.orange[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          activa ? Icons.circle : Icons.pause_circle,
                          color: activa ? Colors.green : Colors.orange,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Estado: ${activa ? "Activa" : "Pausada"}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: activa
                                      ? Colors.blue[700]
                                      : Colors.orange[700],
                                ),
                              ),
                              Text(
                                'Estudiantes registrados: $totalEstudiantes',
                                style: TextStyle(
                                  color: activa
                                      ? Colors.blue[600]
                                      : Colors.orange[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),

          // Información de la clase
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.cloud_done, color: Colors.green[600], size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Detalles de la Clase:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                _buildInfoRow('Materia:', _selectedMateria!),
                _buildInfoRow('Grupo:', _grupoController.text),
                _buildInfoRow(
                    'Docente:',
                    _docentes.firstWhere(
                        (d) => d['id'] == _selectedDocente)['nombre']!),
                _buildInfoRow('Código:', _codigoClase!),
                _buildInfoRow('ID Firebase:', _claseId ?? 'Generando...'),
                _buildInfoRow('Fecha:',
                    '${_fechaCreacion.day}/${_fechaCreacion.month}/${_fechaCreacion.year} ${_fechaCreacion.hour.toString().padLeft(2, '0')}:${_fechaCreacion.minute.toString().padLeft(2, '0')}'),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Código QR
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Código QR para Registro',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 16),
                QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 200.0,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.qr_code, color: Colors.grey[600], size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Código: $_codigoClase',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        onPressed: _copiarCodigo,
                        icon: Icon(Icons.copy, size: 20),
                        tooltip: 'Copiar código',
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Instrucciones
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[600]),
                    SizedBox(width: 8),
                    Text(
                      'Instrucciones para Alumnos:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  '1. Abrir la aplicación de estudiantes\n'
                  '2. Seleccionar "Registrarse a Clase"\n'
                  '3. Escanear este código QR\n'
                  '4. Confirmar registro en la clase\n'
                  '5. El registro se guardará automáticamente',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue[600],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 32),

          // Botones de acción
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back),
                  label: Text('Volver'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey[400]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _crearNuevaClase,
                  icon: Icon(Icons.add),
                  label: Text('Nueva Clase'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormulario() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header con información de fecha
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.blue[700],
                  size: 32,
                ),
                SizedBox(height: 8),
                Text(
                  'Fecha de Creación',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _formatearFecha(_fechaCreacion),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${_fechaCreacion.hour.toString().padLeft(2, '0')}:${_fechaCreacion.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Campo Materia
          Text(
            'Materia *',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedMateria,
            decoration: InputDecoration(
              hintText: 'Seleccionar materia',
              prefixIcon: Icon(Icons.book, color: Colors.blue[600]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
              ),
            ),
            items: _materias.map((String materia) {
              return DropdownMenuItem<String>(
                value: materia,
                child: Text(materia),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedMateria = newValue;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor selecciona una materia';
              }
              return null;
            },
          ),

          SizedBox(height: 20),

          // Campo Grupo
          Text(
            'Grupo *',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: _grupoController,
            decoration: InputDecoration(
              hintText: 'Ej: 3A, 2B, 1C',
              prefixIcon: Icon(Icons.group, color: Colors.blue[600]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa el grupo';
              }
              if (value.length < 2) {
                return 'El grupo debe tener al menos 2 caracteres';
              }
              return null;
            },
          ),

          SizedBox(height: 20),

          // Campo Docente
          Text(
            'Docente *',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedDocente,
            decoration: InputDecoration(
              hintText: 'Seleccionar docente',
              prefixIcon: Icon(Icons.person, color: Colors.blue[600]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
              ),
            ),
            items: _docentes.map((Map<String, String> docente) {
              return DropdownMenuItem<String>(
                value: docente['id'],
                child: Text(docente['nombre']!),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedDocente = newValue;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor selecciona un docente';
              }
              return null;
            },
          ),

          SizedBox(height: 32),

          // Botones
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _limpiarFormulario,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey[400]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Limpiar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _guardandoClase ? null : _guardarClase,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _guardandoClase
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('Guardando...'),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Guardar en Firebase',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Información adicional
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.cloud, color: Colors.blue[600], size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Los datos se guardarán automáticamente en Firebase',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
