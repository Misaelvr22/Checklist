import 'package:check_list/componentes/tema.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'auth/inicio_sesion.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String activeSection = 'dashboard';
  String searchTerm = '';
  final TextEditingController searchController = TextEditingController();

  // Datos de ejemplo
  final Map<String, dynamic> stats = {
    'totalProfesores': 12,
    'totalEstudiantes': 340,
    'clasesActivas': 8,
    'asistenciaPromedio': 85.2
  };

  final List<Map<String, dynamic>> recentClasses = [
    {
      'id': 1,
      'materia': 'POO',
      'profesor': 'Dr. García',
      'estudiantes': 28,
      'asistencia': 89
    },
    {
      'id': 2,
      'materia': 'Calculo Integral',
      'profesor': 'Lic. López',
      'estudiantes': 32,
      'asistencia': 76
    },
    {
      'id': 3,
      'materia': 'Física',
      'profesor': 'Ing. Martínez',
      'estudiantes': 25,
      'asistencia': 92
    },
  ];

  final List<Map<String, dynamic>> profesores = [
    {
      'id': 1,
      'nombre': 'Dr. José García',
      'email': 'garcia@escuela.edu',
      'materias': 3,
      'estudiantes': 85,
      'activo': true
    },
    {
      'id': 2,
      'nombre': 'Lic. María López',
      'email': 'lopez@escuela.edu',
      'materias': 2,
      'estudiantes': 67,
      'activo': true
    },
    {
      'id': 3,
      'nombre': 'Ing. Carlos Martínez',
      'email': 'martinez@escuela.edu',
      'materias': 2,
      'estudiantes': 52,
      'activo': false
    },
  ];

  final List<Map<String, dynamic>> estudiantes = [
    {
      'id': 1,
      'nombre': 'Ana Rodríguez',
      'numeroControl': '18320100',
      'carrera': 'Ingeniería',
      'semestre': 6,
      'asistencia': 95
    },
    {
      'id': 2,
      'nombre': 'Luis Pérez',
      'numeroControl': '18320101',
      'carrera': 'Programación',
      'semestre': 4,
      'asistencia': 87
    },
    {
      'id': 3,
      'nombre': 'Carmen Silva',
      'numeroControl': '18320102',
      'carrera': 'Matemáticas',
      'semestre': 8,
      'asistencia': 78
    },
  ];
  final String fechaCompleta =
      DateFormat('EEEE d \'de\' MMMM \'de\' y', 'es_ES').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSidebar(),
                Expanded(child: _buildMainContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: azulOscuro,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'CheckList - Admin',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                fechaCompleta,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              SizedBox(width: 16),

              // 👇 Aquí va el PopupMenuButton con Cerrar sesión
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'logout') {
                    print('Redirigiendo...');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => InicioSesion()),
                    ); // O tu ruta destino
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'logout',
                    child: Text('Cerrar sesióon'),
                  ),
                ],
                child: CircleAvatar(
                  backgroundColor: Colors.blue[600],
                  radius: 16,
                  child: Text(
                    'A',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 256,
      padding: EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _buildNavItem('dashboard', 'Dashboard', Icons.dashboard),
              _buildNavItem('profesores', 'Profesores', Icons.check_box),
              _buildNavItem('estudiantes', 'Estudiantes', Icons.group),
              _buildNavItem('clases', 'Clases', Icons.book),
              _buildNavItem('reportes', 'Reportes', Icons.bar_chart),
              _buildNavItem('configuracion', 'Configuración', Icons.settings),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String section, String title, IconData icon) {
    bool isActive = activeSection == section;
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => setState(() => activeSection = section),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? Colors.blue[100] : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive ? Colors.blue[700] : Colors.grey[600],
                size: 20,
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: isActive ? Colors.blue[700] : Colors.grey[600],
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: _getContentForSection(),
    );
  }

  Widget _getContentForSection() {
    switch (activeSection) {
      case 'dashboard':
        return _buildDashboard();
      case 'profesores':
        return _buildProfesores();
      case 'estudiantes':
        return _buildEstudiantes();
      default:
        return _buildComingSoon(activeSection);
    }
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Estadísticas principales
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard('Total Profesores', '${stats['totalProfesores']}',
                  Icons.group, Colors.blue),
              _buildStatCard('Total Estudiantes',
                  '${stats['totalEstudiantes']}', Icons.group, Colors.green),
              _buildStatCard('Clases Activas', '${stats['clasesActivas']}',
                  Icons.book, Colors.purple),
              _buildStatCard(
                  'Asistencia Promedio',
                  '${stats['asistenciaPromedio']}%',
                  Icons.trending_up,
                  Colors.orange),
            ],
          ),
          SizedBox(height: 24),

          // Acciones rápidas
          Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Acciones Rápidas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: _buildActionButton('Agregar Profesor',
                              Icons.person_add, Colors.blue)),
                      SizedBox(width: 12),
                      Expanded(
                          child: _buildActionButton('Gestionar Estudiantes',
                              Icons.group, Colors.green)),
                      SizedBox(width: 12),
                      Expanded(
                          child: _buildActionButton(
                              'Nueva Clase', Icons.add_box, Colors.purple)),
                      SizedBox(width: 12),
                      Expanded(
                          child: _buildActionButton('Reportes Generales',
                              Icons.download, Colors.orange)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),

          // Clases recientes
          Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Clases Recientes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 16),
                  ...recentClasses
                      .map((clase) => _buildRecentClassItem(clase))
                      .toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, MaterialColor color) {
    return Card(
      color: color[50],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: color[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        value,
                        style: TextStyle(
                          color: color[800],
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(icon, color: color[600], size: 32),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, MaterialColor color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color[600],
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentClassItem(Map<String, dynamic> clase) {
    Color badgeColor;
    if (clase['asistencia'] >= 85) {
      badgeColor = Colors.green;
    } else if (clase['asistencia'] >= 70) {
      badgeColor = Colors.orange;
    } else {
      badgeColor = Colors.red;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                clase['materia'],
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                '${clase['profesor']} • ${clase['estudiantes']} estudiantes',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${clase['asistencia']}% asistencia',
              style: TextStyle(
                color: badgeColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfesores() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Gestión de Profesores',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.add),
              label: Text('Nuevo Profesor'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Expanded(
          child: Card(
            child: Column(
              children: [
                _buildSearchBar(Colors.blue),
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildProfesoresTable(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEstudiantes() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Gestión de Estudiantes',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.add),
              label: Text('Nuevo Estudiante'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Expanded(
          child: Card(
            child: Column(
              children: [
                _buildSearchBar(Colors.green),
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildEstudiantesTable(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(MaterialColor color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: (value) => setState(() => searchTerm = value),
              decoration: InputDecoration(
                hintText: 'Buscar...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: color[500]!),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.filter_list),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey[100],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfesoresTable() {
    return DataTable(
      columns: [
        DataColumn(label: Text('Profesor')),
        DataColumn(label: Text('Email')),
        DataColumn(label: Text('Materias')),
        DataColumn(label: Text('Estudiantes')),
        DataColumn(label: Text('Estado')),
        DataColumn(label: Text('Acciones')),
      ],
      rows: profesores.map((profesor) {
        return DataRow(
          cells: [
            DataCell(
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    child: Text(
                      _getInitials(profesor['nombre']),
                      style: TextStyle(color: Colors.blue[600]),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(profesor['nombre']),
                ],
              ),
            ),
            DataCell(Text(profesor['email'])),
            DataCell(Text('${profesor['materias']}')),
            DataCell(Text('${profesor['estudiantes']}')),
            DataCell(
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      profesor['activo'] ? Colors.green[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  profesor['activo'] ? 'Activo' : 'Inactivo',
                  style: TextStyle(
                    color: profesor['activo']
                        ? Colors.green[800]
                        : Colors.red[800],
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.visibility, color: Colors.blue),
                    onPressed: () {},
                    iconSize: 16,
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.green),
                    onPressed: () {},
                    iconSize: 16,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {},
                    iconSize: 16,
                  ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildEstudiantesTable() {
    return DataTable(
      columns: [
        DataColumn(label: Text('Estudiante')),
        DataColumn(label: Text('No. Control')),
        DataColumn(label: Text('Carrera')),
        DataColumn(label: Text('Semestre')),
        DataColumn(label: Text('Asistencia')),
        DataColumn(label: Text('Acciones')),
      ],
      rows: estudiantes.map((estudiante) {
        Color badgeColor;
        if (estudiante['asistencia'] >= 85) {
          badgeColor = Colors.green;
        } else if (estudiante['asistencia'] >= 70) {
          badgeColor = Colors.orange;
        } else {
          badgeColor = Colors.red;
        }

        return DataRow(
          cells: [
            DataCell(
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green[100],
                    child: Text(
                      _getInitials(estudiante['nombre']),
                      style: TextStyle(color: Colors.green[600]),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(estudiante['nombre']),
                ],
              ),
            ),
            DataCell(Text(estudiante['numeroControl'])),
            DataCell(Text(estudiante['carrera'])),
            DataCell(Text('${estudiante['semestre']}°')),
            DataCell(
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${estudiante['asistencia']}%',
                  style: TextStyle(
                    color: badgeColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.visibility, color: Colors.blue),
                    onPressed: () {},
                    iconSize: 16,
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.green),
                    onPressed: () {},
                    iconSize: 16,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {},
                    iconSize: 16,
                  ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildComingSoon(String section) {
    IconData icon;
    String title;

    switch (section) {
      case 'clases':
        icon = Icons.book;
        title = 'Gestión de Clases';
        break;
      case 'reportes':
        icon = Icons.bar_chart;
        title = 'Reportes Avanzados';
        break;
      case 'configuracion':
        icon = Icons.settings;
        title = 'Configuración del Sistema';
        break;
      default:
        icon = Icons.info;
        title = 'Sección';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Próximamente...',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    List<String> parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    return parts[0][0];
  }
}
