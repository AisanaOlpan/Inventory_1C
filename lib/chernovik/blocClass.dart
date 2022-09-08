import 'dart:async';

import 'package:models/tmz_models.dart';
import 'package:repository/TMZ_repository.dart';

class ClientsBloc {
  ClientsBloc() {
    getClients();
  }
  final _clientController =     StreamController<List<tmz_Model>>.broadcast();
  get clients => _clientController.stream;

  dispose() {
    _clientController.close();
  }

  getClients() async {
    _clientController.sink.add(await tmzRepository().getAllTMZ('000000001'));
  }
}