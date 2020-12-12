import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:flutter/services.dart';


String location = '';
List<bool> permissions = [false, false, false];
String number ='';
List<SimCard> simCard = <SimCard>[];
List<String> numbers;

// class PermissionService {
//   final PermissionHandler permissionHandler = PermissionHandler();
//   bool permissionsAccepted = false;
//   Future<bool> _requestPermission() async {
//     print('************ FOURTH **************');
//     var result = await permissionHandler.requestPermissions(
//         [PermissionGroup.phone, PermissionGroup.location, PermissionGroup.sms]);
//     print('RESULT is : $result');
//     print(
//         'location permission is  ${result[PermissionGroup.location] == PermissionStatus.granted}');
//     print(
//         'phone permission is  ${result[PermissionGroup.phone] == PermissionStatus.granted}');
//     print(
//         'sms permission is  ${result[PermissionGroup.sms] == PermissionStatus.granted}');
//     permissions = [
//       result[PermissionGroup.location] == PermissionStatus.granted,
//       result[PermissionGroup.phone] == PermissionStatus.granted,
//       result[PermissionGroup.sms] == PermissionStatus.granted
//     ];

//     print(permissions);
//     // print(result == PermissionStatus.denied);
//     permissionsAccepted =
//         result[PermissionGroup.location] == PermissionStatus.granted &&
//             result[PermissionGroup.phone] == PermissionStatus.granted &&
//             result[PermissionGroup.sms] == PermissionStatus.granted;
//     // _HomePageState().getLocation(result[PermissionGroup.location] == PermissionStatus.granted);

//     if (permissionsAccepted) {
//       print('returning true');
//       print('permissons are accepted');
//       location = 'hyderabad';
//       return true;
//     }
//     return false;
//   }

//   Future<bool> requestPermission({Function onPermissionDenied}) async {
//     print('************ THIRD **************');
//     var granted = await _requestPermission();

//     print('GRANTED is $granted');

//     if (!granted) {
//       onPermissionDenied();
//     }
//     return granted;
//   }

//   Future<bool> hasPhonePermission() async {
//     return hasPermission(PermissionGroup.phone);
//   }

//   Future<bool> hasPermission(PermissionGroup permission) async {
//     var permissionStatus =
//         await permissionHandler.checkPermissionStatus(permission);
//     return permissionStatus == PermissionStatus.granted;
//   }
// }

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    print('************ FIRST **************');
    // permissionAccessPhone();
    permissionAccessPhone();
    // WidgetsBinding.instance.addObserver(PermissionService()._requestPermission());

    super.initState();
  }

  final PermissionHandler permissionHandler = PermissionHandler();
  bool permissionsAccepted = false;

  Future<bool> _requestPermission() async {
    print('************ FOURTH **************');
    var result = await permissionHandler.requestPermissions(
        [PermissionGroup.phone, PermissionGroup.location, PermissionGroup.sms]);
    print('RESULT is : $result');
    print(
        'location permission is  ${result[PermissionGroup.location] == PermissionStatus.granted}');
    print(
        'phone permission is  ${result[PermissionGroup.phone] == PermissionStatus.granted}');
    print(
        'sms permission is  ${result[PermissionGroup.sms] == PermissionStatus.granted}');
    permissions = [
      result[PermissionGroup.location] == PermissionStatus.granted,
      result[PermissionGroup.phone] == PermissionStatus.granted,
      result[PermissionGroup.sms] == PermissionStatus.granted
    ];

    print(permissions);
    permissionsAccepted =
        result[PermissionGroup.location] == PermissionStatus.granted &&
            result[PermissionGroup.phone] == PermissionStatus.granted &&
            result[PermissionGroup.sms] == PermissionStatus.granted;

    if (permissionsAccepted) {
      setState(() {
        permissions = [true, true, true];
        location = 'finally accepted';
        initMobileNumberState(result[PermissionGroup.phone] == PermissionStatus.granted);
      });
      print('returning true');
      print('permissons are accepted');
      return true;
    }
    setState(() {
      location = 'not accepted';
    });
    return false;
  }

  Future<bool> requestPermission({Function onPermissionDenied}) async {
    print('************ THIRD **************');
    var granted = await _requestPermission();

    print('GRANTED is $granted');

    if (!granted) {
      onPermissionDenied();
    }
    return granted;
  }


  void permissionAccessPhone() {
    print('************ SECOND **************');
    requestPermission(onPermissionDenied: () {
      print('Permission was denied');
    });
  }

  Future<void> initMobileNumberState(bool value) async{
    print('initmobileNumberState was called');
    if(!value){
      print('Inside if Condition');
      await MobileNumber.requestPhonePermission;
      return;
    }
    // ignore: unused_local_variable
    String mobileNumber;
    try {
      print('Inside a try block');
      mobileNumber = await MobileNumber.mobileNumber;
      print('mobileNumber: $mobileNumber');
      simCard = await MobileNumber.getSimCards;
      print('simcard: $simCard');
    } on PlatformException catch (e) {
      print('Inside a catch block');
      debugPrint("Failed to get mobile number because of '${e.message}'");
    }
    if(!mounted) return;
    numbers = simCard.map((SimCard sim) => "${sim.number}").toList();
  
    print(numbers);
    // addActualNumber(numbers);
    print(number);
    for(int i=0; i<numbers.length; i++){
      if(numbers[i] != null){
        setState(() {
          print('comparing number ${numbers[i]}');
          number = numbers[i];
          
        });
      }else{
        setState(() {
          print('number was not equal');
          number = '';
          
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hello')),
      body: Container(
        child: Center(
          child: Text('$location, $number'),
        ),
      ),
    );
  }
}
