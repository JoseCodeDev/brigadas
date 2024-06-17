import 'package:flutter/material.dart';
import '../controllers/brigadas_controller.dart'; // Importa el controlador

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BrigadasController _brigadasController = BrigadasController();
  final TextEditingController nombre = TextEditingController();

  @override
  void initState() {
    super.initState();
    _brigadasController.getBrigadas();
  }

  void _showFormulario() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Agregar brigada"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.name,
                controller: nombre,
                decoration: const InputDecoration(hintText: "Nombre"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                nombre.clear();
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                await _brigadasController.postBrigadas(nombre.text);
                setState(() {
                  _brigadasController.getBrigadas();
                });
                nombre.clear();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmarEliminacion(String id) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content:
              const Text('¿Estás seguro de que quieres eliminar esta brigada?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                nombre.clear();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _brigadasController.deleteBrigada(id);
                setState(() {
                  _brigadasController.getBrigadas();
                });
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editarBrigada(String id, String nombreActual) async {
    nombre.text = nombreActual;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar brigada'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.name,
                controller: nombre,
                decoration: const InputDecoration(hintText: "Nombre"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                nombre.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await _brigadasController.updateBrigada(id, nombre.text);
                setState(() {
                  _brigadasController.getBrigadas();
                });
                nombre.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Editar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Brigadas", style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFFF2D8CE),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _brigadasController.getBrigadas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al mostrar las brigadas'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay brigadas disponibles'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length + 1,
              itemBuilder: (context, index) {
                if (index == snapshot.data!.length) {
                  return const SizedBox(
                      height:
                          80); // Espacio adicional para evitar que el botón flotante cubra el último elemento
                }
                final item = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.all(10.0),
                  color: const Color(0xFFCED3F2),
                  child: Padding(
                    padding: const EdgeInsets.all(
                        3.0), // Ajusta el espacio dentro de la Card
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical:
                                8.0), // Ajusta el espacio entre el título y los iconos
                        child: Text(item['nombre']),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Color.fromARGB(255, 128, 128, 128)),
                            onPressed: () =>
                                _editarBrigada(item['id'], item['nombre']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmarEliminacion(item['id']),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFormulario,
        backgroundColor: Colors.blue[300],
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
