// lab_service.dart
import 'dart:convert';

import '../../core/helpers/env.dart';
import '../../services/abstract_service.dart';
import '../shared/login/service/login_service.dart';
import 'model/laboratorio_model.dart';
import 'model/ordem_servico_model.dart';

class LabService extends AbstractService{

  final LoginService _loginService;

  LabService({required LoginService loginService}) : _loginService = loginService;

  Future<LaboratorioModel> getLabByUsuario (uuId) async {

    final response = await super.auth().client.get('${Env.baseUrl}/laboratorio/buscaLaboratorioPorUsuario/$uuId');

    if (response.statusCode == 200) {
      final json = response.data as Map<String, dynamic>;

      return LaboratorioModel(
        id: json['id'] as int?,
      );
    } else {
      throw Exception('Falha ao carregar laboratório (Status: ${response.statusCode})');
    }

  }

  Future<List<OrdemServicoModel>> getProtocolosEmAndamento(int? idLab) async {
    final response = await super.auth().client.get(
        '${Env.laboratorioBaseUrl}/ordem-servico/getAll/aguardando-em-andamento-by-lab/$idLab'
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar ordens (Status ${response.statusCode})');
    }


    final List<dynamic> ordens = response.data as List<dynamic>;

    return ordens.map((item) {
      final Map<String,dynamic> map = item as Map<String,dynamic>;
      return OrdemServicoModel(
        protocolo: map['protocolo']?.toString(),
        estabelecimento: map['estabelecimento']?.toString(),
      );
    }).toList();
  }

}