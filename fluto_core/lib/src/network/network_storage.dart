import 'package:fluto_core/src/network/infospect_network_call.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'network_storage_keys.dart';

class NetworkStorage extends ChangeNotifier {
  final LazyBox _box;

  NetworkStorage(this._box) {
    init();
  }

  Future<void> init() async {
    final futures = await Future.wait(_box.keys.map((key) => getNetworkCall(key)));
    final calls = futures.whereType<InfospectNetworkCall>();
    _networkCall.addAll(calls);
    notifyListeners();
  }

  final Set<InfospectNetworkCall> _networkCall = {};
  Set<InfospectNetworkCall> get networkCall => _networkCall;

  Future<void> addNetworkCall(InfospectNetworkCall call) async {
    try {
      _networkCall.add(call);
      await _box.put(call.hashCode, call.toJson());
    } catch (e) {
      throw Exception("Error adding network call\n$e");
    }
  }

  Future<InfospectNetworkCall?> getNetworkCall(int hashCode) async {
    try {
      final data = await _box.get(hashCode);
      if (data == null) return null;
      return InfospectNetworkCall.fromJson(data);
    } catch (e) {
      throw Exception("Error getting network call\n$e");
    }
  }

  Future<void> clear() async {
    _networkCall.clear();
    await _box.clear();
    notifyListeners();
  }
}
