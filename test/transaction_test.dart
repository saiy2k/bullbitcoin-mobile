import 'package:bb_mobile/_pkg/wallet/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

import 'transaction_test.data.dart';

/// Test scenarios:
///  DONE: 0 local txns, 3 txns from bdk
///  3 unconfirmed local txns; 2 of those txns confirmed from bdk
///   DONE: 1 of them have labels
///   DONE: 2 of them have labels
///   DONE: all of them have labels
///  2 unconfirmed and 1 confirmed local txns; same from bdk
///  2 unconfirmed and 1 confirmed local txns, 2 confirmed and 1 unconfirmed from bdk
///  2 unconfirmed and 1 confirmed local txns, 3 confirmed from bdk
void main() {
  group('getTransaction()', () {
    test('should sync 3 txns from bdk', () async {
      final WalletTx wtx = WalletTx();
      final testWallet = getEmptyWallet();
      final bdkWallet = FakeBdkWalletWithTxns();

      final (syncedWallet, syncErr) =
          await wtx.getTransactions(wallet: testWallet, bdkWallet: bdkWallet);

      expect(syncErr, isNull);
      expect(syncedWallet?.transactions.length, 3);
    });

    group('3 unconfirmed local txns; 2 of those txns confirmed from bdk', () {
      test('1 of them have labels', () async {
        const String tx1Label = 'tx0Label';
        final WalletTx wtx = WalletTx();
        final testWallet = getWalletWith3Unconfirmed(label: [tx1Label]);
        final bdkWallet = FakeBdkWalletWithTxns(confs: [true, false, true]);

        final (syncedWallet, syncErr) =
            await wtx.getTransactions(wallet: testWallet, bdkWallet: bdkWallet);

        expect(syncErr, isNull);
        expect(syncedWallet?.transactions.length, 3);

        final bdkTxns = await bdkWallet.listTransactions(true);

        final tx1 = syncedWallet?.transactions[0];
        final tx2 = syncedWallet?.transactions[1];
        final tx3 = syncedWallet?.transactions[2];
        final btx1 = bdkTxns[0];
        final btx2 = bdkTxns[1];
        final btx3 = bdkTxns[2];

        expect(tx1?.timestamp, equals(btx1.confirmationTime?.timestamp));
        expect(tx1?.height, equals(btx1.confirmationTime?.height));
        expect(tx1?.label, equals(tx1Label));

        expect(tx2?.timestamp, equals(0));
        expect(tx2?.height, equals(0));
        expect(tx2?.label, isNull);

        expect(tx3?.timestamp, equals(btx3.confirmationTime?.timestamp));
        expect(tx3?.height, equals(btx3.confirmationTime?.height));
        expect(tx3?.label, isNull);
      });

      test('2 of them have labels', () async {
        const String tx1Label = 'tx0Label';
        const String tx2Label = 'tx1Label';
        final WalletTx wtx = WalletTx();
        final testWallet = getWalletWith3Unconfirmed(label: [tx1Label, tx2Label]);
        final bdkWallet = FakeBdkWalletWithTxns(confs: [true, false, true]);

        final (syncedWallet, syncErr) =
            await wtx.getTransactions(wallet: testWallet, bdkWallet: bdkWallet);

        expect(syncErr, isNull);
        expect(syncedWallet?.transactions.length, 3);

        final bdkTxns = await bdkWallet.listTransactions(true);

        final tx1 = syncedWallet?.transactions[0];
        final tx2 = syncedWallet?.transactions[1];
        final tx3 = syncedWallet?.transactions[2];
        final btx1 = bdkTxns[0];
        final btx2 = bdkTxns[1];
        final btx3 = bdkTxns[2];

        expect(tx1?.timestamp, equals(btx1.confirmationTime?.timestamp));
        expect(tx1?.height, equals(btx1.confirmationTime?.height));
        expect(tx1?.label, equals(tx1Label));

        expect(tx2?.timestamp, equals(0));
        expect(tx2?.height, equals(0));
        expect(tx2?.label, equals(tx2Label));

        expect(tx3?.timestamp, equals(btx3.confirmationTime?.timestamp));
        expect(tx3?.height, equals(btx3.confirmationTime?.height));
        expect(tx3?.label, isNull);
      });

      test('All of them have labels', () async {
        const String tx1Label = 'tx0Label';
        const String tx2Label = 'tx1Label';
        const String tx3Label = 'tx2Label';
        final WalletTx wtx = WalletTx();
        final testWallet = getWalletWith3Unconfirmed(label: [tx1Label, tx2Label, tx3Label]);
        final bdkWallet = FakeBdkWalletWithTxns(confs: [true, false, true]);

        final (syncedWallet, syncErr) =
            await wtx.getTransactions(wallet: testWallet, bdkWallet: bdkWallet);

        expect(syncErr, isNull);
        expect(syncedWallet?.transactions.length, 3);

        final bdkTxns = await bdkWallet.listTransactions(true);

        final tx1 = syncedWallet?.transactions[0];
        final tx2 = syncedWallet?.transactions[1];
        final tx3 = syncedWallet?.transactions[2];
        final btx1 = bdkTxns[0];
        final btx2 = bdkTxns[1];
        final btx3 = bdkTxns[2];

        expect(tx1?.timestamp, equals(btx1.confirmationTime?.timestamp));
        expect(tx1?.height, equals(btx1.confirmationTime?.height));
        expect(tx1?.label, equals(tx1Label));

        expect(tx2?.timestamp, equals(0));
        expect(tx2?.height, equals(0));
        expect(tx2?.label, equals(tx2Label));

        expect(tx3?.timestamp, equals(btx3.confirmationTime?.timestamp));
        expect(tx3?.height, equals(btx3.confirmationTime?.height));
        expect(tx3?.label, equals(tx3Label));
      });
    });
  });
}
