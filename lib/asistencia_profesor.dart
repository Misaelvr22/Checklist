import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'componentes/tema.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
                          onTap: () {},
                        ),
                        const SizedBox(width: 16),
                        _buildActionButton(
                          icon: Icons.description,
                          label: 'Reporte de asistencia',
                          color: Colors.purple,
                          onTap: () {},
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
  const AddStudentsPage({Key? key}) : super(key: key);

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

  const QRGeneratorPage({Key? key, required this.className}) : super(key: key);

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
