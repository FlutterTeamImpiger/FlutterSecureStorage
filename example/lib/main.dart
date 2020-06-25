import 'package:flutter/material.dart';
import 'package:store_critical_data/store_critical_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  /// Create storage
  final _storage = StoreCriticalData();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Impiger Secure Stroage Plugin'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                child: Text('Save Methods',
                    style:
                    TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
              ),
              ButtonTheme(
                minWidth: 300.0,
                height: 44.0,
                child: RaisedButton(
                  onPressed: () {
                    // Write String value
                    _storage.writeString(key: "userName", value: "AntonyLeoRuban");
                  },
                  child:
                  Text("Save -> String",style:
                  TextStyle(color: Colors.white),),color: Colors.blue,padding: EdgeInsets.all(1.0),
                ),
              ),
              ButtonTheme(
                minWidth: 300.0,
                height: 44.0,
                child: RaisedButton(
                  onPressed: () {
                    // Write Boolean value
                    _storage.writeBoolean(key: "isLogged", value: true);
                  },
                  child:
                  Text("Save -> Boolen",style:
                  TextStyle(color: Colors.white),),color: Colors.blue,padding: EdgeInsets.all(1.0),
                ),
              ),
              ButtonTheme(
                minWidth: 300.0,
                height: 44.0,
                child: RaisedButton(
                  onPressed: () {
                    // Write Int value
                    _storage.writeInt(key: "intValue", value: 100);
                  },
                  child:
                  Text("Save -> Int",style:
                  TextStyle(color: Colors.white),),color: Colors.blue,padding: EdgeInsets.all(1.0),
                ),
              ),
              ButtonTheme(
                minWidth: 300.0,
                height: 44.0,
                child: RaisedButton(
                  onPressed: () {
                    // Write Dobule value
                    _storage.writeDouble(key: "amout", value: 25852525);
                  },
                  child:
                  Text("Save -> Double",style:
                  TextStyle(color: Colors.white),),color: Colors.blue,padding: EdgeInsets.all(1.0),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                child: Text('Load Methods',
                    style:
                    TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
              ),
              ButtonTheme(
                minWidth: 300.0,
                height: 44.0,
                child: RaisedButton(
                  onPressed: () {
                    // Read String value
                    _storage.readString(key: "userName");
                  },
                  child:
                  Text("Load -> String",style:
                  TextStyle(color: Colors.white),),color: Colors.blue,padding: EdgeInsets.all(1.0),
                ),
              ),
              ButtonTheme(
                minWidth: 300.0,
                height: 44.0,
                child: RaisedButton(
                  onPressed: () {
                    // Read Boolean value
                    _storage.readBoolean(key: "isLogged");
                  },
                  child:
                  Text("Load -> Boolen",style:
                  TextStyle(color: Colors.white),),color: Colors.blue,padding: EdgeInsets.all(1.0),
                ),
              ),
              ButtonTheme(
                minWidth: 300.0,
                height: 44.0,
                child: RaisedButton(
                  onPressed: () {
                    // Read Int value
                    _storage.readInt(key: "intValue");
                  },
                  child:
                  Text("load -> Int",style:
                  TextStyle(color: Colors.white),),color: Colors.blue,padding: EdgeInsets.all(1.0),
                ),
              ),
              ButtonTheme(
                minWidth: 300.0,
                height: 44.0,
                child: RaisedButton(
                  onPressed: () {
                    // Read Double value
                    _storage.readDoubleNew(key: "amout");
                  },
                  child:
                  Text("load -> Double",style:
                  TextStyle(color: Colors.white),),color: Colors.blue,padding: EdgeInsets.all(1.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
