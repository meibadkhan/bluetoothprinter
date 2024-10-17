 import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
 import 'package:permission_handler/permission_handler.dart';
import 'package:printer/printService.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MaterialApp(home: new MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

PrintService printService = PrintService();
class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    super.initState();



  printService.initPlatformState(context);

  check();

  }
  check()async{

      SharedPreferences preferences = await SharedPreferences.getInstance();


       if(preferences.getString("name")!=null){
     var value =   await PrintService.bluetooth.connect(BluetoothDevice(preferences.getString("name"), preferences.getString("address"))).catchError((e){
       print("Error => ibad"+e.toString());


     });
     if(value==null){
       printService.connected = true;
     }

       }




  }

 khan()async{
    var pp= await PrintService.bluetooth.isConnected;
   var ppp=    await PrintService.bluetooth.isOn;
   if(pp==true){
     printService.connected = true;

   }
   if(ppp==false){

     PrintService.bluetooth.openSettings;
   }
   setState(() {

   });

 }



  @override
  Widget build(BuildContext context) {
//khan();
    return   Scaffold(
        appBar: AppBar(
          title: Text('Blue Thermal Printer'),
          actions: [
            ElevatedButton(onPressed: (){
             PrintService.bluetooth.print3Column("ibad", "khan", "ibad", 1);
            }, child: Text("Print"))
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
    Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [

Text(printService.connected?"Connected":"Not Connected"),
    printService.connected==false?ElevatedButton(

          onPressed: () {




if(printService.devices!.length>0){
  printService.devices!.clear();

}
printService.initPlatformState(context);
khan();






          }, child: Text("Scan")):SizedBox(),
    printService.connected ?ElevatedButton(

          onPressed: ()async{
            SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.remove("name");
  prefs.remove("address");

            PrintService.bluetooth.disconnect();

           printService.connected = false;
           setState(() {

           });
          }, child:Text("Disconnect")):SizedBox(),

  ],
),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                    itemCount:printService.devices!.length,

                    itemBuilder: (context,index){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                            onTap: ()async{
SharedPreferences prefs = await SharedPreferences.getInstance();
                            var pr=    await PrintService.bluetooth.connect(BluetoothDevice(printService.devices![index].name, printService.devices![index].address)).catchError((e){
                              print("Error => ibad"+e.toString());


                            });

                            if(pr!=null){
                              prefs.setString("name", printService.devices![index].name.toString());
                              prefs.setString("address", printService.devices![index].address.toString());
                              printService.connected =true;
                              setState(() {

                              });
                            }else{

                              print("not Connected");
                            }







                            },
                            title: Text(printService.devices![index].name.toString())),
                      );
                    })
              ],
            ),
          ),
        ),
       
    );
  }

  // List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
  //   List<DropdownMenuItem<BluetoothDevice>> items = [];
  //   if (_devices.connected) {
  //     items.add(DropdownMenuItem(
  //       child: Text('NONE'),
  //     ));
  //   } else {
  //     _devices.forEach((device) {
  //       items.add(DropdownMenuItem(
  //         child: Text(device.name ?? ""),
  //         value: device,
  //       ));
  //     });
  //   }
  //   return items;
  // }

  // void _connect() {
  //   if (_device != null) {
  //     bluetooth.isConnected.then((isConnected) {
  //       if (isConnected == true) {
  //         bluetooth.connect(_device).catchError((error) {
  //           setState(() => _connected = false);
  //         });
  //         setState(() => _connected = true);
  //       }
  //     });
  //   } else {
  //     show('No device selected.');
  //   }
  // }

  // void _disconnect() {
  //   bluetooth.disconnect();
  //   setState(() => _connected = false);
  // }


}
 