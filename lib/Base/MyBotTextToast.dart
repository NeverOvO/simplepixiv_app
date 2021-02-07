import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

//自定义简化double转化问题
myDoubleTryOrZero(String num){
  return (double.tryParse(num.toString()) ?? 0.00);
}

showMyCustomText(String text,{int seconds = 2}) {
  BotToast.showCustomText(
    duration: Duration(seconds: seconds),
    onlyOne: true,
    clickClose: false,//点击关闭
    crossPage: true,//跨页面
    ignoreContentClick: true,//穿透
    backgroundColor: Colors.transparent,
    backButtonBehavior: BackButtonBehavior.none,
    animationDuration: Duration(milliseconds: 200),
    animationReverseDuration: Duration(milliseconds: 200),
    toastBuilder: (_) => Align(
      alignment: Alignment(0, 0.8),
      child: Container(
        decoration: new BoxDecoration(
          //背景
          color: Colors.blue,
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Text(text,style: TextStyle(fontSize: 13,color: Colors.white),),
            ),
          ],
        ),
      ),
    ),
  );
}

//帮助文本弹窗
showMyCustomHelpText(String text,{double fontSize = 14.0}) {
  BotToast.showCustomText(
    duration: Duration(seconds: 600),
    onlyOne: true,
    clickClose: true,//点击关闭
    crossPage: false,//跨页面
    ignoreContentClick: false,//穿透
    backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
    backButtonBehavior: BackButtonBehavior.close,
    animationDuration: Duration(milliseconds: 200),
    animationReverseDuration: Duration(milliseconds: 200),
    toastBuilder: (_) => Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      alignment: Alignment(0, 0),
      child: Container(
        decoration: new BoxDecoration(
          //背景
          color: Color.fromRGBO(37, 50, 58, 1),
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Text(text,style: TextStyle(fontSize:fontSize,color: Colors.white),),
            ),
          ],
        ),
      ),
    ),
  );
}

showMyCustomLoading(String text,{double fontSize = 14.0,int seconds = 10}) {

  // int backgroundColor = 0x42000000;
  // int seconds = 10;
  // bool clickClose = true;
  // bool allowClick = true;
  // bool ignoreContentClick = false;
  // bool crossPage = true;
  // int animationMilliseconds = 200;
  // int animationReverseMilliseconds = 200;
  // BackButtonBehavior backButtonBehavior = BackButtonBehavior.none;

  BotToast.showCustomLoading(
      clickClose: false,//点击关闭
      allowClick: false,//
      backButtonBehavior: BackButtonBehavior.none,
      ignoreContentClick: false,
      animationDuration: Duration(milliseconds: 200),
      animationReverseDuration: Duration(milliseconds: 200),
      duration: Duration(seconds: seconds,),
      backgroundColor: Color(0x42000000),
      align: Alignment.center,
      toastBuilder: (cancelFunc) {
        return _CustomLoadWidget(cancelFunc: cancelFunc,text: text,);
      });
}
class _CustomLoadWidget extends StatefulWidget {
  final CancelFunc cancelFunc;
  final String text;
  const _CustomLoadWidget({Key key, this.cancelFunc,this.text}) : super(key: key);

  @override
  __CustomLoadWidgetState createState() => __CustomLoadWidgetState();
}

class __CustomLoadWidgetState extends State<_CustomLoadWidget>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    animationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
    animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FadeTransition(
              opacity: animationController,
              child: Icon(Icons.airplanemode_on_sharp,size: 30,color: Colors.redAccent,),
            ),
            SizedBox(height: 10,),
            Text(widget.text,style: TextStyle(color: Colors.black),),
          ],
        ),
      ),
    );
  }
}

String unicodeOrAsciiList2String(List<int> data){
  //获取字符串长度对应的数据
  List<int> lengthList= data.sublist(1,3);
  //获取字符串长度的int值
  int length=listToValue(lengthList);
  if(length==0){     //长度为0
    return '';
  }else{             //长度不为0
    List<int> strList= data.sublist(3,data.length);
    String result='';
    if(data[0]==1){       //ASCII编码
      strList.forEach((value){
        result+=String.fromCharCode(value);
      });
      return result;
    }else if(data[0]==2){ //UNICODE编码
      for(int i=0;i<strList.length~/2;i++){
        List<int> current=  strList.sublist(i*2,(i+1)*2);
        result+=String.fromCharCode(listToValue(current));
      }
      return result;
    }
  }
}

