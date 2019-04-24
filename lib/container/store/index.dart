import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_redux/flutter_redux.dart';
import '../../apiRequest/index.dart';

class Store extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Store();
  }
}

class _Store extends State<Store> {
  List slideList = [];
  List category = [];

  @override
  void initState() {
    super.initState();
    _getStoreHomeData();
    _getCategory();
  }

  _getStoreHomeData() async {
    var res = await getStoreHomeData();
    var dataList = json.decode(res['view']['data']);
    var slideData = dataList.where((item) => item['module'] == 'slide').toList();
    var productData = dataList.where((item) => item['module'] == 'product').toList();
    setState(() {
      slideList = slideData[0]['data']['list']; // 轮播图数据
    });
    print(productData);
  }

  _getCategory() async {
    var res = await getCategory();
    List data = json.decode(res)['category'];
    data..add(data[0]);
    data..add(data[0]);
    data..add(data[0]);
    data..add(data[0]);
    data..add(data[0]);
    data..add(data[0]);
    setState(() {
      category = data..add(data[0]);
    });
  }

  gotoSearch() {

  }

  Widget buildSearch(Map language) {
    return Container(
      //margin: EdgeInsets.only(top: 50),
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      color: Color(0xFF1F1F1F),
      child: GestureDetector(
        onTap: gotoSearch,
        child: Container(
          height: 32,
          padding: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: Color(0xFF494A4A)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(language['store_search_placeholder'], style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 13)),
              Icon(Icons.search, size: 18, color: Colors.white,)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSlide() {
    return Container(
      height: 157,
      child: slideList.length == 0 ? null : Swiper(
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return new Image.network(
            slideList[index]['img'],
            fit: BoxFit.fill,
            height: 157.0,
          );
        },
        itemCount: slideList.length,
        //viewportFraction: 0.8,
        //scale: 0.9,
        pagination: SwiperPagination()
      ),
    );
  }

  List<Widget> buildCategoryList() {
    List<Widget> contentList = [];
    for (var i = 0; i < category.length; i++) {
      var img = category[i]['cat_img'];
      var name = category[i]['name'];
      var noMarginRight = (i + 1) % 5 == 0;
      var content = Container(
        margin: EdgeInsets.only(right: noMarginRight ? 0 : 24, bottom: 16),
        child: Column(
          children: <Widget>[
            Container(
              width: 50,
              child: CircleAvatar(
                backgroundImage: NetworkImage(img),
              )
            ),
            Padding(
              padding: EdgeInsets.only(top: 2),
              child: Text(name, style: TextStyle(color: Color(0xFF313131), fontSize: 11)),
            )
          ],
        ),
      );
      contentList.add(content);
    }
    return contentList;
  }

  Widget buildCategory() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 16, top: 16, right: 16),
      child: Wrap(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: buildCategoryList().toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<dynamic, Map>(
      converter: (store) => store.state.language.data,//转换从redux拿回来的值
      builder: (context, language) {
        return Scaffold(
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  buildSearch(language),
                  buildSlide(),
                  buildCategory()
                ],
              ),
            )
          )
        );
      },
    );
  }
}