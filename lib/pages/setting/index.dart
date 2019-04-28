import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../redux/index.dart';

var language = globalState.state.language.data;
var pricingType = globalState.state.pricingType.type;
var locale = globalState.state.locale.locale;

var languageType = {
  'en': language['english'], 
  'zh_CN': language['chinese'],
  'japanese': language['japanese'],
  'korean': language['korean'],
  'zh_TW': language['zh_TW']
};

List<List> settingList = [
  [
    {'left': language['vip'], 'right': language['not_yet_binding'], 'more': false},
    {'left': language['account_and_security'], 'more': true, 'link': ''}
  ],
  [
    {'left': language['my_harvest_address'], 'more': true, 'link': ''}
  ],
  [
    {'left': language['language'], 'right': languageType[locale], 'more': true, 'link': ''},
    {'left': language['pricing_transform'], 'right': '${language[pricingType]} ($pricingType)', 'more': true, 'link': ''},
    {'left': language['check_version'], 'more': true, 'link': ''}
  ],
  [
    {'left': language['login_out'], 'more': false, 'link': '/login'}
  ]
];

class Setting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Setting();
  }
}

class _Setting extends State<Setting> {
  goto(link) {
    if (link == null || link == '') return;
    Navigator.pushNamed(context, link);
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<dynamic, dynamic>(
      converter: (store) => store.state,//转换从redux拿回来的值
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Color(0xFFF3F4F6),
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Color(0xFF000000), //change your color here
            ),
            title: Text(state.language.data['setting'], style: TextStyle(color: Color(0xFF26262E), fontSize: 18),),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: Container(
            child: ListView.builder(
              itemCount: settingList.length,
              itemBuilder: (BuildContext context, int index) {
                var settingListItem = settingList[index];
                List<Widget> childList = [];
                settingListItem.forEach((item) {
                  var left = item['left'];
                  var right = item['right'];
                  var more = item['more'];
                  var link = item['link'];
                  var wrapper = GestureDetector(
                    onTap: () => goto(link),
                    child: Container(
                      padding: EdgeInsets.only(top: 18, bottom: 18),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 1, color: Color(0xFFF3F4F6)))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(left, style: TextStyle(color: Color(0xFF313131), fontSize: 15)),
                          Row(
                            children: <Widget>[
                              Text(right == null ? '' : right, style: TextStyle(color: Color(0xFF707070), fontSize: 13)),
                              more ? Padding(
                                padding: EdgeInsets.only(left: 9),
                                child: Icon(
                                  IconData(
                                    0xe69c, 
                                    fontFamily: 'iconfont'
                                  ),
                                  color: Color(0xFFA0A0A0),
                                  size: 14,
                                ),
                              ) : Container()
                            ],
                          )
                        ],
                      ),
                    )
                  );
                  childList.add(wrapper);
                });
                var content = Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.only(left: 17, right: 17),
                  child: Column(
                    children: childList,
                  ),
                );
                return content;
              }
            ),
          )
        );
      }
    );
  }
}