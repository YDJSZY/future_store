import 'package:flutter/material.dart';
import 'dart:math' show Random;
import '../../apiRequest/index.dart';
import '../../redux/index.dart';
import '../../utils/tools.dart';
import '../../components/toast/index.dart';

List positions = [
  [0, 0],
  [50, 10],
  [100, 8],
  [160, 20],
  [210, 30],
  [260, 10],
  [140, 130],
  [80, 140],
  [200, 200],
  [150, 250],
  [60, 250]
];

class Base extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Base();
  }
}

class _Base extends State<Base> with TickerProviderStateMixin {
  Map integralAccount = {'balance': ''};
  List tempPositions = positions;
  List rewardList = [];
  List randomNumList = [];
  Map currentEatRewrad;
  int currentEatIndex;
  AnimationController controllerOne;
  Animation<double> animationOne;
  AnimationController controllerTwo;
  Animation<double> animationTwo;

  @override
  void initState() {
    super.initState();
    instantiateShowToast();
    _getIntegralAccount(globalState.state.myInfo.infos['id']);
    _getEffective();
    setAnimationOne();
    setAnimationTwo();
  }

  _getIntegralAccount(userId) async {
    var res = await getIntegralAccount(userId);
    if (res['success']) {
      List data = res['data'];
      var _integralAccount = data.where((item) => item['symbol'] == 'PPTR').toList()[0];
      _integralAccount['balance'] = divPrecision(val: _integralAccount['balance']);
      setState(() {
        integralAccount = _integralAccount;
      });
    }
  }

  _getEffective() async {
    var res = await getEffective();
    var list = res['data']['rows'];
    list.add(list[0]);
    if (res['success']) {
      setState(() {
        rewardList = list;
      });
      getRandomNum(2);
    }
  }

  setAnimationOne() {
    controllerOne = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2000));
    // 通过 Tween 对象 创建 Animation 对象
    animationOne = Tween(begin: 0.0, end: -20.0).animate(controllerOne)
      ..addListener(() {
        if (animationOne.value == -20.0) { // 转完一圈后重置，接着运动
          controllerOne.reverse();
        } else if (animationOne.value == 0) {
          controllerOne.forward();
        }
        setState(() {});
      });
    controllerOne.forward();
  }

  setAnimationTwo() {
    controllerTwo = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));
    // 通过 Tween 对象 创建 Animation 对象
    animationTwo = Tween(begin: 0.0, end: -150.0).animate(controllerTwo)
      ..addListener(() {
        var isCompleted = animationTwo.isCompleted;
        if (isCompleted) {
          print('isCompleted');
          addBalance();
          controllerTwo.reset();
        }
      });
  }

  Widget buildBalance() {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 9, 12, 9),
      width: 170,
      decoration: BoxDecoration(
        color: Color(0xFF1C222F),
        borderRadius: BorderRadius.all(Radius.circular(13)),
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Image.asset('lib/assets/imgs/platform_token_ss.png', width: 16, height: 16,),
          ),
          Text(
            'PPTR',
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text(
              integralAccount['balance'].toString(),
              style: TextStyle(color: Colors.white, fontSize: 10)
            ),
          )
        ],
      ),
    );
  }

  Widget buildEarth() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 325,
        width: 323,
        margin: EdgeInsets.only(top: 40),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/imgs/earth.png'),
            fit: BoxFit.cover
          )
        ),
        child: Transform.translate(
          offset: Offset(0, animationOne.value),
          child: Container(
            height: 325,
            width: 323,
            child: Stack(
              children: buildReward().toList(),
            ),
          ),
        )
      ),
    );
  }

  getRandomNum(len) {
    randomNumList = [];
    generateRandomNum() {
      var randomNum = Random().nextInt(11);// 随机生成0到11的整数
      if (randomNumList.contains(randomNum)) {
        return generateRandomNum();
      }
      randomNumList.add(randomNum);
    }
    for (var i = 0; i < len; i++) {
      generateRandomNum();
    }
    print(randomNumList);
  }

  eat(reward, index) {
    currentEatRewrad = reward; // 保存当前点击的
    currentEatIndex = index;
    addBalance();
    //controllerTwo.forward();
  }

  addBalance() async {
    var amount = divPrecision(val: currentEatRewrad['amount']);
    var res = await receiveReward(currentEatRewrad['id']);
    if (!res['success']) {
      return showToast.error('网络错误，请稍后重试');
    }
    integralAccount['balance'] += amount; // 增加余额
    var _rewardList = rewardList;
    _rewardList[currentEatIndex] = null;
    setState(() {
      rewardList = _rewardList;
      integralAccount = integralAccount;
    });
    var newRewardList = _rewardList.where((item) => item != null).toList();
    if (newRewardList.length == 0) {
      _getEffective();
    }
  }

  List<Widget> buildReward() {
    tempPositions = positions;
    List<Widget> contentList = [];
    for (var i = 0; i < rewardList.length; i++) {
      var content;
      if (rewardList[i] == null) {
        content = Container();
        contentList.add(content);
        continue;
      }
      var detailPosition = positions[randomNumList[i]];
      var reward = divPrecision(val: rewardList[i]['amount']);
      content = Positioned(
        left: double.parse(detailPosition[0].toString()),
        top: double.parse(detailPosition[1].toString()),
        child: GestureDetector(
          onTap: () { eat(rewardList[i], i); },
          child: Transform.translate(
            offset: Offset(0, 0),
            child: Column(
              children: <Widget>[
                Image.asset('lib/assets/imgs/coin-s.png', width: 40, height: 40),
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(reward.toString(), style: TextStyle(color: Colors.white, fontSize: 8)),
                )
              ],
            ),
          )
        ),
      );
      contentList.add(content);
    }
    return contentList;
  }

  void dispose() {
    controllerOne.dispose();
    controllerTwo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 13, top: 40),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/imgs/home-bg.gif'),
            fit: BoxFit.cover
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildBalance(),
            buildEarth()
          ],
        ),
      )
    );
  }
}