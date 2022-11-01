// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:buoy_email_reader/gematek_email.dart';
import 'package:get/get.dart';
import 'datagrid_view.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'getx_controller.dart';

// import 'package:buoy_email_reader/color_schemes.g.dart';
// import 'package:google_fonts/google_fonts.dart';

void main() {
  // runApp(GetMaterialApp(home: MyApp()));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final GetMainController c = Get.put(GetMainController());

  ScrollbarThemeData scrollbarThemeData() {
    return ScrollbarThemeData(
        thumbVisibility: MaterialStateProperty.all(true),
        thickness: MaterialStateProperty.all(10),
        thumbColor: MaterialStateProperty.all(Colors.red[100]),
        radius: const Radius.circular(10),
        minThumbLength: 50);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '지마텍 부이 자료 표출앱',
      theme: ThemeData(
        useMaterial3: true,
        // scrollbarTheme: scrollbarThemeData(),
        // colorScheme: lightColorScheme,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(14, 6, 117, 1),
          // brightness: Brightness.light,
        ),
        // scrollbarTheme: scrollbarThemeData(),
        fontFamily: 'NanumGothic',
        // primarySwatch: Colors.blue,
        // textTheme: GoogleFonts.nanumGothicTextTheme(Theme.of(context).textTheme),
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

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver, TickerProviderStateMixin {
  final GetMainController cm = Get.find();

  // late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addObserver(this);
    // _animationController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 300),
    //   reverseDuration: const Duration(milliseconds: 300),
    //   // value: 50,
    // )..addListener(() {
    //     setState(() {});
    //   });
    // _animationController.repeat(reverse: true);
    _init();
  }

  @override
  void dispose() {
    //앱 상태 변경 이벤트 해제
    //문제는 앱 종료시 dispose 함수가 호출되지 않아 해당 함수를 실행 할 수가 없다.
    // WidgetsBinding.instance.removeObserver(this);
    // _animationController.dispose();
    super.dispose();
  }

  // void _subInit() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => MainPage(),
  //     ),
  //   );
  // }

  void _init() async {
    cm.client = GematekEmail();
    await cm.client.login();
    // _subInit();
    // cm.client.sleepStart();
    Get.offAll(() => MainPage());
  }

  /*
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
        // ios 에서는 포 그라운드 비활성 상태에서 실행되는 앱 또는 Flutter 호스트 뷰에 해당합니다.
        // 안드로이드에서는 화면 분할 앱, 전화 통화, PIP 앱, 시스템 대화 상자 또는 다른 창과 같은 다른 활동이
        // 집중되면 앱이이 상태로 전환됩니다.
        // inactive 가 발생되고 얼마후 passed 가 발생합니다.
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
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onPrimary,
              // color: Colors.white54,
              strokeWidth: 3,
              // value: _animationController.value,
              // valueColor: _animationController
              //     .drive(ColorTween(begin: Colors.amber, end: Colors.purple)),
            ),
            const SizedBox(height: 20),
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.onPrimary,
                // color: Colors.white,
                shadows: <Shadow>[
                  Shadow(
                    offset: const Offset(4, 4),
                    color: Theme.of(context).colorScheme.shadow,
                    // color: Colors.black38,
                    blurRadius: 3.0,
                  ),
                ],
                // decorationStyle: TextDecorationStyle.dotted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final GetMainController cm = Get.find();

  static const Map<String, Map<String, dynamic>> mapBuoyInfoSeaweed = {
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

  static const Map<String, Map<String, dynamic>> mapBuoyInfoFipa = {
    'FP51': {
      'id': 'FP51',
      'name': '율도 (FP51)',
      'type': 'A',
      'layer': 3,
      'system_name': '어항공단',
    },
    'FP52': {
      'id': 'FP52',
      'name': '진목A (FP52)',
      'type': 'A',
      'layer': 3,
      'system_name': '어항공단',
    },
    'FP53': {
      'id': 'FP53',
      'name': '진목B (FP53)',
      'type': 'B',
      'layer': 3,
      'system_name': '어항공단',
    },
    'FP54': {
      'id': 'FP54',
      'name': '선소 (FP54)',
      'type': 'A',
      'layer': 3,
      'system_name': '어항공단',
    },
    'FP55': {
      'id': 'FP55',
      'name': '신흥 (FP55)',
      'type': 'A',
      'layer': 3,
      'system_name': '어항공단',
    },
    'FP56': {
      'id': 'FP56',
      'name': '양도A (FP56)',
      'type': 'A',
      'layer': 3,
      'system_name': '어항공단',
    },
    'FP57': {
      'id': 'FP57',
      'name': '양도B (FP57)',
      'type': 'B',
      'layer': 3,
      'system_name': '어항공단',
    },
    'FP58': {
      'id': 'FP58',
      'name': '저도 (FP58)',
      'type': 'A',
      'layer': 3,
      'system_name': '어항공단',
    },
    'FP59': {
      'id': 'FP59',
      'name': '청암A (FP59)',
      'type': 'A',
      'layer': 3,
      'system_name': '어항공단',
    },
    'FP60': {
      'id': 'FP60',
      'name': '청암B (FP60)',
      'type': 'B',
      'layer': 3,
      'system_name': '어항공단',
    },
    'FP61': {
      'id': 'FP61',
      'name': '송림A (FP61)',
      'type': 'A',
      'layer': 3,
      'system_name': '어항공단',
    },
    'FP62': {
      'id': 'FP62',
      'name': '송림B (FP62)',
      'type': 'B',
      'layer': 3,
      'system_name': '어항공단',
    },
  };

  static const Map<String, Map<String, dynamic>> mapBuoyInfoNfrdi = {
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
    'AI68': {
      'id': 'AI68',
      'name': '칠천2 (AI68)',
      'layer': 5,
      'system_name': '빈산소',
    },
    'AI69': {
      'id': 'AI69',
      'name': '문항1 (AI69)',
      'layer': 5,
      'system_name': '빈산소',
    },
    'AI70': {
      'id': 'AI70',
      'name': '광천1 (AI70)',
      'layer': 4,
      'system_name': '빈산소',
    },
  };

  static const Map<String, Map<String, dynamic>> mapBuoyInfo = {
    ...mapBuoyInfoSeaweed,
    ...mapBuoyInfoFipa,
    ...mapBuoyInfoNfrdi,
  };

  bool _isNfrdi(int i) {
    String buoy = mapBuoyInfo[mapBuoyInfo.keys.toList()[i]]!['system_name'];
    if (buoy == cm.systemNameNfrdi) {
      return true;
    }
    return false;
  }

  bool _isSeaweed(int i) {
    String buoy = mapBuoyInfo[mapBuoyInfo.keys.toList()[i]]!['system_name'];
    if (buoy == cm.systemNameSeaweed) {
      return true;
    }
    return false;
  }

  // bool _isFipa(int i) {
  //   String buoy = mapBuoyInfo[mapBuoyInfo.keys.toList()[i]]!['system_name'];
  //   if (buoy == cm.systemNameFipa) {
  //     return true;
  //   }
  //   return false;
  // }

  String _getSystemLogoString(int i) {
    String temp;
    if (_isNfrdi(i) == true) {
      temp = 'assets/nifs.png';
    } else if (_isSeaweed(i) == true) {
      temp = 'assets/gijang.jpg';
    } else {
      temp = 'assets/FipaLogo.jpg';
    }
    return temp;
  }

  String _getSystemName(int i) {
    String temp;
    if (_isNfrdi(i) == true) {
      temp = cm.systemNameNfrdi;
    } else if (_isSeaweed(i) == true) {
      temp = cm.systemNameSeaweed;
    } else {
      temp = cm.systemNameFipa;
    }
    return temp;
  }

  Color _getSystemColor(int i) {
    Color temp;
    if (_isNfrdi(i) == true) {
      temp = cm.colorNfrdi;
    } else if (_isSeaweed(i) == true) {
      temp = cm.colorSeaweed;
    } else {
      temp = cm.colorFipa;
    }
    return temp;
  }

  // Text _subSettingSystemName(int i) {
  //   return Text(
  //     mapBuoyInfo[mapBuoyInfo.keys.toList()[i]]!['system_name'],
  //     style: TextStyle(
  //       color: _isNfrdi(i) ? Colors.white : Colors.black.withOpacity(0.6),
  //       fontWeight: FontWeight.bold,
  //       fontSize: 17.5,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    const appbarRadius = 20.0;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        image: const DecorationImage(
          // fit: BoxFit.fitWidth,
          image: AssetImage('assets/kg.png'),
          opacity: 0.12,
          scale: 2.85,
          repeat: ImageRepeat.repeat,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: null,
          // backgroundColor: Theme.of(context).colorScheme.primary,
          backgroundColor: const Color.fromRGBO(14, 6, 117, 0.8),
          centerTitle: true,
          title: Text(
            '지마텍 부이 자료',
            // style: GoogleFonts.nanumGothic(
            //   fontWeight: FontWeight.bold,
            //   fontSize: 24,
            // ),
            style: TextStyle(
              // fontFamily: 'NanumGothic',
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          shadowColor: Theme.of(context).colorScheme.shadow,
          // surfaceTintColor: Colors.black,
          scrolledUnderElevation: 10,
          elevation: 10,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(appbarRadius),
              bottomLeft: Radius.circular(appbarRadius),
            ),
          ),
        ),
        body: Scrollbar(
          // trackVisibility: true,
          thickness: 8,
          radius: const Radius.circular(8),
          // thumbVisibility: true,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            itemCount: mapBuoyInfo.length,
            itemBuilder: (BuildContext context, int i) {
              var thisSiteInfo = mapBuoyInfo[mapBuoyInfo.keys.toList()[i]]!;
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                  // side: BorderSide(
                  //   color: Colors.grey.shade300,
                  // ),
                ),
                elevation: 9,
                shadowColor: Theme.of(context).colorScheme.shadow,
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  // tileColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                  tileColor: Colors.white,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        foregroundImage: ExactAssetImage(_getSystemLogoString(i)),
                        // backgroundColor: _isNfrdi(i) ? cm.colorNfrdi : cm.colorSeaweed,
                        // child: _subSettingSystemName(i),
                      ),
                      Text(
                        _getSystemName(i),
                        style: TextStyle(
                          fontFamily: 'NanumGothic',
                          fontSize: 20,
                          color: _getSystemColor(i),
                        ),
                      ),
                      Text(
                        thisSiteInfo['name'].toString(),
                        style: const TextStyle(
                          fontFamily: 'NanumGothic',
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(10),
                  //   side: const BorderSide(
                  //     color: Colors.black26,
                  //     width: 1.5,
                  //   ),
                  // ),
                  onTap: () async {
                    SimpleFontelicoProgressDialog? dialog;
                    var type = SimpleFontelicoProgressDialogType.normal;
                    dialog ??= SimpleFontelicoProgressDialog(context: context, barrierDimisable: false);
                    dialog.show(
                      message: '서버의 응답을\n기다리는 중입니다.',
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'NanumGothic',
                      ),
                      type: type,
                      horizontal: false,
                      width: 200.0,
                      height: 200.0,
                      separation: 40,
                      // elevation: 40,
                      radius: 25,
                      hideText: false,
                      indicatorColor: _getSystemColor(i),
                    );

                    cm.client.setCountAndMailbox(systemName: thisSiteInfo['system_name']);
                    var siteID = thisSiteInfo['id'].toString();
                    // print(siteID);
                    await cm.client.getEmail(siteID);
                    cm.siteInfo = thisSiteInfo;

                    dialog.hide();
                    await Future.delayed(const Duration(milliseconds: 100));

                    Get.to(
                      () => const DataGridView(),
                      transition: Transition.leftToRight,
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeInOutExpo,
                    );
                  },
                ),
              );
            },
            separatorBuilder: (BuildContext context, int idx) => const Divider(
              height: 5,
              thickness: 0,
              color: Colors.transparent,
              // color: null,
            ),
          ),
        ),
      ),
    );
  }
}
