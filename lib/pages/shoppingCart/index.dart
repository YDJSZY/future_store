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
  List shoppingCartList = [];

  @override
  void initState() {
    super.initState();
    _getShoppingCart();
  }

  _getShoppingCart() async {
    var res = await getShoppingCart();
    translateGoodsList(res['goods_list']);
    setState(() {
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
    setState(() {
      shoppingCartList = data;
    });
  }

  manage() {
    setState(() {
      isDeleteHandle = !isDeleteHandle;
    });
  }

  selectAllStore(data) {
    print(data);
    return true;
  }

  Widget buildCartItemHeader(data, index) {
    var _isSelect = data['_isSelect'] == null ? false : data['_isSelect'];
    return Container(
      padding: EdgeInsets.only(left: 12, top: 16, bottom: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Color(0xFFF3F4F6)))
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CustomCheckBox(_isSelect, () => selectAllStore(data)),
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
      var _isSelect = goods['_isSelect'] == null ? false : goods['_isSelect'];
      var container = Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CustomCheckBox(_isSelect, () {})
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
    int len = shoppingCartList.length;
    for (var i = 0; i < len; i++) {
      var container = Container(
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Column(
          children: <Widget>[
            buildCartItemHeader(shoppingCartList[i], i),
            buildCartItemBody(shoppingCartList[i]['goods_list'], i)
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
        );
      }
    );
  }
}