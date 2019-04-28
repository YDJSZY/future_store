import '../../redux/index.dart';

var language = globalState.state.language.data;

getTransactionType(type) {
  switch (type) {
    case 'recharge':
      return language['deposit']; // 充值
    case 'pickCoin':
      return language['withdraw']; // 提币
    case 'pickCoinFee':
      return language['withdraw_fee']; // 提币手续费
    case 'transferCost':
      return language['transfer_cost']; // 转账发送
    case 'transferObtain':
      return language['transfer_obtain']; // 转账接受
    case 'transferFee':
      return language['transfer_fee']; // 转账手续费
    case 'changeless':
      return language['mining_award']; // 挖矿奖励
    case 'dynamic':
      return language['community_award']; // 社区奖励
    case 'direct':
      return language['extension_award']; // 推广奖励
    case 'indirect':
      return language['under_command_award']; // 伞下分佣
    case 'gao_ding_sale_fee':
      return language['gao_ding_sale_fee']; // 寄卖手续费
    case 'gao_ding_repo':
      return language['gao_ding_repo']; // 高定回购
    case 'buy_gao_ding':
      return language['buy_gao_ding']; // 购买高定
    case 'buy_goods':
      return language['buy_goods']; // 购买商品
    default:
      return '';
  }
}

getTransactionStatus(status) {
  switch (status) {
    case 1:
      return language['confirmed'];
    case 0:
      return language['applying'];
    case -1:
      return language['fail'];
    default:
      return '';
  }
}

getChangeType(type) {
  switch (type) {
    case 1:
      return '+';
    case -1:
      return '-';
    default:
      return '';
  }
}