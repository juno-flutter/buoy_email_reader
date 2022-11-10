// import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'gematek_email.dart';

class GetMainController extends GetxController {
  late GematekEmail client;
  late Map<String, dynamic> siteInfo;
  Map<String, Map<dynamic, dynamic>> buoyLastData = {};
  List<SensorDataForGrid> listSensorData = [];
  final String systemNameNfrdi = '빈산소';
  final String systemNameSeaweed = '해조류';
  final String systemNameFipa = '어항공단';
  final Color colorSeaweed = Colors.amber;
  final Color colorNfrdi = const Color.fromRGBO(0, 164, 173, 1);
  final Color colorFipa = const Color.fromRGBO(55, 128, 190, 1.0);

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
    buoyLastData['datetime'] = {'datetime': DateTime.parse('20${strTemp[2]}T${strTemp[3]}')};
    buoyLastData['gps'] = {'latitude': strTemp[4], 'longitude': strTemp[5]};
    buoyLastData['battery'] = {'voltage': strTemp[strTemp.length - 3]};

    List<String> strWeather = strTemp[6].split('_');
    if (strWeather.length == 3) {
      buoyLastData['weather'] = {'wind_direction': strWeather[0], 'wind_speed': strWeather[1], 'air_temperature': strWeather[2]};
    }

    int layer = siteInfo['layer'] as int;
    int offset = 7;
    for (int ii = 0; ii < layer; ii++) {
      List<String> strSensorData = strTemp[ii + offset].split('_');
      if (4 <= strSensorData.length && strSensorData.length <= 5) {
        // 빈산소 = 4, 해조류 = 5, 어항공단 = 4
        SensorDataForGrid sensor = SensorDataForGrid(
          no: (ii + 1).toString(),
          depth: strSensorData[0],
          temperature: strSensorData[1],
          salinity: strSensorData[2],
          oxygen: strSensorData[3],
        );
        if (siteInfo['system_name'] == systemNameSeaweed) {
          // sensor.addLight(strSensorData[4]);
          sensor.light = strSensorData[4];
        }
        // else if (siteInfo['system_name'] == systemNameFipa && siteInfo['type'] == 'B') {
        //   sensor.light = strSensorData[4];
        //   sensor.chlorophyll = strSensorData[5];
        // }
        listSensorData.add(sensor);
      }
      else {  // 어항공단 System B
        SensorDataForGrid sensor = SensorDataForGrid(
          no: (ii + 1).toString(),
          depth: strSensorData[0],
          temperature: strSensorData[1],
          ntu: strSensorData[2],
          ph: strSensorData[3],
          light: strSensorData[4],
          chlorophyll: strSensorData[5],
        );
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
  String light;
  String ntu;
  String ph;
  String chlorophyll;

  SensorDataForGrid({
    required this.no,
    required this.depth,
    required this.temperature,
    this.salinity = '',
    this.oxygen = '',
    this.light = '',
    this.ph = '',
    this.ntu = '',
    this.chlorophyll = '',
  });

// void addLight(String value) {
//   light = value;
// }
//
// void addChlorophyll(String value) {
//   chlorophyll = value;
// }
}
