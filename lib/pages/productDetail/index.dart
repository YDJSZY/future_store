import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../apiRequest/index.dart';
import 'dart:convert';

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

  @override
  void initState() {
    super.initState();
    _getProductDetail();
  }
  _getProductDetail() async {
    var res = await getProductDetail(widget.goodsId);
    setState(() {
      productDetail = json.decode(res);
    });
  }

  Widget buildProductImg() {
    return Container(
      width: double.infinity,
      height: 375,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(productDetail['goods']['goods_img']),
          fit: BoxFit.cover
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
              child: productDetail['goods'] == null
                ? Container() : Column(
                children: <Widget>[
                  buildProductImg(),
                  buildProductDesc(language),
                  buildExpress(language),
                  buildProductEvaluation(language),
                  buildStoreInfo(language),
                ],
              )
            )
          )
        );
      }
    );
  }
}