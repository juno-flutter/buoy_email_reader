import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import 'dart:io';
// import 'package:enough_mail/pop/pop_exception.dart';

void printInfo(String ss) {
  var dt = DateFormat('y/M/d HH:mm:ss').format(DateTime.now());
  if (kDebugMode) {
    print('$dt - $ss');
  }
}

class DataView extends StatefulWidget {
  final Map buoyData;
  final String siteNameID;

  const DataView({Key? key, required this.buoyData, required this.siteNameID}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DataView();
}

// class GematekEmail extends ImapClient {
//   String userName = 'gematek@gmail.com';
//   String password = '1234';
//   String imapServerHost = 'imap.gmail.com';
//
//   bool loginEmailServer() {
//     return true;
//   }
// }

class _DataView extends State<DataView> {
  String userName = 'gematektest@gmail.com';
  String password = 'yfuqrbqtnijgvkrq';
  String imapServerHost = 'imap.gmail.com';
  int imapServerPort = 993;
  dynamic client;
  MimeMessage msg = MimeMessage();
  Map<String, Map<int, double>> emailData = {};
  late GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  Color setBackgroundColor() {
    if (widget.buoyData['system_name'] == '해조류') {
      return Colors.deepOrangeAccent;
    }
    return Colors.blue;
  }

  // @override
  // void initState() {
  //   super.initState();
  // }

  // void printMessage(MimeMessage message) {
  //   printInfo('from: ${message.from} with subject "${message.decodeSubject()}"');
  //   if (!message.isTextPlainMessage()) {
  //     printInfo(' content-type: ${message.mediaType}');
  //   } else {
  //     final plainText = message.decodeTextPlainPart();
  //     if (plainText != null) {
  //       final lines = plainText.split('\r\n');
  //       for (final line in lines) {
  //         if (line.startsWith('>')) {
  //           // break when quoted text starts
  //           break;
  //         }
  //         printInfo(line);
  //       }
  //     }
  //   }
  // }

  void setEmailData(FetchImapResult msgs) {
    for (final message in msgs.messages) {
      var subject = message.decodeSubject();
      if (subject == null) {
        continue;
      }
      if (subject.startsWith(widget.siteNameID) == true && subject.split(' ').length == 3) {
        msg = message;
        // printMessage(msg);
      }
      printInfo(widget.siteNameID);
      printInfo('subject.startsWith(widget.siteName) = ${subject.startsWith(widget.siteNameID)}');
      printInfo('subject = $subject');
      printInfo('subject.split.length = ${subject.split(' ').length}');
    }
  }

  List<DataColumn> _getColumns() {
    List<DataColumn> dataCol = [];
    dataCol.add(const DataColumn(label: Text('Layer'), numeric: true));
    dataCol.add(const DataColumn(label: Text('수심(m)'), numeric: true));
    dataCol.add(const DataColumn(label: Text('수온(℃)'), numeric: true));
    dataCol.add(const DataColumn(label: Text('용존산소(㎎/ℓ)'), numeric: true));
    dataCol.add(const DataColumn(label: Text('Salinity(psu)'), numeric: true));
    return dataCol;
  }

  List<DataRow> _getRows() {
    List<DataRow> dataRow = [];
    var text = msg.decodeTextPlainPart();
    if (text == null) {
      return dataRow;
    }
    // var bodyText = text.split('\r\n');
    return dataRow;
  }

  DataTable _getDataTable() {
    return DataTable(
      columns: _getColumns(),
      rows: _getRows(),
      horizontalMargin: 12.0,
      columnSpacing: 12.0,
    );
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    client = ImapClient(isLogEnabled: false);
    try {
      await client.connectToServer(imapServerHost, imapServerPort, isSecure: true);
      await client.login(userName, password);
      // final mailboxes = client.listMailboxes();
      var mailboxName = 'INBOX';
      int readCount = 14;
      if (widget.buoyData['system_name'] == '해조류') {
        mailboxName = '해조류';
        readCount = 6;
      }
      else if (widget.buoyData['system_name'] == '어항공단'){
        mailboxName = 'FIPA';
        readCount = 10;
      }
      await client.selectMailboxByPath(mailboxName);
      final fetchResult = await client.fetchRecentMessages(messageCount: readCount, criteria: 'BODY.PEEK[]');
      setEmailData(fetchResult);

      await client.logout();
      setState(() {
        // displayBuoyDataWidget();
      });
    } on ImapException catch (e) {
      printInfo('IMAP failed with $e');
    }
  }

  Widget displayBuoyDataWidget() {
    String? plainText = msg.decodeTextPlainPart();
    if (plainText != null) {
      printInfo('plaintText = $plainText');
      final lines = plainText.split('\r\n');
      for (final line in lines) {
        if (line.startsWith('>')) {
          // break when quoted text starts
          break;
        } else if (line.startsWith('\$')) {
          emailData.addAll({
            'temperature': {0: 12.3}
          });
          printInfo('line = "$line"');
          // printInfo('line.startsWith("\\\$") = ${line.startsWith('\$')}');
        }
      }
    }
    else {
      emailData.clear();
    }

    if (emailData.isEmpty == true) {
      return const Text('없음');
    } else {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: _getDataTable(),
      );
    }
  }

  Future<void> refreshList() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.buoyData['name']}'),
        backgroundColor: setBackgroundColor(),
      ),
      body: RefreshIndicator(
          key: refreshKey,
          onRefresh: refreshList,
          child: displayBuoyDataWidget()),
      floatingActionButton: FloatingActionButton(
        backgroundColor: setBackgroundColor(),
        onPressed: () {
          Navigator.of(context).pop();
        },
        mini: false,
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
