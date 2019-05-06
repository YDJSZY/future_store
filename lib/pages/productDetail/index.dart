import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../apiRequest/index.dart';
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import '../../components/toast/index.dart';
import '../../components/backToTop/index.dart';

class ProductDetail extends StatefulWidget {
  final String goodsId;

  ProductDetail(this.goodsId);

  @override
  State<StatefulWidget> createState() {
    return _ProductDetail();
  }
}

class _ProductDetail extends State<ProductDetail> {
  Map productDetail = {};
  int cartCount = 0;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    instantiateShowToast();
    _getProductDetail();
    _getShoppingCart();
  }

  _getProductDetail() async {
    var res = await getProductDetail(widget.goodsId);
    setState(() {
      productDetail = json.decode(res);
    });
  }

  _getShoppingCart() async {
    var res = await getShoppingCart();
    setState(() {
      cartCount = res['total']['cart_goods_number'];
    });
  }

  addCart(language) async{
    if (productDetail['goods'] == null) return null;
    if (productDetail['goods']['goods_number'] == 0) {
      return showToast.error(language['understock']);
    }
    var data = {
      'goods_id': widget.goodsId,
      'number': 1,
      'store_id': 0,
      'parent': 0
    };
    var res = await addShoppingCart(json.encode(data));
    res = json.decode(res);
    if (res['error'] == 0) {
      showToast.success(language['added_successfully']);
      setState(() {
        cartCount = res['goods_number'];
      });
    } else if (res['error'] == 2) {
      showToast.error(language['understock']);
    }
  }

  Widget buildProductImg() {
    return Container(
      width: double.infinity,
      height: 375,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(productDetail['goods']['goods_img']),
          fit: BoxFit.fill
        )
      )
    );
  }

  Widget buildProductDesc(language) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 18, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(productDetail['goods']['market_price'], style: TextStyle(color: Color(0xFFE60012), fontSize: 18)),
                Text('${language['current_inventory']} ${productDetail['goods']['goods_number']}', style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 13)),
              ],
            ),
          ),
          Text(productDetail['goods']['goods_name'], style: TextStyle(color: Color(0xFF313131), fontSize: 15)),
          Padding(
            padding: EdgeInsets.only(top: 11),
            child: Text(productDetail['goods']['goods_brief'], style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget buildExpress(language) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.fromLTRB(17, 19, 17, 19),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 21),
            child: Text(language['freight'], style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 13)),
          ),
          Text('${language['express']} ${productDetail['shippingFee']['shipping_fee_formated']}', style: TextStyle(color: Color(0xFF313131), fontSize: 13)),
        ],
      ),
    );
  }

  Widget buildProductEvaluation(language) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(17, 16, 17, 16),
      margin: EdgeInsets.only(top: 8),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('${language['goods_evaluation']} (${productDetail['comment_all']['allmen']})', style: TextStyle(color: Color(0xFF313131), fontSize: 15)),
              GestureDetector(
                child: Text(language['look_at_all'], style: TextStyle(color: Color(0xFF70A6FF), fontSize: 13)),
              )
            ],
          ),
          productDetail['good_comment'].length > 0 ?
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Text(productDetail['good_comment'][0]['username'], style: TextStyle(color: Color(0xFF313131), fontSize: 13))
                  ),
                  Text(productDetail['good_comment'][0]['content'], maxLines: 4, overflow: TextOverflow.ellipsis, style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 12))
                ],
              ),
            ) : Container()
        ],
      ),
    );
  }

  Widget buildStoreInfo(language) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.fromLTRB(17, 23, 17, 23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image.network(productDetail['goods']['shopinfo']['brand_thumb'], width: 40, height: 40),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(productDetail['goods']['shopinfo']['shop_name'], style: TextStyle(color: Color(0xFF313131), fontSize: 13)),
                  )
                ],
              ),
              GestureDetector(
                child: Row(
                  children: <Widget>[
                    Icon(
                      IconData(
                        0xe6c7, 
                        fontFamily: 'iconfont'
                      ),
                      color: Color(0xFF70A6FF),
                      size: 13,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 3),
                      child: Text(language['goods_tel'], style: TextStyle(color: Color(0xFF70A6FF), fontSize: 13))
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  buildProductDetail(language) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 14, bottom: 14),
          alignment: Alignment.center,
          color: Color(0xFFF3F4F6),
          child: Text(language['detail_introduce'], style: TextStyle(color: Color(0xFF313131), fontSize: 13),),
        ),
        Html(
          data: productDetail['goods_desc']
        ),
        Container(
          padding: EdgeInsets.only(top: 14, bottom: 14),
          alignment: Alignment.center,
          color: Color(0xFFF3F4F6),
          child: Text(language['Its_over'], style: TextStyle(color: Color(0xFF313131), fontSize: 13),),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<dynamic, Map>(
      converter: (store) => store.state.language.data,//转换从redux拿回来的值
      builder: (context, language) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Color(0xFF26262E), //change your color here
            ),
            title: Text(language['goods_detail'], style: TextStyle(color: Color(0xFF26262E), fontSize: 18),),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          backgroundColor: Color(0xFFF3F4F6),
          body: Container(
            color: Color(0xFFEEEEEE),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: productDetail['goods'] == null
                ? Container() : Column(
                children: <Widget>[
                  buildProductImg(),
                  buildProductDesc(language),
                  buildExpress(language),
                  buildProductEvaluation(language),
                  buildStoreInfo(language),
                  buildProductDetail(language)
                ],
              )
            )
          ),
          bottomNavigationBar: BottomAppBar(
            child: Container(
              height: 56,
              padding: EdgeInsets.only(left: 16, right: 16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Positioned(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              IconData(
                                0xe6b5, 
                                fontFamily: 'iconfont'
                              ),
                              color: Color(0xFF535353),
                              size: 22,
                            ),
                            Text(language['shopping_cart'], style: TextStyle(color: Color(0xFF535353), fontSize: 10))
                          ],
                        ),
                      ),
                      Positioned(
                        left: 13,
                        top: 2,
                        child: Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Color(0xFFF85721),
                            shape: BoxShape.circle,
                          ),
                          child: Text(cartCount.toString(), style: TextStyle(color: Colors.white, fontSize: 10)),
                        ),
                      )
                    ],
                  ),
                  FlatButton(
                    onPressed: () => addCart(language),
                    padding: EdgeInsets.only(top: 11, bottom: 11, left: 28, right: 28),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    color: Color(0xFFF8AE33),
                    child: Text(language['add_cart'], style: TextStyle(color: Colors.white, fontSize: 15)),
                  )
                ],
              ),
            )
          ),
          floatingActionButton: FloatingActionButton(
            foregroundColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            elevation: 0, // 未点击时阴影值
            highlightElevation: 0,
            onPressed: () {},
            child: BackToTop(_scrollController),
          )
        );
      }
    );
  }
}