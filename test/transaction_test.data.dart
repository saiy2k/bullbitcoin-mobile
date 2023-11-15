// ignore: dangling_library_doc_comments
import 'package:bb_mobile/_model/address.dart';
import 'package:bb_mobile/_model/transaction.dart';
import 'package:bb_mobile/_model/wallet.dart';
import 'package:bdk_flutter/bdk_flutter.dart' as bdk;

/// https://github.com/simpleledger/slp-unit-test-data
/// https://github.com/BlueWallet/BlueWallet/tree/master/tests/unit
///
/// 1. Create a imported wallet with
///  5 confirmed transactions as below
///    3 sent:
///      2 conf, label: Pay for TB, amount: 0.00000500 btc
///        from Addr1
///      40 conf, label: null, amount: 0.00045600 btc
///        from Addr2
///      598 conf, label: Gift to Kiran, amount: 0.00002500 btc
///        from Addr1
///    2 received:
///      239 conf, label: Salary from Marketing work, amount: 0.00500000 btc
///        in Addr3
///      4930 conf, label: Opening balance, amount: 0.01000000 btc
///        in Addr1
///  * 1 unconfirmed transaction: broadcasted 4 mins ago
///  On sync (after 10 mins), bdk should
///   * update confirmations for 5 confirmed transactions
///   * confirm the unconfirmed transaction
///
///

