import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simplepixiv_app/Base/EventBus.dart';
import 'package:simplepixiv_app/Base/LocalStorage.dart';
import 'package:simplepixiv_app/Base/MyBotTextToast.dart';
class SettingViewController extends StatefulWidget {
  final arguments;
  const SettingViewController({Key key, this.arguments}) : super(key: key);

  @override
  _SettingViewControllerState createState() =>
      _SettingViewControllerState();
}

class _SettingViewControllerState extends State<SettingViewController> with AutomaticKeepAliveClientMixin {

  TextEditingController _apikeyController = TextEditingController();
  TextEditingController _numController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  String _apiKey = '';
  String _r18 = '0';
  String _keyword = '';
  String _num = '1';
  String _size1200 = 'true';

  //缓冲
  String _cacheSizeStr ='';

  @override
  void initState() {
    super.initState();
    _loadCache();
    _readConf();
  }

  void _readConf() async{
    _apiKey = await LocalStorageRead('userSettingApiKey') ?? '';
    _apikeyController.text = _apiKey;
    _r18 = await LocalStorageRead('userSettingR18') ?? '0';
    _num = await LocalStorageRead('userSettingNum') ?? '1';
    _numController.text = _num;
    _size1200 = await LocalStorageRead('userSettingSize1200') ?? 'true';
    setState(() {

    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      right: true,
      bottom: false,
      left: true,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('全局设置', style: TextStyle(fontSize: 17)),
          actions: [
            IconButton(
              icon: Icon(Icons.check_rounded,size: 25,color: Colors.white,),
              onPressed: (){
                FocusScope.of(context).requestFocus(FocusNode());
                LocalStorageWrite('userSettingApiKey',_apikeyController.text);
                LocalStorageWrite('userSettingNum',_numController.text);
                bus.emit('updateDate');
                showMyCustomText('保存成功');
              },
            ),
          ],
        ),
        body:GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          behavior: HitTestBehavior.opaque,
          child: ListView(
            children: [
              Container(
                child:Text('请填写ApiKey:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),),
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              ),
              Container(
                child:Text('(不填写每日有访问次数,且单次请求数量为1张)',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300,fontSize: 11),),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                    ),
                    hintText: '请输入APIKEY',
                    hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
                  ),
                  controller: _apikeyController,
                  autocorrect:false,
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.black,fontSize: 14),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                child:Text('请填写单次数量:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),),
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                    ),
                    hintText: '请输入单次数量',
                    hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2)
                  ],
                  controller: _numController,
                  autocorrect:false,
                  style: TextStyle(color: Colors.black,fontSize: 14),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                child:Text('以上两项修改后请按右上角保存',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300,fontSize: 11),),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              ),
              Container(
                child:Text('请选择模式:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),),
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              ),
              Row(
                children: [
                  SizedBox(width: 10,),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          color: _r18 == '0' ? Colors.blue : Colors.transparent,
                          //边框圆角设置
                          border: Border.all(width: 1, color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                        child: Text('和谐',style: TextStyle(fontSize: 15,color: Colors.black),),
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        setState(() {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _r18 = '0';
                          LocalStorageWrite('userSettingR18',_r18);
                          bus.emit('updateDate');
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          color: _r18 == '1' ? Colors.blue : Colors.transparent,
                          //边框圆角设置
                          border: Border.all(width: 1, color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                        child: Text('罪恶',style: TextStyle(fontSize: 15,color: Colors.black),),
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        setState(() {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _r18 = '1';
                          LocalStorageWrite('userSettingR18',_r18);
                          bus.emit('updateDate');
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          color: _r18 == '2' ? Colors.blue : Colors.transparent,
                          //边框圆角设置
                          border: Border.all(width: 1, color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                        child: Text('混乱',style: TextStyle(fontSize: 15,color: Colors.black),),
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      ),
                      onTap: (){
                        setState(() {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _r18 = '2';
                          LocalStorageWrite('userSettingR18',_r18);
                          bus.emit('updateDate');
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10,),
                ],
              ),
              SizedBox(height: 10,),
              Container(
                child:Text('是否开启缩放:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),),
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              ),
              Row(
                children: [
                  SizedBox(width: 10,),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          color: _size1200 == 'false' ? Colors.blue : Colors.transparent,
                          //边框圆角设置
                          border: Border.all(width: 1, color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                        child: Text('关闭',style: TextStyle(fontSize: 15,color: Colors.black),),
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        setState(() {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _size1200 = 'false';
                          LocalStorageWrite('userSettingSize1200',_size1200);
                          bus.emit('updateDate');
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          color: _size1200 == 'true' ? Colors.blue : Colors.transparent,
                          //边框圆角设置
                          border: Border.all(width: 1, color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                        child: Text('开启',style: TextStyle(fontSize: 15,color: Colors.black),),
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        setState(() {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _size1200 = 'true';
                          LocalStorageWrite('userSettingSize1200',_size1200);
                          bus.emit('updateDate');
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10,),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Container(
                    child:Text('缓冲大小:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),),
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  ),
                  Expanded(
                    child: Container(
                      child:Text(_cacheSizeStr,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400),),
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      alignment: Alignment.centerRight,
                    ),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      //边框圆角设置
                      border: Border.all(width: 1, color: Colors.blue),
                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                    ),
                    child: Text('清理缓冲',style: TextStyle(fontSize: 15,color: Colors.black),),
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  ),
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    setState(() {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _clearCache();
                    });
                  },
                ),
              )
            ],
          ),

        )
      ),
    );
  }

  //清理缓冲套件
  Future<Null> _loadCache() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      double value = await _getTotalSizeOfFilesInDir(tempDir);
      /*tempDir.list(followLinks: false,recursive: true).listen((file){
        //打印每个缓存文件的路径
      print(file.path);
    });*/
      print('临时目录大小: ' + value.toString());
      setState(() {
        _cacheSizeStr = _renderSize(value);
      });
    } catch (err) {
      print(err);
    }
  }
  /// 递归方式 计算文件的大小
  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    try {
      if (file is File) {
        int length = await file.length();
        return double.parse(length.toString());
      }
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        double total = 0;
        if (children != null)
          for (final FileSystemEntity child in children)
            total += await _getTotalSizeOfFilesInDir(child);
        return total;
      }
      return 0;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  void _clearCache() async {
    //此处展示加载loading
    try {
      Directory tempDir = await getTemporaryDirectory();
      //删除缓存目录
      await delDir(tempDir);
      await _loadCache();
      showMyCustomText('清除缓存成功');
    } catch (e) {
      print(e);
      showMyCustomText('清除缓存失败');
    } finally {

    }
  }
  ///递归方式删除目录
  Future<Null> delDir(FileSystemEntity file) async {
    try {
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        for (final FileSystemEntity child in children) {
          await delDir(child);
        }
      }
      await file.delete();
    } catch (e) {
      print(e);
    }
  }

  _renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = List()
      ..add('B')
      ..add('K')
      ..add('M')
      ..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }
}