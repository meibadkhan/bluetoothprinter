import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printer/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrintService{
static  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

   List<BluetoothDevice>? devices =[];

  //BluetoothDevice? _device;
  bool connected = false;


  Future<void> initPlatformState(context) async {








    List<BluetoothDevice> devices1 = [];
    try {
      devices1 = await bluetooth.getBondedDevices();
    } on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          connected = true;
          print("bluetooth device state: connected");

          break;
        case BlueThermalPrinter.DISCONNECTED:
          connected = false;

          print("bluetooth device state: disconnected");

          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          connected = false;
          print("bluetooth device state: disconnect requested");

          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:

            connected = false;
            print("bluetooth device state: bluetooth turning off");

           break;
        case BlueThermalPrinter.STATE_OFF:
          connected = false;

          print("bluetooth device state: bluetooth off ");
          print(BlueThermalPrinter.STATE_OFF);


          break;
        case BlueThermalPrinter.STATE_ON:
          connected = false;

          print("bluetooth device state: bluetooth on");

          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          connected = false;
          print("bluetooth device state: bluetooth turning on");

          break;
        case BlueThermalPrinter.ERROR:
          connected = false;
          print("bluetooth device state: error");

          break;
        default:
          print(state);
          break;
      }
    });



  //  _devices =devices.first;
    devices1.forEach((element) {
      // if (element.name == "InnerPrinter") {
      // _devices = element as List<BluetoothDevice>?;
      // print(element.name);
      // print(element.address);
      // }
      devices!.add(element);
    });



  }
}