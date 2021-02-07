import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class HomePageViewController extends StatefulWidget {
  final arguments;
  const HomePageViewController({Key key, this.arguments}) : super(key: key);

  @override
  _HomePageViewControllerState createState() =>
      _HomePageViewControllerState();
}

class _HomePageViewControllerState extends State<HomePageViewController> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;


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
    super.build(context);
    return SafeArea(
      right: true,
      bottom: false,
      left: true,
      top: false,
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor:Colors.deepOrange,
              title: Container(
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CommunityMaterialIcons.emoticon_kiss_outline),
                    Container(
                      child: Text('24小时记录'),
                      alignment: Alignment.center,
                    )
                  ],
                ),
              ),
              floating: true,
            ),
            SliverGrid(
              delegate:
              SliverChildBuilderDelegate((BuildContext context, int position) {
                return Container(
                  padding: EdgeInsets.fromLTRB(3, 5, 3, 0),
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      print('单击-打开此条');
                    },
                    onDoubleTap: (){
                      print('双击-喜欢');
                    },
                    onLongPress: (){
                      print('部分可选操作');
                    },
                    child: Container(
                      decoration: ShapeDecoration(
                          image: DecorationImage(image: AssetImage('images/IMG_3099.jpg'),fit: BoxFit.fitHeight),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),
                      ),
                      alignment: Alignment.center,
                      child:  Container(
                        child: Container(//标题显示7个子
                          child: Row(
                            children: [
                              Expanded(child: Text('这里是标题阿啊这里是标题阿啊这里是标题阿啊',style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w600),maxLines: 1,overflow: TextOverflow.ellipsis,),),
                              GestureDetector(
                                child: Icon(Icons.download_sharp,color: Colors.white,size: 25,),
                                behavior: HitTestBehavior.opaque,
                                onTap: (){
                                  print('下载');
                                },
                              )
                            ],
                          ),
                          color: Color.fromRGBO(0, 0, 0, 0.6),
                          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          alignment: Alignment.center,
                          height:45,
                        ),
                        alignment: Alignment.bottomCenter,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                );
              },
                childCount: 1000,
              ),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  // crossAxisCount:2,
                maxCrossAxisExtent:MediaQuery.of(context).size.width/2.0,
                  mainAxisSpacing: 0.0,
                  crossAxisSpacing: 0.0,
                  childAspectRatio: 0.825,
              ),

            ),
          ],
        ),
      ),
    );
  }
}