Wallet getTestWallet(BBNetwork network, ScriptType script, bool hasImported) {
  final externalAddressBook = [
    Address(
      address: 'tb1qnu4af4jycs8j43q7jhfnnglhxa6yk9lp58f4ls',
      kind: AddressKind.external,
      state: AddressStatus.used,
    ),
  ].toList();

  final myAddressBook = [
    Address(
      address: 'tb1qjqe9dlu745drylkhs8ch6290lkntv2art8qyyp',
      kind: AddressKind.deposit,
      state: AddressStatus.used,
      index: 0,
    ),
    Address(
      address: 'tb1q83stv4lvmrkeg5hx0tnk88ddeyzm7y5t0d4rv5',
      kind: AddressKind.change,
      state: AddressStatus.unused,
      index: 0,
    ),
    Address(
      address: 'tb1qxwxxdjhgfnqz0slmwpnw99wm842k6wc23r4nac',
      kind: AddressKind.change,
      state: AddressStatus.active,
      index: 1,
    ),
    Address(
      address: 'tb1qscvnchw8jgyu0383v6jhqsux6jyhh5zq52f2es',
      kind: AddressKind.deposit,
      state: AddressStatus.active,
      index: 1,
    ),
    Address(
      address: 'tb1q4knjskxg7kpgr8xzsprxrl63nt2uqqkqs52yw8',
      kind: AddressKind.change,
      state: AddressStatus.unused,
      index: 2,
    ),
    Address(
      address: 'tb1q3gpau9ntrrm86jlen3l5dq5hgs4j5ph8lkj6s9',
      kind: AddressKind.deposit,
      state: AddressStatus.unused,
      index: 2,
    ),
  ].toList();

  final Transaction tx1 = Transaction(
    txid: 'ca37042c41507326851792fd14a277edad58be9a31f34f92279ae49c78ea536e',
    received: 1000000,
    sent: 0,
    label: 'Addr1',
    toAddress: 'tb1qjqe9dlu745drylkhs8ch6290lkntv2art8qyyp',
    rbfEnabled: false,
    fee: 792,
    height: 2538538,
    timestamp: 1700029210,
    outAddrs: [
      // TODO: Have so many duplicates
      Address(
        address: 'tb1qjqe9dlu745drylkhs8ch6290lkntv2art8qyyp',
        index: 0,
        spendable: false,
        spentTxId: 'ca37042c41507326851792fd14a277edad58be9a31f34f92279ae49c78ea536e',
        kind: AddressKind.deposit,
        state: AddressStatus.used,
      ),
    ],
  );

  final Transaction tx2 = Transaction(
    txid: '401d5332b40f1df53763e846bef2ad820e642f834103ce69383d0d764e7be9b0',
    received: 997359,
    sent: 1000000,
    label: 'Gift to Kiran',
    toAddress: 'tb1qnu4af4jycs8j43q7jhfnnglhxa6yk9lp58f4ls',
    fee: 141,
    height: 2538539,
    timestamp: 1700030415,
    outAddrs: [
      Address(
        address: 'tb1qnu4af4jycs8j43q7jhfnnglhxa6yk9lp58f4ls',
        kind: AddressKind.external,
        state: AddressStatus.used,
        index: 0,
        spendable: false,
        spentTxId: '401d5332b40f1df53763e846bef2ad820e642f834103ce69383d0d764e7be9b0',
      ),
      Address(
        address: 'tb1qxwxxdjhgfnqz0slmwpnw99wm842k6wc23r4nac',
        kind: AddressKind.change,
        state: AddressStatus.used,
        index: 1,
        spentTxId: '401d5332b40f1df53763e846bef2ad820e642f834103ce69383d0d764e7be9b0',
      ),
    ],
  );

  final Transaction tx3 = Transaction(
    txid: '9906a7d3998d098080f4856d65d7f3e2d1be67feb95aa357e17985998869d905',
    received: 500000,
    sent: 0,
    label: 'Salary from Marketing work',
    toAddress: 'tb1qscvnchw8jgyu0383v6jhqsux6jyhh5zq52f2es',
    fee: 481,
    height: 2538541,
    timestamp: 1700031019,
    outAddrs: [
      Address(
        address: 'tb1qscvnchw8jgyu0383v6jhqsux6jyhh5zq52f2es',
        kind: AddressKind.deposit,
        state: AddressStatus.used,
        index: 1,
        spendable: false,
        spentTxId: '9906a7d3998d098080f4856d65d7f3e2d1be67feb95aa357e17985998869d905',
      ),
    ],
  );

  final Wallet w = Wallet(
    network: BBNetwork.Testnet,
    type: BBWalletType.words,
    scriptType: ScriptType.bip84,
    transactions: [
      tx1,
      tx2,
      tx3,
    ].toList(),
    externalAddressBook: externalAddressBook,
    myAddressBook: myAddressBook,
    id: 'e9c1775441c7',
    name: 'Magic',
    mnemonicFingerprint: 'f319e1e6',
    sourceFingerprint: 'f319e1e6',
    externalPublicDescriptor:
        "wpkh([f319e1e6/84'/1'/0']tpubDCJzkDG4giNgq9wRhMCxWzvfW9dAbj3sAHwnsAEcuAGjTTjm3SwVboxLpyU3PRYynPnY5MnC5VAGW1wiqtQ39gv5ZJ5yDYnJb2PhZZPL9Zw/0/*)#vwe3p6gd",
    internalPublicDescriptor:
        "wpkh([f319e1e6/84'/1'/0']tpubDCJzkDG4giNgq9wRhMCxWzvfW9dAbj3sAHwnsAEcuAGjTTjm3SwVboxLpyU3PRYynPnY5MnC5VAGW1wiqtQ39gv5ZJ5yDYnJb2PhZZPL9Zw/1/*)#a6usu0c4",
    fullBalance: const Balance(
      confirmed: 1497359,
      immature: 0,
      spendable: 1497359,
      total: 1497359,
      trustedPending: 0,
      untrustedPending: 0,
    ),
  );

  return w;
}

