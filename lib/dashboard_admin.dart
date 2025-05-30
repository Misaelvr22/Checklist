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
  bool isSidebarOpen = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      'materia': 'Cálculo Integral',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[50],
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 768;
          bool isTablet =
              constraints.maxWidth >= 768 && constraints.maxWidth < 1024;

          return Column(
            children: [
              _buildHeader(isMobile),
              Expanded(
                child: isMobile
                    ? _buildMobileLayout()
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isMobile) _buildSidebar(isTablet),
                          Expanded(
                              child: _buildMainContent(isMobile, isTablet)),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
      drawer: _buildDrawer(),
    );
  }

  Widget _buildHeader(bool isMobile) {
    final String fechaCompleta =
        DateFormat('EEEE d \'de\' MMMM \'de\' y', 'es_ES')
            .format(DateTime.now());

    return Container(
      color: azulOscuro,
      padding:
          EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (isMobile) ...[
                IconButton(
                  icon: Icon(Icons.menu, color: Colors.white),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
                SizedBox(width: 8),
              ],
              Text(
                isMobile ? 'CheckList' : 'CheckList - Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 18 : 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              if (!isMobile) ...[
                Icon(Icons.calendar_today, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  fechaCompleta,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                SizedBox(width: 16),
              ],
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'logout') {
                    print('Redirigiendo...');
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

  Widget _buildMobileLayout() {
    return _buildMainContent(true, false);
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: azulOscuro),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'CheckList Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  DateFormat('EEEE d \'de\' MMMM', 'es_ES')
                      .format(DateTime.now()),
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem('dashboard', 'Dashboard', Icons.dashboard),
                _buildDrawerItem('profesores', 'Profesores', Icons.person),
                _buildDrawerItem('estudiantes', 'Estudiantes', Icons.group),
                _buildDrawerItem('clases', 'Clases', Icons.book),
                _buildDrawerItem('reportes', 'Reportes', Icons.bar_chart),
                _buildDrawerItem(
                    'configuracion', 'Configuración', Icons.settings),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String section, String title, IconData icon) {
    bool isActive = activeSection == section;
    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? Colors.blue[700] : Colors.grey[600],
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.blue[700] : Colors.grey[600],
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isActive,
      selectedTileColor: Colors.blue[50],
      onTap: () {
        setState(() => activeSection = section);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildSidebar(bool isTablet) {
    return Container(
      width: isTablet ? 200 : 256,
      padding: EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _buildNavItem(
                  'dashboard', 'Dashboard', Icons.dashboard, isTablet),
              _buildNavItem('profesores', 'Profesores', Icons.person, isTablet),
              _buildNavItem(
                  'estudiantes', 'Estudiantes', Icons.group, isTablet),
              _buildNavItem('clases', 'Clases', Icons.book, isTablet),
              _buildNavItem('reportes', 'Reportes', Icons.bar_chart, isTablet),
              _buildNavItem(
                  'configuracion', 'Configuración', Icons.settings, isTablet),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      String section, String title, IconData icon, bool isTablet) {
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
              if (!isTablet) ...[
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isActive ? Colors.blue[700] : Colors.grey[600],
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(bool isMobile, bool isTablet) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      child: _getContentForSection(isMobile, isTablet),
    );
  }

  Widget _getContentForSection(bool isMobile, bool isTablet) {
    switch (activeSection) {
      case 'dashboard':
        return _buildDashboard(isMobile, isTablet);
      case 'profesores':
        return _buildProfesores(isMobile);
      case 'estudiantes':
        return _buildEstudiantes(isMobile);
      default:
        return _buildComingSoon(activeSection);
    }
  }

  Widget _buildDashboard(bool isMobile, bool isTablet) {
    int crossAxisCount = isMobile ? 2 : (isTablet ? 3 : 4);
    double childAspectRatio = isMobile ? 1.8 : (isTablet ? 2.0 : 1.5);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Estadísticas principales
          GridView.count(
            crossAxisCount: crossAxisCount,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: isMobile ? 8 : 16,
            mainAxisSpacing: isMobile ? 8 : 16,
            childAspectRatio: childAspectRatio,
            children: [
              _buildStatCard('Total Profesores', '${stats['totalProfesores']}',
                  Icons.group, Colors.blue, isMobile),
              _buildStatCard(
                  'Total Estudiantes',
                  '${stats['totalEstudiantes']}',
                  Icons.group,
                  Colors.green,
                  isMobile),
              _buildStatCard('Clases Activas', '${stats['clasesActivas']}',
                  Icons.book, Colors.purple, isMobile),
              _buildStatCard(
                  'Asistencia Promedio',
                  '${stats['asistenciaPromedio']}%',
                  Icons.trending_up,
                  Colors.orange,
                  isMobile),
            ],
          ),

          SizedBox(height: 24),

          // Acciones rápidas
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Acciones Rápidas',
                    style: TextStyle(
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 16),
                  isMobile
                      ? Column(
                          children: [
                            _buildActionButton('Agregar Profesor',
                                Icons.person_add, Colors.blue, isMobile),
                            SizedBox(height: 8),
                            _buildActionButton('Gestionar Estudiantes',
                                Icons.group, Colors.green, isMobile),
                            SizedBox(height: 8),
                            _buildActionButton('Nueva Clase', Icons.add_box,
                                Colors.purple, isMobile),
                            SizedBox(height: 8),
                            _buildActionButton('Reportes Generales',
                                Icons.download, Colors.orange, isMobile),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                                child: _buildActionButton('Agregar Profesor',
                                    Icons.person_add, Colors.blue, isMobile)),
                            SizedBox(width: 12),
                            Expanded(
                                child: _buildActionButton(
                                    'Gestionar Estudiantes',
                                    Icons.group,
                                    Colors.green,
                                    isMobile)),
                            SizedBox(width: 12),
                            Expanded(
                                child: _buildActionButton('Nueva Clase',
                                    Icons.add_box, Colors.purple, isMobile)),
                            SizedBox(width: 12),
                            Expanded(
                                child: _buildActionButton('Reportes Generales',
                                    Icons.download, Colors.orange, isMobile)),
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
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Clases Recientes',
                    style: TextStyle(
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 16),
                  ...recentClasses
                      .map((clase) => _buildRecentClassItem(clase, isMobile))
                      .toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon,
      MaterialColor color, bool isMobile) {
    return Card(
      color: color[50],
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 8 : 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: color[600],
                      fontSize: isMobile ? 9 : 11,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(icon, color: color[600], size: isMobile ? 16 : 20),
              ],
            ),
            SizedBox(height: isMobile ? 2 : 4),
            Text(
              value,
              style: TextStyle(
                color: color[800],
                fontSize: isMobile ? 14 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      String text, IconData icon, MaterialColor color, bool isMobile) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color[600],
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: isMobile ? 16 : 20),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: isMobile ? 12 : 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentClassItem(Map<String, dynamic> clase, bool isMobile) {
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
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clase['materia'],
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  '${clase['profesor']} • ${clase['estudiantes']} estudiantes',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                SizedBox(height: 8),
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
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
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

  Widget _buildProfesores(bool isMobile) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Gestión de Profesores',
                style: TextStyle(
                    fontSize: isMobile ? 18 : 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.add, size: isMobile ? 16 : 20),
              label: Text(
                isMobile ? 'Nuevo' : 'Nuevo Profesor',
                style: TextStyle(fontSize: isMobile ? 12 : 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 16,
                  vertical: isMobile ? 8 : 12,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Expanded(
          child: Card(
            child: Column(
              children: [
                _buildSearchBar(Colors.blue, isMobile),
                Expanded(
                  child: isMobile
                      ? _buildProfesoresList()
                      : SingleChildScrollView(
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

  Widget _buildEstudiantes(bool isMobile) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Gestión de Estudiantes',
                style: TextStyle(
                    fontSize: isMobile ? 18 : 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.add, size: isMobile ? 16 : 20),
              label: Text(
                isMobile ? 'Nuevo' : 'Nuevo Estudiante',
                style: TextStyle(fontSize: isMobile ? 12 : 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 16,
                  vertical: isMobile ? 8 : 12,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Expanded(
          child: Card(
            child: Column(
              children: [
                _buildSearchBar(Colors.green, isMobile),
                Expanded(
                  child: isMobile
                      ? _buildEstudiantesList()
                      : SingleChildScrollView(
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

  Widget _buildSearchBar(MaterialColor color, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
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
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: isMobile ? 8 : 12,
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

  Widget _buildProfesoresList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: profesores.length,
      itemBuilder: (context, index) {
        final profesor = profesores[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      radius: 20,
                      child: Text(
                        _getInitials(profesor['nombre']),
                        style: TextStyle(
                          color: Colors.blue[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profesor['nombre'],
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            profesor['email'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: profesor['activo']
                            ? Colors.green[100]
                            : Colors.red[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        profesor['activo'] ? 'Activo' : 'Inactivo',
                        style: TextStyle(
                          color: profesor['activo']
                              ? Colors.green[800]
                              : Colors.red[800],
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Materias: ${profesor['materias']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      'Estudiantes: ${profesor['estudiantes']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon:
                          Icon(Icons.visibility, color: Colors.blue, size: 20),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.green, size: 20),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red, size: 20),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEstudiantesList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: estudiantes.length,
      itemBuilder: (context, index) {
        final estudiante = estudiantes[index];
        Color badgeColor;
        if (estudiante['asistencia'] >= 85) {
          badgeColor = Colors.green;
        } else if (estudiante['asistencia'] >= 70) {
          badgeColor = Colors.orange;
        } else {
          badgeColor = Colors.red;
        }

        return Card(
          margin: EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green[100],
                      radius: 20,
                      child: Text(
                        _getInitials(estudiante['nombre']),
                        style: TextStyle(
                          color: Colors.green[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            estudiante['nombre'],
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            estudiante['numeroControl'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Carrera: ${estudiante['carrera']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      'Semestre: ${estudiante['semestre']}°',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon:
                          Icon(Icons.visibility, color: Colors.blue, size: 20),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.green, size: 20),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red, size: 20),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfesoresTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
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
                      radius: 16,
                      child: Text(
                        _getInitials(profesor['nombre']),
                        style: TextStyle(
                          color: Colors.blue[600],
                          fontSize: 12,
                        ),
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
                    color: profesor['activo']
                        ? Colors.green[100]
                        : Colors.red[100],
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
      ),
    );
  }

  Widget _buildEstudiantesTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
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
                      radius: 16,
                      child: Text(
                        _getInitials(estudiante['nombre']),
                        style: TextStyle(
                          color: Colors.green[600],
                          fontSize: 12,
                        ),
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
      ),
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

// Ejemplo de uso en main.dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard Responsive',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AdminDashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}
