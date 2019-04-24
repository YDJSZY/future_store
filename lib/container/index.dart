import 'package:flutter/material.dart';
import 'init.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../pages/account/login/index.dart';

class FutureStore extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FutureStore();
  }
}

class _FutureStore extends State<FutureStore> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  setCurrentPageIndex(index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<dynamic, int>(
        converter: (store) => store.state.myInfo.infos['id'],//转换从redux拿回来的值
        builder: (context, id) {
          print(id);
          return id == null ? Login() :
            Scaffold(
              body: containerList[_currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Color(0xFF1F1F1F),
                currentIndex: _currentIndex,
                onTap: setCurrentPageIndex,
                fixedColor: Color(0xFFF0F5F8),
                unselectedItemColor: Color(0xFF55595F),
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      IconData(
                        0xe6a5, 
                        fontFamily: 'iconfont'
                      ), 
                      //size: 24
                    ),
                    title: new Text('基地'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      IconData(
                        0xe6ab, 
                        fontFamily: 'iconfont'
                      )
                    ),
                    title: new Text('商城'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      IconData(
                        0xe698, 
                        fontFamily: 'iconfont'
                      )
                    ),
                    title: new Text('创客'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      IconData(
                        0xe6b3, 
                        fontFamily: 'iconfont'
                      )
                    ),
                    title: new Text('我的'),
                  ),
                ]
              ),
            );
        }
    );
  }
}