void mockBdkTransactions() {
  final List<bdk.TransactionDetails> list =[
    const bdk.TransactionDetails(
      confirmationTime: bdk.BlockTime(height: 2538538, timestamp: 1700029210),
      txid: 'ca37042c41507326851792fd14a277edad58be9a31f34f92279ae49c78ea536e',
      received: 1000000,
      sent: 0,
      fee: 792,
      serializedTx: '{"version":1,"lock_time":2538397,"input":[{"previous_output":"975f14dae29ec03118fee1bbaf44912169e52ca7747974e9d60d36b52bdd6deb:1","script_sig":"","sequence":4294967293,"witness":["304402200745b51f51c664b16815e48b3c90ca24064fe8784381b26a145004e2fa70f2b7022014af8779846fd7da3ee9fb36fd85fe6106e8fa9b3c7dfd74d91c222f0386ca8c01","0304a2186523410fc04708900c8a16e7cf48ebdc368db31437cc367a06a8bccf50"]},{"previous_output":"0ca465f3492307d37216e2589b42325488d01808f8b752f72df9283b83a9357f:1","script_sig":"","sequence":4294967293,"witness":["3044022022cda57a410fc08e267782f29ec5e3707d46bcb6126770975cb7ed867120d1ae022006f194c5edff4085a3b7f6f30791431bfe41d3e986096ec8f0881277bc1aa89801","03c4012ddb8829cfd21348c909491438d09b901291eabddd326e81e4ab69388e95"]},{"previous_output":"fc9ded4a0083bb58c6403f816114e9752d11c401ef8cd27e493a4adfca50fae9:1","script_sig":"","sequence":4294967293,"witness":["3044022016910ce7bcb545334ad58838b8dc14906fe87ee6fdcce519b8c3c45dfa1f343c02207658356716b22b07bfe2888893d35585100b6cdfff17cff29586dac04746339401","020eea5ba006e935e24cca40fcfc13f320d12eb011b155c28271bcddf25579780d"]},{"previous_output":"f6048ff3990f35c0cf3816e344517b66df86c4f8c138ac17964b355754c106fc:1","script_sig":"","sequence":4294967293,"witness":["3044022070658fff9bc0da65f65a302c3e54c7bb096b0f9c6a8126893360a5e9ecf91e3902206942bebba2c71c0aa7ac3e0374e6d756ff3792a5c180379f843eac59c5ffbede01","03ecd78d1316adec78d5d00ef245915e35e078ef8519ef6b11897743a4605f4c2d"]},{"previous_output":"37407aba417558a1e1295f3d112acc82912c1a64a98af81f6c368a84f074580f:1","script_sig":"","sequence":4294967293,"witness":["3044022054a5b0d514445b5db8920d8dd27a55b4d8182457675d951c50ded55d89744971022035154c3aed7acd80f3f8746a124751fa00c23e844c6ee45e79654147d94d1f9201","0240bd575aaa82e064c549a0c2183fa77dfbe2c9bc05b4599778b8e531331be986"]},{"previous_output":"f1a71993ea09593ae36f71155e8a668fbdecbb47e7cdcdcee80420f90f88b498:0","script_sig":"","sequence":4294967293,"witness":["304402204cd9de41712c8c527cf1d69c67e3cd0d2640781b7ecbc33433d7b3632d6d3850022078cb0f0fa563be3f15bf77fe1d248f87710c93ec73de8a353af6307e1b19e0a501","038c024c1e654d046e84b4aa2264b956cfa570e733492945c80517b829d7734004"]},{"previous_output":"a0ad030b378466dc60d63a29240b7d421e1770619279f5977186bba0e8575f30:1","script_sig":"","sequence":4294967293,"witness":["304402205e922b362b7af8d498ac0e13b8fb03b94bf19490cc3ee834932fe2809e47da7f022066e087658296d75dc8f342a92044f1902a46f3ae899cb8a7a16ee31c6272cd0c01","028adf803913b8d82fc27e597f95bf73226d9d8db147d60c7fac5f47ffbf81c7db"]},{"previous_output":"9088809b5f033acebcc8679b808653b09f82b1d303ab0a44df6c83c36cdbae54:0","script_sig":"","sequence":4294967293,"witness":["30440220302a94735b532b08443416672dbe5bb6c39635456f23fb4befe56b1ecc78d0fe0220103607244d253d52d99d003a2e1146c5b3a567d5281663b5cc4178007207df0201","02d0e3e036c7ec8f9fdb4a339c144f8e77ab13c77b338cda4b15481afbd816ee0f"]},{"previous_output":"2bed6abb805950bc28f4ad4f5f5ee0614297027a9f4130ac2abd9efd3887b58c:1","script_sig":"","sequence":4294967293,"witness":["304402202a1851cdede1cb82f731d2dc48b4ae82eb489a37b1f586ea077815cdcd93a6560220776d1848d9f33fc56c2d2d4ebe935f8364e22f718a719ca76dcbb767c0b29cba01","0240bd575aaa82e064c549a0c2183fa77dfbe2c9bc05b4599778b8e531331be986"]},{"previous_output":"7c8b2efd766bfe552812f3349b0c727055cde011722e229c1cbdec51494c524e:1","script_sig":"","sequence":4294967293,"witness":["30440220051a621f7f8bfea5c8c6f84f37b7500ef9955c7de54784718a105498292af81a02203b1c59d9cca4054bd227c7d2b6a62b16eb55e7ecedb1bc8a7a9fba1bf0a6a67301","038c1b14e8b91a0f61e3c38eca4b25d7adfd93b55feb0bb5b9ef98d5328c871e8e"]},{"previous_output":"f01c25b0c2e961f41506ac8ec6b6639bdd308bb884ca39cec4d58e62dcf8ba82:1","script_sig":"","sequence":4294967293,"witness":["304402203da6e279ac4221ed6075af1191846910da8c1be1c936fc1a08d1cab8f4a9f47e022036b3386d91f9105fc7d5b2ace7571517c67072794f7e88aec9923529be5e957501","0341750d1098c3e1620248b864a6d8859c02892da6b5abeb1a43bc2cbbf685be9f"]}],"output":[{"value":1000000,"script_pubkey":"0014903256ff9ead1a327ed781f17d28affda6b62ba3"}]}',
    ),
    const bdk.TransactionDetails(
      confirmationTime: bdk.BlockTime(height: 2538539, timestamp: 1700030415),
      txid: '401d5332b40f1df53763e846bef2ad820e642f834103ce69383d0d764e7be9b0',
      received: 997359,
      sent: 1000000,
      fee: 141,
      serializedTx: '{"version":1,"lock_time":2538538,"input":[{"previous_output":"ca37042c41507326851792fd14a277edad58be9a31f34f92279ae49c78ea536e:0","script_sig":"","sequence":4294967293,"witness":["30440220713e3cc94ca6ede3d260e2988c8e9c401c6994b94426ef7c312fb9a08d87517102203fbbc1c40006bd5129b8a61a6ad5c2b8a0a685cadc0a7e6c944a28e36abda50601","03bdb441b6588cdfd5146e29e7a641899a51145d348fee3ed95f19644ff58df0f6"]}],"output":[{"value":997359,"script_pubkey":"0014338c66cae84cc027c3fb7066e295db3d556d3b0a"},{"value":2500,"script_pubkey":"00149f2bd4d644c40f2ac41e95d339a3f737744b17e1"}]}',
    ),

const bdk.TransactionDetails(
      confirmationTime: bdk.BlockTime(height: 2538541, timestamp: 1700031019),
      txid: '9906a7d3998d098080f4856d65d7f3e2d1be67feb95aa357e17985998869d905',
      received: 500000,
      sent: 0,
      fee: 481,
      serializedTx: '{"version":1,"lock_time":2538539,"input":[{"previous_output":"7be7304a79cc7b95923c602f108279f4bfba5fef092cfb8fc3fd372c71943af9:0","script_sig":"","sequence":4294967293,"witness":["304402204ec5ad22a4cc4d286bdff51d9a9690a132271ee92a4383a87b2ca52c1c926d0f02205116bbdf89de946d49d8c943c73f7aea44fda54de616eded0cd8e4424105629001","02af42191a38f033bbb1838ab57bf5744b68176002c01b662ba22683cbfffd845e"]},{"previous_output":"dff4b01ddf6b06cf12275890c94ed3a01252ddc7dadf720c32891a50cc7d3568:0","script_sig":"","sequence":4294967293,"witness":["304402201b9dfddc10eccf480fe348a67e56b9642cad2b0d8de59677607b0ebb9df0a9fe02203afce888d0965278dca580dce5199a9e91a62950b1d3c010186b2e7a8258ab9501","0341750d1098c3e1620248b864a6d8859c02892da6b5abeb1a43bc2cbbf685be9f"]},{"previous_output":"ca1a32d438dc72a14840e6e5a2bcbf3b9a5d4f13f8eac508811ecd5d65f9f867:0","script_sig":"","sequence":4294967293,"witness":["304402200e75e443cfa6581546ce554bbb3c109398f271c5c92d55a705c804e185573bb9022061d04175071bda7594fe234db5a0a4bd78fd8af0cae7af936a563f1088415a4d01","02e65b5219ce8f80e65c96d756f33aa9801556683747687558684141ecf181913a"]},{"previous_output":"516db3d44d9165f6d1630822f9e89df014d236fe20e9fa52ebda18233a3313ec:0","script_sig":"","sequence":4294967293,"witness":["304402202d5abd730425c577293cafed4865ba37d38cdf8aec7355b56708ae7629997a6502203fb53c88e75c73a07831add17851ebb424031233f9bf274030d289e0b983c0e701","026dc18ce1f0d93eb21d0247b1de22f07d9af8e32c028b72b7dcab6d45aa4f0c51"]},{"previous_output":"2502c71001a6d4081c0ba44990364866f894a6a6da5673f3e842c5e3b514ea10:1","script_sig":"","sequence":4294967293,"witness":["304402206767662c265752512d3ac097a19b940c6f5ea8137c48d2ff8b6b2624ed50a48902200680251aca51af3cca0dff076b0e1db05077fcc9a78de175bde9e9c0f6e42e4701","038c1b14e8b91a0f61e3c38eca4b25d7adfd93b55feb0bb5b9ef98d5328c871e8e"]},{"previous_output":"c7adf1a5f21f31d8161a5f77b71558049dda5818f819d5d682c70acfd38ad5d6:1","script_sig":"","sequence":4294967293,"witness":["304402202002268363cee74bfb23045726da742cb8223983be2233e8d446121e4b343109022056eee69ddc4455338e7cb66dc4fbac33d6bb7e17b6f61990ab3ae6bda4b9eccf01","02ee800099585d5ae63bcebc5430462359bce76dae93aec91ae6679e958ae25a05"]}],"output":[{"value":538237,"script_pubkey":"00146f080722cb8cd7d713e907be3728434629402f31"},{"value":500000,"script_pubkey":"001486193c5dc79209c7c4f166a5704386d4897bd040"}]}',
    ),
  ]
}

