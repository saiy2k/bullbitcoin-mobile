import 'package:bb_mobile/_model/address.dart';
import 'package:bb_mobile/_model/transaction.dart';

class Labeller {
  static String? getLabelForTxn(Transaction tx, Address adrs) {
    if (tx.label != null) {
      return tx.label;
    } else if (adrs.label != null) {
      return adrs.label;
    } else {
      return null;
    }
  }

  static String? getLabelForAddress(Address adrs, Transaction tx) {
    if (adrs.label != null) {
      return adrs.label;
    } else if (tx.label != null) {
      return tx.label;
    } else {
      return null;
    }
  }
}
