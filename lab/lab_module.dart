import 'package:flutter_modular/flutter_modular.dart';

import '../shared/login/service/login_service.dart';
import 'lab_home_controller.dart';
import 'lab_home_page.dart';
import 'lab_service.dart';
import 'ordem_servico/visualizar_ordens_servico_page.dart';

class LabModule extends Module {

  @override
  List<Bind<Object>> get binds => [
    Bind.singleton((i) => LabService(loginService: i.get<LoginService>())),

    // Supondo que LabHomeController precisa de LabService
    Bind.lazySingleton((i) => LabHomeController(i.get<LabService>())),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute(
      Modular.initialRoute,
      child: (context, args) => const LabHomePage(),
    ),
    ChildRoute(
      '/ordem_servico/visualizar',
      child: (context, args) => const VisualizarOrdensServicoPage(),
    ),
  ];

 
}