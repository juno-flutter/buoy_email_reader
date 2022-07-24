import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:buoy_email_reader/gematek_email.dart';
import 'package:get/get.dart';
import 'datagrid_view.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'getx_controller.dart';
// import 'dart:io';
// import 'package:gematek_buoy_email/data_view.dart';
// import 'package:enough_mail/enough_mail.dart';
// import 'package:enough_mail/enough_mail.dart';
// import 'package:simple_fontellico_progress_dialog/fontelico_icons.dart';
// import 'package:simple_fontellico_progress_dialog/rotate_icon.dart';
// import 'package:gematek_buoy_email/data_view.dart';

void main() {
  runApp(GetMaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final GetMainController c = Get.put(GetMainController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '지마텍 부이 자료 표출앱',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '지마텍 부이 자료'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final GetMainController cm = Get.find();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      // value: 50,
    )..addListener(() {
        setState(() {});
      });
    _animationController.repeat(reverse: true);
    _init();
  }

  @override
  void dispose() {
    //앱 상태 변경 이벤트 해제
    //문제는 앱 종료시 dispose함수가 호출되지 않아 해당 함수를 실행 할 수가 없다.
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    super.dispose();
  }

  void _init() async {
    cm.client = GematekEmail();
    await cm.client.login();
    // cm.client.sleepStart();
    Get.offAll(() => MainPage());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //https://api.flutter.dev/flutter/dart-ui/AppLifecycleState-class.html
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        // 앱이 표시되고 사용자 입력에 응답합니다.
        // 주의! 최초 앱 실행때는 해당 이벤트가 발생하지 않습니다.
        if (kDebugMode) {
          print("resumed");
        }
        break;
      case AppLifecycleState.inactive:
        // 앱이 비활성화 상태이고 사용자의 입력을 받지 않습니다.
        // ios에서는 포 그라운드 비활성 상태에서 실행되는 앱 또는 Flutter 호스트 뷰에 해당합니다.
        // 안드로이드에서는 화면 분할 앱, 전화 통화, PIP 앱, 시스템 대화 상자 또는 다른 창과 같은 다른 활동이
        // 집중되면 앱이이 상태로 전환됩니다.
        // inactive가 발생되고 얼마후 pasued가 발생합니다.
        if (kDebugMode) {
          print("inactive");
        }
        break;
      case AppLifecycleState.paused:
        // 앱이 현재 사용자에게 보이지 않고, 사용자의 입력을 받지 않으며, 백그라운드에서 동작 중입니다.
        // 안드로이드의 onPause()와 동일합니다.
        // 응용 프로그램이 이 상태에 있으면 엔진은 Window.onBeginFrame 및 Window.onDrawFrame 콜백을
        // 호출하지 않습니다.
        if (kDebugMode) {
          print("paused");
        }
        break;
      case AppLifecycleState.detached:
        // 응용 프로그램은 여전히 flutter 엔진에서 호스팅되지만 "호스트 View"에서 분리됩니다.
        // 앱이 이 상태에 있으면 엔진이 "View"없이 실행됩니다.
        // 엔진이 처음 초기화 될 때 "View" 연결 진행 중이거나 네비게이터 팝으로 인해 "View"가
        // 파괴 된 후 일 수 있습니다.
        if (kDebugMode) {
          print("detached");
        }
        break;
    }
    if (kDebugMode) {
      print('didChangeAppLifecycleState');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            CircularProgressIndicator(
              color: Colors.white54,
              // backgroundColor: cm.colorNfrdi,
              strokeWidth: 5,
              // value: _animationController.value,
              // valueColor: _animationController
              //     .drive(ColorTween(begin: Colors.amber, end: Colors.purple)),
            ),
            SizedBox(height: 20),
            Text('로딩중...',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    shadows: <Shadow>[Shadow(offset: Offset(4, 4), color: Colors.black26)],
                    decorationStyle: TextDecorationStyle.dashed))
          ],
        ),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final GetMainController cm = Get.find();
  static const Map<String, Map<String, dynamic>> mapBuoyInfo = {
    'AI51': {
      'id': 'AI51',
      'name': '고성1 (AI51)',
      'layer': 3,
      'system_name': '빈산소',
    },
    'AI52': {
      'id': 'AI52',
      'name': '자란1 (AI52)',
      'layer': 3,
      'system_name': '빈산소',
    },
    'AI53': {
      'id': 'AI53',
      'name': '진동1 (AI53)',
      'layer': 3,
      'system_name': '빈산소',
    },
    'AI56': {
      'id': 'AI56',
      'name': '자란3 (AI56)',
      'layer': 5,
      'system_name': '빈산소',
    },
    'AI57': {
      'id': 'AI57',
      'name': '가막1 (AI57)',
      'layer': 3,
      'system_name': '빈산소',
    },
    'AI58': {
      'id': 'AI58',
      'name': '가막2 (AI58)',
      'layer': 3,
      'system_name': '빈산소',
    },
    'AI59': {
      'id': 'AI59',
      'name': '당동1 (AI59)',
      'layer': 5,
      'system_name': '빈산소',
    },
    'AI60': {
      'id': 'AI60',
      'name': '원문1 (AI60)',
      'layer': 6,
      'system_name': '빈산소',
    },
    'AI61': {
      'id': 'AI61',
      'name': '가조1 (AI61)',
      'layer': 9,
      'system_name': '빈산소',
    },
    'AI63': {
      'id': 'AI63',
      'name': '북신1 (AI63)',
      'layer': 3,
      'system_name': '빈산소',
    },
    'AI64': {
      'id': 'AI64',
      'name': '거제1 (AI64)',
      'layer': 3,
      'system_name': '빈산소',
    },
    'AI65': {
      'id': 'AI65',
      'name': '당항1 (AI65)',
      'layer': 5,
      'system_name': '빈산소',
    },
    'AI66': {
      'id': 'AI66',
      'name': '칠천1 (AI66)',
      'layer': 4,
      'system_name': '빈산소',
    },
    'AI67': {
      'id': 'AI67',
      'name': '심리1 (AI67)',
      'layer': 7,
      'system_name': '빈산소',
    },
    'BK51': {
      'id': 'BK51',
      'name': '기장 (BK51)',
      'layer': 4,
      'system_name': '해조류',
    },
    'BK52': {
      'id': 'BK52',
      'name': '일광 (BK52)',
      'layer': 4,
      'system_name': '해조류',
    },
    'BK53': {
      'id': 'BK53',
      'name': '장안 (BK53)',
      'layer': 4,
      'system_name': '해조류',
    },
  };

  Text _subSettingSystemName(int i) {
    String buoy = mapBuoyInfo[mapBuoyInfo.keys.toList()[i]]!['system_name'];
    if (buoy == cm.systemNameNfrdi) {
      return Text(
        buoy,
        style: TextStyle(color: cm.colorNfrdi, fontWeight: FontWeight.bold),
      );
    }
    return Text(
      buoy,
      style: TextStyle(
        color: cm.colorSeaweed,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text('지마텍 부이 자료'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: mapBuoyInfo.length,
        itemBuilder: (BuildContext context, int i) {
          var thisSiteInfo = mapBuoyInfo[mapBuoyInfo.keys.toList()[i]]!;
          return ListTile(
              tileColor: Colors.white.withOpacity(0.95),
              contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _subSettingSystemName(i),
                  Text(thisSiteInfo['name']),
                ],
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              onTap: () async {
                SimpleFontelicoProgressDialog? dialog;
                var type = SimpleFontelicoProgressDialogType.normal;
                dialog ??=
                    SimpleFontelicoProgressDialog(context: context, barrierDimisable: false);
                dialog.show(
                    message: 'iphone',
                    type: type,
                    horizontal: true,
                    width: 150.0,
                    height: 75.0,
                    hideText: true,
                    indicatorColor: Colors.blue);

                cm.client.setCountAndMailbox(systemName: thisSiteInfo['system_name']);
                var siteID = thisSiteInfo['id'];
                // print(siteID);
                await cm.client.getEmail(siteID);
                cm.siteInfo = thisSiteInfo;

                dialog.hide();

                Get.to(() => const DataGridView(), transition: Transition.leftToRightWithFade);
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                //   return const DataGridView();
                // }));
              });
        },
        separatorBuilder: (BuildContext context, int idx) => const Divider(
          height: 10,
          thickness: 0,
          // color: null,
        ),
      ),
    );
  }
}
