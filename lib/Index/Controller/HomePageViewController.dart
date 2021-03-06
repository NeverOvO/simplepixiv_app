import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simplepixiv_app/Base/EventBus.dart';
import 'package:simplepixiv_app/Base/LocalStorage.dart';
import 'package:simplepixiv_app/Base/MyBotTextToast.dart';
import 'package:simplepixiv_app/Index/Http/HttpRequest.dart';
import 'package:simplepixiv_app/Index/Model/PicModel.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
class HomePageViewController extends StatefulWidget {
  final arguments;
  const HomePageViewController({Key key, this.arguments}) : super(key: key);

  @override
  _HomePageViewControllerState createState() =>
      _HomePageViewControllerState();
}

class _HomePageViewControllerState extends State<HomePageViewController> with AutomaticKeepAliveClientMixin {
  TextEditingController _ketwordController = TextEditingController();
  ScrollController _controller = ScrollController();

  @override
  bool get wantKeepAlive => true;

  String _nowUrl = baseUrl + '?';
  String _apiKey = '';
  String _r18 = '0';
  String _num = '1';
  String _size1200 = 'true';

  bool _isKeyWordType = false;
  final BaseCacheManager _cacheManager = DefaultCacheManager();
  List<PicResponerList> _list = [];
  PicResponerModel _data;

  @override
  void initState() {
    super.initState();
    _readConf();

    bus.on('updateDate', (object) {
      _readConf();
    });

  }


  void _readConf() async{
    _apiKey = await LocalStorageRead('userSettingApiKey') ?? '';
    _r18 = await LocalStorageRead('userSettingR18') ?? '0';
    _num = await LocalStorageRead('userSettingNum') ?? '1';
    _size1200 = await LocalStorageRead('userSettingSize1200') ?? 'true';
    _nowUrl = baseUrl + '?' + 'num=' + _num + '&size1200=' + _size1200 + '&r18=' + _r18;
    if(_ketwordController.text != ''){
      _nowUrl = _nowUrl + '&keyword=' + _ketwordController.text;
    }
    if(_apiKey != ''){
      _nowUrl = _nowUrl + '&apikey=' + _apiKey;
    }
  }

  Future _getRedomPic() async{
    showMyCustomLoading('正在加载,请等待');
    var response= await Dio().get(_nowUrl);
    if(response.statusCode == 200){
      // print(response.data);
      if(!mounted){
        return;
      }
      setState(() {
        _data = PicResponerModel.fromJson(response.data);
        _list = _data.data;
      });
    }else{
      showMyCustomText('遇到错误,请重试');
    }
    BotToast.cleanAll();
  }
  @override
  void dispose() {
    super.dispose();
    bus.off('updateDate');
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
        extendBody: true,
        appBar: AppBar(
          title: Text('随机抽卡', style: TextStyle(fontSize: 17)),
          leading: IconButton(
            icon: Container(
              child: Text('关键字',style: TextStyle(fontSize: 11,color:_isKeyWordType == false ?  Colors.white : Colors.amber),),
              alignment: Alignment.center,
            ),
            onPressed: (){
              setState(() {
                if(_isKeyWordType == false){
                  _isKeyWordType = true;
                }else{
                  _isKeyWordType = false;
                  _ketwordController.text = '';
                  bus.emit('updateDate');
                }
              });
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh,color: Colors.white,),
              onPressed: (){
                FocusScope.of(context).requestFocus(FocusNode());
                if (_list.length > 0) Timer(Duration(milliseconds: 500), () => _controller.jumpTo(_controller.position.minScrollExtent));
                _readConf();
                _getRedomPic();
              },
            ),
          ],
        ),
        body:GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },

          child: Column(
            children: [
              Offstage(
                offstage: _isKeyWordType == true ? false : true,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
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
                      hintText: '请输入关键字',
                      hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                    ),
                    controller: _ketwordController,
                    autocorrect:false,
                    // keyboardType: TextInputType,
                    style: TextStyle(color: Colors.black,fontSize: 13),
                    onChanged: (val){
                      bus.emit('updateDate');
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _controller,
                  itemBuilder: (context,index){
                    return Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            child: CachedNetworkImage(
                              imageUrl: _list[index].url,
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              filterQuality:FilterQuality.low,
                            ),
                            alignment: Alignment.center,
                          ),
                          Container(
                            color: Color.fromRGBO(0, 0, 0, 0.4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                ),
                                                child: Text('PID:' + _list[index].pid,style: TextStyle(fontSize: 10),),
                                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                              ),
                                              onTap: (){
                                                Clipboard.setData(ClipboardData(text: _list[index].pid));
                                                showMyCustomText( 'PID:' + _list[index].pid + '已复制到剪贴板');
                                              },
                                              behavior: HitTestBehavior.opaque,
                                            ),
                                            SizedBox(width: 5,),
                                            GestureDetector(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                ),
                                                child: Text('UID:' + _list[index].uid, style: TextStyle(fontSize: 10),),
                                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                              ),
                                              onTap: (){
                                                Clipboard.setData(ClipboardData(text: _list[index].pid));
                                                showMyCustomText( 'UID:' + _list[index].uid + '已复制到剪贴板');
                                              },
                                              behavior: HitTestBehavior.opaque,
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Text('作者:' + _list[index].author,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                              ),
                                            ),
                                          ],
                                        ),
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                                      ),
                                      Container(
                                        child: Text(_list[index].title,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.download_sharp,size: 26,color: Colors.white,),
                                  onPressed: () async{
                                    showMyCustomText('下载开始...');
                                    var status = await Permission.storage.status;
                                    if (!status.isGranted) {
                                      status = await Permission.storage.request();
                                      print(status);
                                      return;
                                    }
                                    var response = await Dio().get(_list[index].url, options: Options(responseType: ResponseType.bytes));
                                    final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data), quality: 100,);
                                    showMyCustomText(result != '' ? '保存成功' : '保存失败');

                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5,),
                          GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4, //每行三列
                                  childAspectRatio: 3 //显示区域宽高相等
                              ),
                              itemCount: _list[index].tags.length,
                              itemBuilder: (context, indexT) {
                                return GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    ),
                                    child: Text(_list[index].tags[indexT],overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(fontSize: 11),),
                                    padding: EdgeInsets.fromLTRB(3, 2, 3, 2),
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                  ),
                                  onTap: (){
                                    Clipboard.setData(ClipboardData(text: _list[index].tags[indexT]));
                                    showMyCustomText( _list[index].tags[indexT] + '已复制到剪贴板');
                                  },
                                  behavior: HitTestBehavior.opaque,
                                );
                              }
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: _list.length ,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//
// if (_page == 1) {
// _list = AnnoumcementListResponerModel.from(response['data']).list;
// } else {
// _list.addAll(AnnoumcementListResponerModel.from(response['data']).list);
// }
// _hasNextPage = AnnoumcementListResponerModel.from(response['data']).page["hasNextPage"];
