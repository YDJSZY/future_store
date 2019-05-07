import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../apiRequest/index.dart';
import '../../components/checkBox/index.dart';

class ShoppingCart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShoppingCart();
  }
}

class _ShoppingCart extends State<ShoppingCart> {
  bool isDeleteHandle = false;
  int totalCount;
  Map shoppingCartData = {'goods_list': []};

  @override
  void initState() {
    super.initState();
    _getShoppingCart();
  }

  _getShoppingCart() async {
    var res = await getShoppingCart();
    var data = translateGoodsList(res['goods_list']);
    res['goods_list'] = data;
    setState(() {
      shoppingCartData = res;
      totalCount = res['total']['real_goods_count'];
    });
  }

  translateGoodsList(data) {
    data.forEach((item) {
      if (!(item['goods_list'] is List)) {
        List tempList = [];
        Map goods = item['goods_list'];
        goods.forEach((key, value) {
          tempList.add(value);
        });
        item['goods_list'] = tempList;
      }
    });
    return data;
  }

  manage() {
    setState(() {
      isDeleteHandle = !isDeleteHandle;
    });
  }

  select(status, target, {parentIndex}) {
    target['_isSelect'] = status;
    if (target['goods_list'] != null) {
      return target['goods_list'].forEach((item) {
        return select(status, item);
      });
    } else if (parentIndex != null) {
      var _data = shoppingCartData['goods_list'][parentIndex]['goods_list'].where((item) => item['_isSelect'] == true).toList();
      if (_data.length == shoppingCartData['goods_list'][parentIndex]['goods_list'].length) {
        shoppingCartData['goods_list'][parentIndex]['_isSelect'] = true;
      } else {
        shoppingCartData['goods_list'][parentIndex]['_isSelect'] = false;
      }
    }
    setState(() {
      shoppingCartData = shoppingCartData;
    });
  }

  num calculateTotalPrice() {
    num totalPay = 0;
    shoppingCartData['goods_list'].forEach((item) {
      item['goods_list'].forEach((goods) {
        if (goods['_isSelect'] == true) {
          var number = num.parse(goods['goods_number']);
          var price = num.parse(goods['goods_price']);
          var goodstotalPrice = price * number;
          totalPay += goodstotalPrice;
        }
      });
    });
    return totalPay;
  }

  getSelectStatus(data) {
    if (data['goods_list'].length == 0) return false;
    var _data = data['goods_list'].where((item) => item['_isSelect'] == true).toList();
    return _data.length == data['goods_list'].length;
  }

