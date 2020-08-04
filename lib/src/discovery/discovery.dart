import 'package:bonsoir/src/bonsoir_class.dart';
import 'package:bonsoir/src/discovery/discovered_service.dart';
import 'package:bonsoir/src/discovery/discovery_event.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BonsoirDiscovery extends BonsoirClass<BonsoirDiscoveryEvent> {
  final String type;

  BonsoirDiscovery({
    bool printLogs = kDebugMode,
    @required this.type,
  }) : super(
          classType: 'discovery',
          printLogs: printLogs,
        );

  @override
  BonsoirDiscoveryEvent transformPlatformEvent(dynamic event) {
    Map<String, dynamic> data = Map<String, dynamic>.from(event);
    String id = data['id'];
    BonsoirDiscoveryEventType type = BonsoirDiscoveryEventType.values.firstWhere((type) => type.name.toLowerCase() == id, orElse: () => BonsoirDiscoveryEventType.UNKNOWN);
    DiscoveredBonsoirService service;
    if (type == BonsoirDiscoveryEventType.DISCOVERY_SERVICE_FOUND || type == BonsoirDiscoveryEventType.DISCOVERY_SERVICE_LOST) {
      service = jsonToService(Map<String, dynamic>.from(data['result']));
    }

    return BonsoirDiscoveryEvent(type: type, service: service);
  }

  @override
  Future<void> start() {
    assert(isReady);
    return BonsoirClass.channel.invokeMethod('discovery.start', completeArguments({'type': type}));
  }
}
