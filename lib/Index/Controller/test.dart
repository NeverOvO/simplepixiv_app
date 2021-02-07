import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class StrategicEditPageHedgeViewController extends StatefulWidget {
  final arguments;
  const StrategicEditPageHedgeViewController({Key key, this.arguments}) : super(key: key);

  @override
  _StrategicEditPageHedgeViewControllerState createState() =>
      _StrategicEditPageHedgeViewControllerState();
}

class _StrategicEditPageHedgeViewControllerState extends State<StrategicEditPageHedgeViewController> {


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      right: true,
      bottom: false,
      left: true,
      top: false,
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: Text('这里是最新图片', style: TextStyle(fontSize: 17)),
        ),
        body:ListView.builder(
          itemBuilder: (context,index){
            return Container(
              child: Text("ffffafasdasd",style: TextStyle(fontSize: 20,color: Colors.red),),
              height: 100,
            );
          },
          itemCount: 100,
        ),
      ),
    );
  }
}
