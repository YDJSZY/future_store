import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_redux/flutter_redux.dart';
import '../../apiRequest/index.dart';
import '../../pages/productDetail/index.dart';

class Store extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Store();
  }
}

class _Store extends State<Store> {
  List slideList = [];
  List category = [];
  List recommendProduct = [];
  List ecommerceData = [];

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
    _getRecommendProduct(productData);
    _getEcommerceData(productData);
    setState(() {
      slideList = slideData[0]['data']['list']; // 轮播图数据
    });
  }

  _getRecommendProduct(productData) async {
    var data = productData.where((item) {
      return item['data']['allValue']['categorySOption'] == '1549';
    }).toList()[0]['data'];
    Map params = {
      'number': data['allValue']['number'],
      'cat_id': data['allValue']['categorySOption']
    };
    var res = await getProduct(params);
    setState(() {
      recommendProduct = res['product'];
    });
  }

  _getEcommerceData(productData) async {
    var data = productData.where((item) {
      return item['data']['allValue']['categorySOption'] == '1548';
    }).toList()[0]['data'];
    Map params = {
      'number': data['allValue']['number'],
      'cat_id': data['allValue']['categorySOption']
    };
    var res = await getProduct(params);
    setState(() {
      ecommerceData = res['product'];
    });
  }

  _getCategory() async {
    var indexRes = await getCategoryIndex();
    var res = await getCategory(indexRes['index']);
    List data = json.decode(res['view']['data']);
    var nav = data.where((item) {
      return item['module'] == 'nav';
    }).toList()[0]['data']['list'];
    setState(() {
      category = nav;
    });
  }

  gotoSearch() {

  }

  gotoDetail(goodsId) {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => ProductDetail(goodsId))
    );
  }

  Widget buildSearch(Map language) {
    return Stack(
      children: <Widget>[
        Positioned(
          //top: 100,
          child: buildSlide()
        ),
        Positioned(
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 32, 16, 8),
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
          ),
        )
      ],
    );
  }

  Widget buildSlide() {
    return Container(
      height: 260,
      child: slideList.length == 0 ? null : Swiper(
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return new Image.network(
            slideList[index]['img'],
            fit: BoxFit.fill,
            height: 260.0,
          );
        },
        itemCount: slideList.length,
        pagination: SwiperPagination()
      ),
    );
  }

  List<Widget> buildCategoryList() {
    List<Widget> contentList = [];
    List<Widget> rowChildren = [];
    int len = category.length;
    for (var i = 0; i < len; i++) { // 5个就放到一个Row里
      var img = category[i]['img'];
      var name = category[i]['desc'];
      var content = Container(
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
          children: <Widget>[
            Container(
              width: 50,
              height: 50,
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
      rowChildren.add(content);
      if ((i + 1) % 5 == 0) {
        var row = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: rowChildren,
        );
        contentList.add(row);
        rowChildren = [];
      }
    }
    return contentList;
  }

  Widget buildCategory() {
    return Container(
      color: Color(0xFFF3F4F6),
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.only(left: 16, top: 16, right: 16),
      child: Column(
        children: buildCategoryList().toList(),
      )
    );
  }

  Widget buildProduct(String img, String name, String price, String goodsId) {
    return GestureDetector(
      onTap: () => gotoDetail(goodsId),
      child: Container(
        width: 166,
        child: Column(
          children: <Widget>[
            Container(
              height: 166,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(img),
                  fit: BoxFit.fill
                )
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.only(top: 11, left: 12, bottom: 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(name, style: TextStyle(fontSize: 13, color: Color(0xFF313131)), overflow: TextOverflow.ellipsis,),
                  ),
                  Text(price, style: TextStyle(fontSize: 13, color: Color(0xFFE60012))),
                ],
              )
            ),
          ],
        ),
      )
    );
  }

  Widget buildRecommendProduct() {
    return Container(
      color: Color(0xFFF3F4F6),
      padding: EdgeInsets.all(16),
      height: 301,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text('推荐', style: TextStyle(color: Color(0xFF313131), fontSize: 15)),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal, // 水平滚动,
              children: (() {
                List<Widget> children = [];
                recommendProduct.forEach((item) {
                  var img = item['goods_img'];
                  var name = item['title'];
                  var price = item['shop_price'];
                  var goodsId = item['goods_id'];
                  var content = Container(
                      margin: EdgeInsets.only(right: 11),
                      child: buildProduct(img, name, price, goodsId),
                    );
                  children.add(content);
                });
                return children;
              })(),
            ),
          )
        ],
      ),
    );
  }

  Widget buildEcommerceProduct() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            color: Color(0xFFF3F4F6),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text('电商专区', style: TextStyle(color: Color(0xFF313131), fontSize: 15)),
                ),
                Column(
                  children: (() {
                    List<Widget> children = [];
                    List<Widget> temp = [];
                    for (var i = 0; i < ecommerceData.length; i++) {
                      var item = ecommerceData[i];
                      var img = item['goods_img'];
                      var name = item['title'];
                      var price = item['shop_price'];
                      var goodsId = item['goods_id'];
                      var wrap = (i + 1) % 2 == 0;
                      var content = Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(right: wrap ? 0 : 11),
                          child: buildProduct(img, name, price, goodsId),
                        ),
                      );
                      temp.add(content);
                      if (wrap) {
                        var r = Container(
                          margin: EdgeInsets.only(bottom: 8),
                            child: Row(
                            children: temp,
                          )
                        );
                        children.add(r);
                        temp = [];
                      }
                    }
                    return children;
                  })(),
                )
              ]
            )
          )
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<dynamic, Map>(
      converter: (store) => store.state.language.data,//转换从redux拿回来的值
      builder: (context, language) {
        return Scaffold(
          body: Container(
            color: Color(0xFFEEEEEE),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  buildSearch(language),
                  buildCategory(),
                  buildRecommendProduct(),
                  buildEcommerceProduct()
                ],
              ),
            )
          )
        );
      },
    );
  }
}