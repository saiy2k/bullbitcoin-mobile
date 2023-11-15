import 'package:bb_mobile/_pkg/wallet/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

import 'transaction_test.data.dart';

void main() {
  group('getTransaction()', () {
    test('should return synced transaction list', () async {
      final WalletTx wtx = WalletTx();
      final testWallet = getTestWallet();
      /*
      final bdkWallet = await bdk.Wallet.create(
        descriptor: await bdk.Descriptor.create(
          descriptor: 'dummydescriptor',
          network: bdk.Network.Testnet,
        ),
        network: bdk.Network.Testnet,
        databaseConfig:
            const bdk.DatabaseConfig.sqlite(config: bdk.SqliteDbConfiguration(path: '')),
      );
      */
      final bdkWallet = FakeBdkWallet();
      final (syncedWallet, syncErr) =
          await wtx.getTransactions(wallet: testWallet, bdkWallet: bdkWallet);
      print(syncedWallet?.transactions[2]);
    });
  });
}
