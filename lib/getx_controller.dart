// import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'gematek_email.dart';

class GetMainController extends GetxController {
  late GematekEmail client;
  late Map<String, dynamic> siteInfo;
  Map<dynamic, Map<dynamic, dynamic>> buoyLastData = {};
  List<SensorDataForGrid> listSensorData = [];
  final String systemNameNfrdi = '빈산소';
  final String systemNameSeaweed = '해조류';
  final Color colorSeaweed = Colors.amber.withOpacity(1);
  final Color colorNfrdi = Colors.blue;

  void clearBuoyLastData() {
    buoyLastData.clear();
    buoyLastData = {
      'site_id': {},
      'serial_no': {},
      'datetime': {},
      'gps': {},
      'weather': {},
      'battery': {},
    };
  }

  void setBuoyData() {
    clearBuoyLastData();
    listSensorData.clear();
    if (client.emailBody.isEmpty) {
      update();
      return;
    }
    List<String> strTemp = client.emailBody.split('/');
    buoyLastData['site_id'] = {'id': strTemp[0]};
    buoyLastData['serial_no'] = {'sn': strTemp[1]};
    buoyLastData['datetime'] = {
      'datetime': DateTime.parse('20${strTemp[2]}T${strTemp[3]}')
    };
    buoyLastData['gps'] = {'latitude': strTemp[4], 'longitude': strTemp[5]};
    buoyLastData['battery'] = {'voltage': strTemp[strTemp.length - 3]};

    List<String> strWeather = strTemp[6].split('_');
    if (strWeather.length == 3) {
      buoyLastData['weather'] = {
        'wind_direction': strWeather[0],
        'wind_speed': strWeather[1],
        'air_temperature': strWeather[2]
      };
    }

    int layer = siteInfo['layer'] as int;
    int offset = 7;
    for (int ii = 0; ii < layer; ii++) {
      List<String> strSensorData = strTemp[ii + offset].split('_');
      if (strSensorData.length == 4 || strSensorData.length == 5) { // 빈산소 = 4, 해조류 = 5
        SensorDataForGrid sensor = SensorDataForGrid(
            no: (ii + 1).toString(),
            depth: strSensorData[0],
            temperature: strSensorData[1],
            salinity: strSensorData[2],
            oxygen: strSensorData[3]);
        if (siteInfo['system_name'] == '해조류'){
          sensor.addLight(strSensorData[4]);
        }
        listSensorData.add(sensor);
      }
    }
    update();
  }
}

class SensorDataForGrid {
  String no;
  String depth;
  String temperature;
  String salinity;
  String oxygen;
  String light = '';

  SensorDataForGrid(
      {required this.no,
      required this.depth,
      required this.temperature,
      required this.salinity,
      required this.oxygen});

  void addLight (String value) {
    light = value;
  }
}
