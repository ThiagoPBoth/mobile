import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../core/ui/global/global_snack_bar.dart';
import '../../core/ui/global/ihc.dart';
import '../../core/ui/redesign/theme/app_colors.dart';
import '../../core/ui/widgets/app_bar/pdsa_header_bar.dart';
import '../../core/ui/widgets/texts/pdsa_text.dart';
import '../../core/ui/widgets/texts/pdsa_text_icon.dart';
import '../../core/utils/conectividade.dart';
import '../../core/cache/cache_usuario.dart';
import '../../extensions/string.dart';
import '../shared/login/service/login_service.dart';
import '../common/planilhas/cache/cache_controller.dart';
import 'drawer_lab.dart';
import 'lab_home_controller.dart';

class LabHomePage extends StatefulWidget {
  const LabHomePage({Key? key}) : super(key: key);

  @override
  State<LabHomePage> createState() => _LabHomePageState();
}

class _LabHomePageState extends State<LabHomePage> {
  final controller = Modular.get<LabHomeController>();
  late StreamSubscription<InternetConnectionStatus>? connectivityListener;
  String ola = "";
  String unidade = "";

  @override
  void initState() {
    super.initState();
    checkConectividade();
    controller.initialize();
    connectivityListener = InternetConnectionChecker.createInstance(
      checkTimeout: const Duration(milliseconds: 250),
      checkInterval: const Duration(seconds: 15),
    ).onStatusChange.listen((status) {
      // Recarregar dados se necessário
    });
  }

  @override
  void dispose() {
    connectivityListener?.cancel();
    super.dispose();
  }

  void checkConectividade() async {
    bool isOnline = await Conectividade.isOnline();
    String nomeUsuario = "Usuário";
    if (isOnline) {
      nomeUsuario =
          Modular.get<LoginService>().usuarioLogado?.nome ?? "Usuário";
    } else {
      CacheUsuario? usr = await CacheController.getUsuarioCache();
      if (usr != null) {
        nomeUsuario = usr.nome ?? "Usuário";
      }
    }
    setState(() {
      ola = 'Olá, $nomeUsuario';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const LabDrawer(),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            PdsaHeaderBar(
              title: ola.isNotEmpty
                  ? ola
                  .split(' ')
                  .map((w) =>
              w.isNotEmpty ? w.capitalizeAll() : "")
                  .join(' ')
                  : ola,
              settings: const PdsaHeaderSettings(
                collapsible: false,
                expanded: true,
              ),
            ),
          ],
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const PdsaText(
                    text: "Portal Laboratório",
                    color: Color.fromARGB(255, 0, 105, 153),
                    textAlign: TextAlign.center,
                    size: 28,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 20),
                  Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        IHC.requiresInternet(() {
                          Modular.to.pushNamed(
                              '/lab/ordem_servico/visualizar');
                        }, requiresInternet: true);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F7FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF006699),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.science,
                              size: 80,
                              color: Color(0xFF006699),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "DIAGNÓSTICO",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Padding(
                              padding:
                              EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                "Visualizar Ordens de Serviço",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