//将数组转换成int值  一般接收的时候需要
// ignore: missing_return
int  listToValue(List<int> data){
  //data  [a0,a1]
  switch(data.length){
    case 2:
      return (data[1]<<8)+data[0];

      break;
    case 4:
      return data[0]+(data[1]<<8)+(data[2]<<16)+(data[3]<<24);

      break;
    case 8:
      return data[0]+(data[1]<<8)+(data[2]<<16)+(data[3]<<24)+
          (data[4]<<32)+(data[5]<<40)+(data[6]<<48)+(data[7]<<56);

      break;

    case 16:
      return data[0]+(data[1]<<8)+(data[2]<<16)+(data[3]<<24)+
          (data[4]<<32)+(data[5]<<40)+(data[6]<<48)+(data[7]<<56)+
          (data[8]<<64)+(data[9]<<72)+(data[10]<<80)+(data[11]<<88)+
          (data[12]<<96)+(data[13]<<104)+(data[14]<<112)+(data[15]<<116);

      break;

  }
}

class OssUtil {

  //获取验证文本域
  static String _policyText =
      '{"expiration": "2099-01-01T12:00:00.000Z","conditions": [["content-length-range", 0, 1048576000]]}';//UTC时间+8=北京时间

  //进行utf8编码
  // ignore: non_constant_identifier_names
  static List<int> _policyText_utf8 = utf8.encode(_policyText);
  //进行base64编码
  static String policy= base64.encode(_policyText_utf8);

  //再次进行utf8编码
  // ignore: non_constant_identifier_names
  static List<int> _policy_utf8 = utf8.encode(policy);

  // 工厂模式
  factory OssUtil() => _getInstance();

  static OssUtil get instance => _getInstance();
  static OssUtil _instance;

  OssUtil._internal();

  static OssUtil _getInstance() {
    if (_instance == null) {
      _instance = new OssUtil._internal();
    }
    return _instance;
  }

  /*
  *获取signature签名参数
  */
  String getSignature(String _accessKeySecret){
    //进行utf8 编码
    // ignore: non_constant_identifier_names
    List<int> AccessKeySecretUtf8 = utf8.encode(_accessKeySecret);
    //通过hmac,使用sha1进行加密
    List<int> signaturePre = new Hmac(sha1, AccessKeySecretUtf8).convert(_policy_utf8).bytes;
    //最后一步，将上述所得进行base64 编码
    String signature = base64.encode(signaturePre);
    print(signature);
    return signature;
  }

  // ignore: slash_for_doc_comments
  /**
   * 生成上传上传图片的名称 ,获得的格式:photo/20171027175940_oCiobK
   * 可以定义上传的路径uploadPath(Oss中保存文件夹的名称)
   * @param uploadPath 上传的路径 如：/photo
   * @return photo/20171027175940_oCiobK
   */
  String getImageUploadName(String uploadPath,String filePath) {
    String imageMame = "";
    var timestamp = new DateTime.now().millisecondsSinceEpoch;
    imageMame =timestamp.toString()+getRandom(6);
    if(uploadPath!=null&&uploadPath.isNotEmpty){
      imageMame=uploadPath+"/"+imageMame;
    }
    String imageType=filePath?.substring(filePath?.lastIndexOf("."),filePath?.length);
    return imageMame+imageType;
  }

  String getImageName(String filePath) {
    String imageMame = "";
    var timestamp = new DateTime.now().millisecondsSinceEpoch;
    imageMame =timestamp.toString()+getRandom(6);
    String imageType=".jpg";
    return imageMame+imageType;
  }

  /*
  * 生成固定长度的随机字符串
  * 在原基础上添加了0123456789
  * */
  String getRandom(int num) {
    String alphabet = '0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    String left = '';
    for (var i = 0; i < num; i++) {
//    right = right + (min + (Random().nextInt(max - min))).toString();
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    return left;
  }

  /*
  * 根据图片本地路径获取图片名称
  * */
  String getImageNameByPath(String filePath) {
    // ignore: null_aware_before_operator
    return filePath?.substring(filePath?.lastIndexOf("/")+1,filePath?.length);
  }
}
