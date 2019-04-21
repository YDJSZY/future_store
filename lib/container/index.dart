import 'package:flutter/material.dart';
import 'init.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../redux/actions.dart';

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
    return Scaffold(
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
      floatingActionButton: new StoreConnector<dynamic, VoidCallback>(
        converter: (store) {
          // Return a `VoidCallback`, which is a fancy name for a function
          // with no parameters. It only dispatches an Increment action.
          return () => store.dispatch({'type': Actions.SetLanguage, 'data': 'en'});
        },
        builder: (context, callback) {
          return new FloatingActionButton(
            // Attach the `callback` to the `onPressed` attribute
            onPressed: callback,
            tooltip: 'Increment',
            child: new Icon(Icons.add),
          );
        },
      ),
    );
  }
}