/*
Future<bdk.Wallet> getTestBdkWallet(BBNetwork network, ScriptType script, bool hasImported) async {
  final external = await bdk.Descriptor.create(
    descriptor:
        "wpkh([f319e1e6/84'/1'/0']tpubDCJzkDG4giNgq9wRhMCxWzvfW9dAbj3sAHwnsAEcuAGjTTjm3SwVboxLpyU3PRYynPnY5MnC5VAGW1wiqtQ39gv5ZJ5yDYnJb2PhZZPL9Zw/0/*)#vwe3p6gd",
    network: bdk.Network.Testnet,
  );
  final internal = await bdk.Descriptor.create(
    descriptor:
        "wpkh([f319e1e6/84'/1'/0']tpubDCJzkDG4giNgq9wRhMCxWzvfW9dAbj3sAHwnsAEcuAGjTTjm3SwVboxLpyU3PRYynPnY5MnC5VAGW1wiqtQ39gv5ZJ5yDYnJb2PhZZPL9Zw/1/*)#a6usu0c4",
    network: bdk.Network.Testnet,
  );

  final bdk.Wallet w = await bdk.Wallet.create(
    descriptor: external,
    changeDescriptor: internal,
    network: bdk.Network.Testnet,
    databaseConfig: null,
  );

  return w;
}
*/
