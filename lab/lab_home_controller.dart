// lab_home_controller.dart
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import 'lab_service.dart';

part 'lab_home_controller.g.dart';

class LabHomeController = _LabHomeControllerBase with _$LabHomeController;

abstract class _LabHomeControllerBase with Store {
  final LabService _service;

  _LabHomeControllerBase(this._service);

  @observable
  var loading = false;

  @action
  Future<void> initialize() async {
    loading = true;
    // Inicializações específicas do lab
    loading = false;
  }
}