  Widget buildCartItemHeader(data, index) {
    var _isSelect = getSelectStatus(data);
    return Container(
      padding: EdgeInsets.only(left: 12, top: 16, bottom: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Color(0xFFF3F4F6)))
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CustomCheckBox(_isSelect, () => select(!_isSelect, data)),
          Padding(
            padding: EdgeInsets.only(left: 9),
            child: Text(data['ru_name'], style: TextStyle(color: Color(0xFF26262E), fontSize: 15)),
          )
        ],
      ),
    );
  }

  Widget buildCartItemBody(data, index) {
    List<Widget> content = [];
    int len = data.length;
    for (var i = 0; i < len; i++) {
      var goods = data[i];
      var goodsThumb = goods['goods_thumb'];
      var goodsName = goods['goods_name'];
      var goodsPrice = goods['goods_price'];
      var number = goods['goods_number'];
      var _isSelect = goods['_isSelect'] == null ? false : goods['_isSelect'];
      var container = Container(
        margin: EdgeInsets.only(bottom: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CustomCheckBox(_isSelect, () => select(!_isSelect, goods, parentIndex: index)),
            Padding(
              padding: EdgeInsets.only(left: 5, right: 12),
              child: Image.network(goodsThumb, width: 80, height: 80),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 2, bottom: 10),
                    child: Text(goodsName, style: TextStyle(color: Color(0xFF3B3C40), fontSize: 13), overflow: TextOverflow.ellipsis, maxLines: 2)
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('PPTR $goodsPrice', style: TextStyle(color: Color(0xFFE60012), fontSize: 13), overflow: TextOverflow.ellipsis, maxLines: 1),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                              child: OutlineButton(
                                onPressed: () {},
                                padding: EdgeInsets.all(0),
                                color: Color(0xFF70A6FF),
                                child: Text('-', style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 12)),
                              ),
                            ),
                            Container(
                              width: 43,
                              height: 21,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: BorderDirectional(top: BorderSide(width: 1, color: Color(0xFFDCDCDC)), bottom: BorderSide(width: 1, color: Color(0xFFDCDCDC)))
                              ),
                              child: Text(number, style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 10),),
                            ),
                            Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                              child: OutlineButton(
                                onPressed: () {},
                                padding: EdgeInsets.all(0),
                                color: Color(0xFF70A6FF),
                                child: Text('+', style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 12)),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      );
      content.add(container);
    }
    return Container(
      padding: EdgeInsets.only(top: 17, left: 12, right: 15, bottom: 23),
      child: Column(
        children: content
      )
    );
  }

  List<Widget> buildShoppingList() {
    List<Widget> content = [];
    int len = shoppingCartData['goods_list'].length;
    for (var i = 0; i < len; i++) {
      var container = Container(
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Column(
          children: <Widget>[
            buildCartItemHeader(shoppingCartData['goods_list'][i], i),
            buildCartItemBody(shoppingCartData['goods_list'][i]['goods_list'], i)
          ],
        ),
      );
      content.add(container);
    }
    return content;
  }

  @override
  Widget build(BuildContext context) {
    var _totalCount = totalCount == null ? '' : totalCount;
    var totalPay = calculateTotalPrice().toString();
    var topSelectAll = getSelectStatus(shoppingCartData);
    return new StoreConnector<dynamic, Map>(
      converter: (store) => store.state.language.data,//转换从redux拿回来的值
      builder: (context, language) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Color(0xFF26262E), //change your color here
            ),
            title: Text(language['shopping_cart'], style: TextStyle(color: Color(0xFF26262E), fontSize: 18)),
            centerTitle: true,
            backgroundColor: Colors.white,
            actions: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 16),
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: manage,
                  child: Text(language[isDeleteHandle ? 'complete' : 'manage'], style: TextStyle(color: Color(0xFF70A6FF), fontSize: 13)),
                ),
              )
            ],
          ),
          backgroundColor: Color(0xFFF3F4F6),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Column(
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 16,
                        bottom: 16
                      ),
                      child: Text('${language['total']}$_totalCount${language['piece']}${language['treasure']}', style: TextStyle(color: Color(0xFF26262E), fontSize: 11),),
                    ),
                  ),
                  Column(
                    children: buildShoppingList().toList(),
                  )
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Container(
              height: 50,
              color: Colors.white,
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        CustomCheckBox(topSelectAll, () => select(!topSelectAll, shoppingCartData)),
                        Padding(
                          padding: EdgeInsets.only(left: 3),
                          child: Text(language['check_all'], style: TextStyle(color: Color(0xFF26262E), fontSize: 13)),
                        )
                      ],
                    ),
                  ),
                  isDeleteHandle ? Container(): Text('${language['total_price']}：$totalPay PPTR', style: TextStyle(color: Color(0xFF26262E), fontSize: 13)),
                  isDeleteHandle ?
                  FlatButton(
                    onPressed: () {},
                    padding: EdgeInsets.only(top: 8, bottom: 8, left: 28, right: 28),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    color: Color(0xFFF85721),
                    child: Text(language['delete'], style: TextStyle(color: Colors.white, fontSize: 15)),
                  ) :
                  FlatButton(
                    onPressed: () {},
                    padding: EdgeInsets.only(top: 8, bottom: 8, left: 28, right: 28),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    color: Color(0xFF70A6FF),
                    child: Text(language['go_to_settlement'], style: TextStyle(color: Colors.white, fontSize: 15)),
                  )
                ],
              ),
            ),
          )
        );
      }
    );
  }
}