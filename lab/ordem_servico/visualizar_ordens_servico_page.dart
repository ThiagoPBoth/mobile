import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/login/service/login_service.dart';
import '../lab_service.dart';
import '../model/ordem_servico_model.dart';

class VisualizarOrdensServicoPage extends StatefulWidget {
  const VisualizarOrdensServicoPage({super.key});

  @override
  State<VisualizarOrdensServicoPage> createState() => _VisualizarOrdensServicoPageState();
}

class _VisualizarOrdensServicoPageState extends State<VisualizarOrdensServicoPage> {
  final LabService service = Modular.get<LabService>();
  List<OrdemServicoModel> _ordensServico = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadOrdens();
  }

  Future<void> _loadOrdens() async {
    try {
      final uuId = Modular.get<LoginService>().usuarioLogado?.uuid;
      if (uuId == null) throw Exception("Usuário não logado");
      final lab = await service.getLabByUsuario(uuId);
      final List<OrdemServicoModel> ordens = await service.getProtocolosEmAndamento(lab.id);

      setState(() {
        _ordensServico = ordens;  // atribui a lista recebida
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      debugPrint("Erro ao carregar ordens de serviço: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Diagnóstico'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _ordensServico.isEmpty
          ? const Center(child: Text('Nenhuma ordem em andamento'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _ordensServico.length,
        itemBuilder: (context, index) {
          final ordem = _ordensServico[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: ListTile(
              leading: const Icon(Icons.receipt_long),
              title: Text(
                ordem.protocolo ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(ordem.estabelecimento ?? ''),
            ),
          );
        },
      ),
    );
  }
}
