import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/atendimento.dart';
import '../dao/atendimento_dao.dart';
import '../utils/input_formatters.dart';
import '../widgets/conteudo_form_atendimento_dialog.dart';

class ListaAtendimentosPage extends StatefulWidget {
  const ListaAtendimentosPage({super.key});

  @override
  State<ListaAtendimentosPage> createState() => _ListaAtendimentosPageState();
}

class _ListaAtendimentosPageState extends State<ListaAtendimentosPage> {

  final dao = AtendimentoDao();
  List<Atendimento> atendimentos = [];

  final filtroController = TextEditingController();
  String? filtroData;

  @override
  void initState() {
    super.initState();
    carregarAtendimentos();
  }

  Future<void> carregarAtendimentos() async {
    final lista = await dao.listar(filtro: filtroData ?? '');
    setState(() {
      atendimentos = lista;
    });
  }

  void abrirDialog({Atendimento? atendimento}) async {
    final resultado = await showModalBottomSheet<Atendimento>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ConteudoFormAtendimentoDialog(atendimento: atendimento),
    );

    if (resultado != null) {
      await dao.salvar(resultado);
      carregarAtendimentos();
    }
  }

  void excluirAtendimento(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmar exclusão"),
          content: const Text("Deseja excluir este atendimento?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                await dao.excluir(id);
                Navigator.pop(context);
                carregarAtendimentos();
              },
              child: const Text("Excluir"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Atendimentos")),

      floatingActionButton: FloatingActionButton(
        onPressed: () => abrirDialog(),
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: filtroController,
              keyboardType: TextInputType.number,
              inputFormatters: [DateInputFormatter()],
              decoration: InputDecoration(
                labelText: "Filtrar por data",
                hintText: "dd/mm/aaaa",
                border: const OutlineInputBorder(),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        filtroData = filtroController.text;
                        carregarAtendimentos();
                      },
                    ),

                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        filtroController.clear();
                        filtroData = null;
                        carregarAtendimentos();
                      },
                    ),

                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: atendimentos.isEmpty
                ? const Center(child: Text("Nenhum atendimento"))
                : ListView.builder(
              itemCount: atendimentos.length,
              itemBuilder: (context, index) {

                final a = atendimentos[index];

                return Card(
                  child: ListTile(
                    title: Text(a.descricao),
                    subtitle: Text(
                      "Data: ${a.data}\n"
                          "Hora: ${a.hora}\n"
                          "Valor: R\$ ${a.valor}\n"
                          "Local: ${a.localizacao}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => abrirDialog(atendimento: a),
                        ),

                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => excluirAtendimento(a.id!),
                        ),

                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}