import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/foundation.dart';

// import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';

class GematekEmail {
  late ImapClient _client;
  final String _userName = 'gematektest@gmail.com';
  final String _password = 'jowjrfsohapwqgre';
  final String _imapServerHost = 'imap.gmail.com';
  final int _imapServerPort = 993;
  int _readCount = 5;
  static const String _systemNfrdi = '빈산소';
  static const String _systemSeaweed = '해조류';
  String _mailboxName = '';
  String emailBody = '';

  GematekEmail() {
    _client = ImapClient(
      isLogEnabled: true,
      // connectionTimeout: const Duration(seconds: 15),
    );
    _client.eventBus.on<ImapConnectionLostEvent>().listen(_emailConnectionLostEvent);
    _client.eventBus.on<ImapMessagesExistEvent>().listen(_emailExistEvent);
  }

  Future<void> _emailConnectionLostEvent(ImapConnectionLostEvent ev) async {
    // await _client.logout();
    await _client.disconnect();
    await login();
    // SystemNavigator.pop();
  }

  void _emailExistEvent(ImapMessagesExistEvent ev) {
    if (kDebugMode) {
      print('newMessagesExists = ${ev.newMessagesExists}');
      print('oldMessagesExists = ${ev.oldMessagesExists}');
    }
    int newMsg = ev.newMessagesExists;
    int oldMsg = ev.oldMessagesExists;
    if (newMsg <= oldMsg) {
      return;
    }
  }

  void sleepStart() {
    _client.idleStart();
  }

  Future<void> login() async {
    try {
      var ret = await _client.connectToServer(_imapServerHost, _imapServerPort, isSecure: true);
      if (kDebugMode) {
        print('Email Server Connection Result : $ret');
      }
      var ret2 = await _client.login(_userName, _password);
      if (kDebugMode) {
        print('Login Result : $ret2');
        print('${DateTime.now()} - Email LogIn Success');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('IMAP failed with $e');
      }
    }
  }

  int setCountAndMailbox({String systemName = _systemNfrdi}) {
    if (systemName == _systemNfrdi) {
      _readCount = 15;
      _mailboxName = 'INBOX';
    } else {
      _readCount = 5;
      _mailboxName = _systemSeaweed;
    }
    if (kDebugMode) {
      print('systemName = $systemName');
    }
    return _readCount;
  }

  Future<String> getEmail(String siteID) async {
    late FetchImapResult fetchResult;
    emailBody = '';
    try {
      await _client.idleDone();
      // Mailbox mb = await _client.check();
      // print('MailBox = $mb');
      await _client.selectMailboxByPath(_mailboxName);
      fetchResult = await _client.fetchRecentMessages(messageCount: _readCount, criteria: 'BODY.PEEK[]');
      await _client.idleStart();
    } on ImapException catch (e) {
      if (kDebugMode) {
        print('IMAP Fetch failed with $e');
      }
    }
    dynamic listMsg;
    for (var message in fetchResult.messages) {
      var subject = message.decodeSubject();
      if (subject == null) {
        continue;
      }
      if ((subject.startsWith(siteID) == true || subject.contains(siteID)) && subject.split(' ').length == 3) {
        String? strTemp = message.decodeTextPlainPart();
        if (strTemp == null) {
          continue;
        }
        listMsg = strTemp.split('\r\n');
        if (listMsg == null || listMsg.isEmpty) {
          continue;
        }
        for (var line in listMsg) {
          // if (line.startsWith('>')) {
          //   // break when quoted text starts
          //   break;
          // } else
          if (line.startsWith('\$')) {
            emailBody = line;
          }
        }
      }
    }
    if (kDebugMode) {
      print('emailBody = $emailBody');
    }
    return emailBody;
  }
}
