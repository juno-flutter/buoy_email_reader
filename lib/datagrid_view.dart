import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'getx_controller.dart';
import 'package:get/get.dart';

// import 'package:enough_mail/enough_mail.dart';
// import 'package:gematek_buoy_email/gematek_email.dart';

class DataGridView extends StatefulWidget {
  const DataGridView({Key? key}) : super(key: key);

  @override
  DataGridViewState createState() => DataGridViewState();
}

class DataGridViewState extends State<DataGridView> {
  final GetMainController cm = Get.find();

  // String siteID = '';
  late BuoyDataSource buoyDataSource;

  Color setBackgroundColor() {
    if (cm.siteInfo['system_name'].toString() == cm.systemNameSeaweed) {
      return cm.colorSeaweed;
    } else if (cm.siteInfo['system_name'].toString() == cm.systemNameFipa) {
      return cm.colorFipa;
    }
    return cm.colorNfrdi;
  }

  @override
  void initState() {
    super.initState();
    cm.setBuoyData();
    buoyDataSource = BuoyDataSource();
  }

  Widget displayWeather() {
    const double fontSize = 15;
    var wd = double.parse(cm.buoyLastData['weather']!['wind_direction']);
    var ws = double.parse(cm.buoyLastData['weather']!['wind_speed']);
    var at = double.parse(cm.buoyLastData['weather']!['air_temperature']);
    var bt = double.parse(cm.buoyLastData['battery']!['voltage']).toStringAsFixed(1);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          '풍향: $wd°',
          style: const TextStyle(fontSize: fontSize),
        ),
        Text(
          '풍속: $ws㎧',
          style: const TextStyle(fontSize: fontSize),
        ),
        Text(
          '기온: $at℃',
          style: const TextStyle(fontSize: fontSize),
        ),
        Text(
          '배터리: ${bt}V',
          style: const TextStyle(fontSize: fontSize),
        ),
      ],
    );
  }

  Widget displayFooter(GetMainController controller) {
    if (controller.buoyLastData['datetime'] == null || controller.buoyLastData['datetime']!.isEmpty) {
      return Container(
        alignment: AlignmentDirectional.center,
        // decoration: const BoxDecoration(color: Colors.blue),
        color: Colors.grey.shade200,
        // foregroundDecoration: const BoxDecoration(color: Colors.amber),
        padding: const EdgeInsets.only(top: 0),
        child: const Text(
          "데이터 없음!",
          style: TextStyle(color: Colors.redAccent, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }

    String textDate = DateFormat('yy/MM/dd  HH:mm:ss').format(controller.buoyLastData['datetime']!['datetime']);
    String textNo = "No.: ${int.parse(controller.buoyLastData['serial_no']!['sn']).toString()}";
    // String text = DateFormat('20yy년 MM월 dd일  HH시 mm분 ss초').format(controller.buoyLastData['datetime']!['datetime']);
    return Container(
      // alignment: AlignmentDirectional.center,
      // decoration: const BoxDecoration(color: Colors.blue),
      color: Colors.grey.shade200,
      // foregroundDecoration: const BoxDecoration(color: Colors.amber),
      // padding: const EdgeInsets.only(top: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          displayWeather(),
          const SizedBox(
            height: 7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                textDate,
                style: const TextStyle(color: Colors.black87, fontSize: 15),
              ),
              Text(
                textNo,
                style: const TextStyle(color: Colors.black87, fontSize: 15),
              ),
            ],
          )
        ],
      ),
    );
  }

  List<GridColumn> setGridColumn(double paddingColumn, double fontSizeHeader) {
    List<GridColumn> list = [
      GridColumn(
        columnName: 'layer',
        label: Container(
          padding: EdgeInsets.all(paddingColumn),
          alignment: Alignment.center,
          child: Text(
            'No',
            style: TextStyle(fontSize: fontSizeHeader),
          ),
        ),
      ),
      GridColumn(
        columnName: 'depth',
        label: Container(
          padding: EdgeInsets.all(paddingColumn),
          alignment: Alignment.center,
          child: Text(
            '수심\n(m)',
            style: TextStyle(fontSize: fontSizeHeader),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      GridColumn(
        columnName: 'temperature',
        label: Container(
          padding: EdgeInsets.all(paddingColumn),
          alignment: Alignment.center,
          child: Text(
            '수온\n(℃)',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSizeHeader,
            ),
          ),
        ),
      ),
      GridColumn(
        columnName: 'salinity',
        label: Container(
          padding: EdgeInsets.all(paddingColumn),
          alignment: Alignment.center,
          child: Text(
            '염분\n(PSU)',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSizeHeader,
            ),
          ),
        ),
      ),
      GridColumn(
        columnName: 'oxygen',
        label: Container(
          padding: EdgeInsets.all(paddingColumn),
          alignment: Alignment.center,
          child: Text(
            '산소\n(㎎/ℓ)',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSizeHeader,
            ),
          ),
        ),
      ),
    ];
    String systemName = cm.siteInfo['system_name'].toString();
    if (systemName == cm.systemNameSeaweed || (systemName == cm.systemNameFipa && cm.siteInfo['type'] == 'B')) {
      list.add(
        GridColumn(
          columnName: 'light',
          label: Container(
            padding: EdgeInsets.all(paddingColumn),
            alignment: Alignment.center,
            child: Text(
              '일사량',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSizeHeader,
              ),
            ),
          ),
        ),
      );
      if (systemName == cm.systemNameFipa) {
        list.add(
          GridColumn(
            columnName: 'chlorophyll',
            label: Container(
              padding: EdgeInsets.all(paddingColumn),
              alignment: Alignment.center,
              child: Text(
                '엽록소',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSizeHeader,
                ),
              ),
            ),
          ),
        );
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    const double heightHeader = 70;
    const double fontSizeHeader = 15;
    const double paddingColumn = 2.0;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: setBackgroundColor(),
        title: Row(
          children: [
            CircleAvatar(
              foregroundImage: ExactAssetImage(
                cm.siteInfo['system_name'].toString() == cm.systemNameNfrdi
                    ? 'assets/nifs.png'
                    : (cm.siteInfo['system_name'].toString() == cm.systemNameSeaweed ? 'assets/gijang.jpg' : 'assets/FipaLogo.jpg'),
              ),
            ),
            const SizedBox(width: 15),
            Text(
              cm.siteInfo['system_name'].toString(),
              style: const TextStyle(
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              cm.siteInfo['name'].toString(),
              style: const TextStyle(
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SfDataGrid(
        headerRowHeight: heightHeader,
        allowPullToRefresh: true,
        footerHeight: 80,
        footer: GetBuilder<GetMainController>(
          builder: (controller) => displayFooter(controller),
        ),
        source: buoyDataSource,
        columnWidthMode: ColumnWidthMode.fill,
        columns: setGridColumn(paddingColumn, fontSizeHeader),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: setBackgroundColor(),
        onPressed: () => Get.back(),
        mini: false,
        elevation: 0,
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}

class BuoyDataSource extends DataGridSource {
  late List<DataGridRow> dataGridRowBuoydata;
  final GetMainController cm = Get.find();

  BuoyDataSource() {
    buildDataGridRows();
  }

  @override
  Future<void> handleRefresh() async {
    await cm.client.getEmail(cm.siteInfo['id'].toString());
    cm.setBuoyData();
    buildDataGridRows();
    notifyListeners();
  }

  List<DataGridCell<String>> setDataGridRow(SensorDataForGrid e) {
    List<DataGridCell<String>> list = [
      DataGridCell<String>(columnName: 'layer', value: e.no),
      DataGridCell<String>(columnName: 'depth', value: e.depth),
      DataGridCell<String>(columnName: 'temperature', value: e.temperature),
      DataGridCell<String>(columnName: 'salinity', value: e.salinity),
      DataGridCell<String>(columnName: 'oxygen', value: e.oxygen)
    ];
    if (cm.siteInfo['system_name'].toString() == cm.systemNameSeaweed) {
      list.add(DataGridCell<String>(columnName: 'light', value: e.light));
    }
    return list;
  }

  buildDataGridRows() {
    dataGridRowBuoydata = cm.listSensorData.map<DataGridRow>((e) => DataGridRow(cells: setDataGridRow(e))).toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRowBuoydata;

  Widget setCellBackgroundColor(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.black),
    );
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>(
        (e) {
          Color getColor() {
            double data = double.parse(e.value);
            if (data <= 0) {
              return Colors.redAccent;
            }
            return Colors.transparent;
          }

          TextStyle? getTextStyle() {
            double data = double.parse(e.value.toString());
            if (data <= 0) {
              return const TextStyle(color: Colors.white, fontSize: 16);
            }
            return const TextStyle(fontSize: 16);
          }

          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            color: getColor(),
            child: Text(e.value.toString(), style: getTextStyle()),
          );
        },
      ).toList(),
    );
  }
}
