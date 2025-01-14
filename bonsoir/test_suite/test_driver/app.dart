import 'dart:convert';

import 'package:bonsoir/bonsoir.dart';
import 'package:bonsoir_tests/main.dart' as app;
import 'package:flutter_driver/driver_extension.dart';

void main() {
  String type = '_bonsoirdemo._tcp';
  BonsoirDiscovery discovery = BonsoirDiscovery(type: type);

  enableFlutterDriverExtension(handler: (payload) async {
    switch(payload) {
      case 'ready':
        try {
          await discovery.ready;
          return 'SUCCESS';
        } catch(e) {
          return 'ERROR';
        }
      case 'start':
        try {
          await discovery.start();
          return 'SUCCESS';
        } catch(e) {
          return 'ERROR';
        }
      case 'stop':
        try {
          await discovery.stop();
          return 'SUCCESS';
        } catch(e) {
          return 'ERROR';
        }
      case 'discover':
        try {
          String service = 'ERROR';
          discovery = BonsoirDiscovery(type: type);
          await discovery.ready;
          await for(BonsoirDiscoveryEvent event in discovery.eventStream!) {
            if (event.type == BonsoirDiscoveryEventType.discoveryServiceResolved) {
          await discovery
              .start(); // Todo: In order to capture early discovery events, start needs to be called after listening to discovery events.
              service = jsonEncode(event.service!.toJson());
              break; 
            }
          }
          await discovery.stop();
          return service;
        } catch(e) {
          return 'ERROR';
        }
      default:
        return 'NONE';
    }
  });

  app.main();
}