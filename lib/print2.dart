// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
//
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   final title = 'BLE Scan & Connection Demo';
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: title,
//       home: MyHomePage(title: title),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   FlutterBlue flutterBlue = FlutterBlue.instance;
//   List<ScanResult> scanResultList = [];
//   bool _isScanning = false;
//
//   @override
//   initState() {
//     super.initState();
//     // 블루투스 초기화
//     initBle();
//   }
//
//   void initBle() {
//     // BLE 스캔 상태 얻기 위한 리스너
//     flutterBlue.isScanning.listen((isScanning) {
//       _isScanning = isScanning;
//       setState(() {});
//     });
//   }
//
//   /*
//   스캔 시작/정지 함수
//   */
//   scan() async {
//     if (!_isScanning) {
//       // 스캔 중이 아니라면
//       // 기존에 스캔된 리스트 삭제
//       scanResultList.clear();
//       // 스캔 시작, 제한 시간 4초
//       flutterBlue.startScan(timeout: Duration(seconds: 4));
//       // 스캔 결과 리스너
//       flutterBlue.scanResults.listen((results) {
//         scanResultList = results;
//         // UI 갱신
//         setState(() {});
//       });
//     } else {
//       // 스캔 중이라면 스캔 정지
//       flutterBlue.stopScan();
//     }
//   }
//
//   /*
//    여기서부터는 장치별 출력용 함수들
//   */
//   /*  장치의 신호값 위젯  */
//   Widget deviceSignal(ScanResult r) {
//     return Text(r.rssi.toString());
//   }
//
//   /* 장치의 MAC 주소 위젯  */
//   Widget deviceMacAddress(ScanResult r) {
//     return Text(r.device.id.id);
//   }
//
//   /* 장치의 명 위젯  */
//   Widget deviceName(ScanResult r) {
//     String name = '';
//
//     if (r.device.name.isNotEmpty) {
//       // device.name에 값이 있다면
//       name = r.device.name;
//     } else if (r.advertisementData.localName.isNotEmpty) {
//       // advertisementData.localName에 값이 있다면
//       name = r.advertisementData.localName;
//     } else {
//       // 둘다 없다면 이름 알 수 없음...
//       name = 'N/A';
//     }
//     return Text(name);
//   }
//
//   /* BLE 아이콘 위젯 */
//   Widget leading(ScanResult r) {
//     return CircleAvatar(
//       child: Icon(
//         Icons.bluetooth,
//         color: Colors.white,
//       ),
//       backgroundColor: Colors.cyan,
//     );
//   }
//
//   /* 장치 아이템을 탭 했을때 호출 되는 함수 */
//   void onTap(ScanResult r) {
//     // 단순히 이름만 출력
//     print('${r.device.name}');
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => DeviceScreen(device: r.device)),
//     );
//   }
//
//   /* 장치 아이템 위젯 */
//   Widget listItem(ScanResult r) {
//     return ListTile(
//       onTap: () => onTap(r),
//       leading: leading(r),
//       title: deviceName(r),
//       subtitle: deviceMacAddress(r),
//       trailing: deviceSignal(r),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         /* 장치 리스트 출력 */
//         child: ListView.separated(
//           itemCount: scanResultList.length,
//           itemBuilder: (context, index) {
//             return listItem(scanResultList[index]);
//           },
//           separatorBuilder: (BuildContext context, int index) {
//             return Divider();
//           },
//         ),
//       ),
//       /* 장치 검색 or 검색 중지  */
//       floatingActionButton: FloatingActionButton(
//         onPressed: scan,
//         // 스캔 중이라면 stop 아이콘을, 정지상태라면 search 아이콘으로 표시
//         child: Icon(_isScanning ? Icons.stop : Icons.search),
//       ),
//     );
//   }
// }
//
//
// class DeviceScreen extends StatefulWidget {
//   DeviceScreen({Key? key, required this.device}) : super(key: key);
//   // 장치 정보 전달 받기
//   final BluetoothDevice device;
//
//   @override
//   _DeviceScreenState createState() => _DeviceScreenState();
// }
//
// class _DeviceScreenState extends State<DeviceScreen> {
//   // flutterBlue
//   FlutterBlue flutterBlue = FlutterBlue.instance;
//
//   // 연결 상태 표시 문자열
//   String stateText = 'Connecting';
//
//   // 연결 버튼 문자열
//   String connectButtonText = 'Disconnect';
//
//   // 현재 연결 상태 저장용
//   BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;
//
//   // 연결 상태 리스너 핸들 화면 종료시 리스너 해제를 위함
//   StreamSubscription<BluetoothDeviceState>? _stateListener;
//
//   @override
//   initState() {
//     super.initState();
//     // 상태 연결 리스너 등록
//     _stateListener = widget.device.state.listen((event) {
//       debugPrint('event :  $event');
//       if (deviceState == event) {
//         // 상태가 동일하다면 무시
//         return;
//       }
//       // 연결 상태 정보 변경
//       setBleConnectionState(event);
//     });
//     // 연결 시작
//     connect();
//   }
//
//   @override
//   void dispose() {
//     // 상태 리스터 해제
//     _stateListener?.cancel();
//     // 연결 해제
//     disconnect();
//     super.dispose();
//   }
//
//   @override
//   void setState(VoidCallback fn) {
//     if (mounted) {
//       // 화면이 mounted 되었을때만 업데이트 되게 함
//       super.setState(fn);
//     }
//   }
//
//   /* 연결 상태 갱신 */
//   setBleConnectionState(BluetoothDeviceState event) {
//     switch (event) {
//       case BluetoothDeviceState.disconnected:
//         stateText = 'Disconnected';
//         // 버튼 상태 변경
//         connectButtonText = 'Connect';
//         break;
//       case BluetoothDeviceState.disconnecting:
//         stateText = 'Disconnecting';
//         break;
//       case BluetoothDeviceState.connected:
//         stateText = 'Connected';
//         // 버튼 상태 변경
//         connectButtonText = 'Disconnect';
//         break;
//       case BluetoothDeviceState.connecting:
//         stateText = 'Connecting';
//         break;
//     }
//     //이전 상태 이벤트 저장
//     deviceState = event;
//     setState(() {});
//   }
//
//   /* 연결 시작 */
//   Future<bool> connect() async {
//     Future<bool>? returnValue;
//     setState(() {
//       /* 상태 표시를 Connecting으로 변경 */
//       stateText = 'Connecting';
//     });
//
//     /*
//       타임아웃을 10초(10000ms)로 설정 및 autoconnect 해제
//        참고로 autoconnect가 true되어있으면 연결이 지연되는 경우가 있음.
//      */
//     await widget.device
//         .connect(autoConnect: false)
//         .timeout(Duration(milliseconds: 10000), onTimeout: () {
//       //타임아웃 발생
//       //returnValue를 false로 설정
//       returnValue = Future.value(false);
//       debugPrint('timeout failed');
//
//       //연결 상태 disconnected로 변경
//       setBleConnectionState(BluetoothDeviceState.disconnected);
//     }).then((data) {
//       if (returnValue == null) {
//         //returnValue가 null이면 timeout이 발생한 것이 아니므로 연결 성공
//         debugPrint('connection successful');
//         returnValue = Future.value(true);
//       }
//     });
//
//     return returnValue ?? Future.value(false);
//   }
//
//   /* 연결 해제 */
//   void disconnect() {
//     try {
//       setState(() {
//         stateText = 'Disconnecting';
//       });
//       widget.device.disconnect();
//     } catch (e) {}
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         /* 장치명 */
//         title: Text(widget.device.name),
//       ),
//       body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               /* 연결 상태 */
//               Text('$stateText'),
//               /* 연결 및 해제 버튼 */
//               OutlinedButton(
//                   onPressed: () {
//                     if (deviceState == BluetoothDeviceState.connected) {
//                       /* 연결된 상태라면 연결 해제 */
//                       disconnect();
//                     } else if (deviceState == BluetoothDeviceState.disconnected) {
//                       /* 연결 해재된 상태라면 연결 */
//                       connect();
//                     } else {}
//                   },
//                   child: Text(connectButtonText)),
//             ],
//           )),
//     );
//   }
// }