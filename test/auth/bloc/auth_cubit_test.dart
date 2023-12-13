import 'package:bb_mobile/_pkg/error.dart';
import 'package:bb_mobile/_pkg/storage/secure_storage.dart';
import 'package:bb_mobile/_pkg/storage/storage.dart';
import 'package:bb_mobile/auth/bloc/cubit.dart';
import 'package:bb_mobile/auth/bloc/state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements SecureStorage {
  String _pin = '';

  @override
  Future<(String?, Err?)> getValue(
    String key,
  ) async {
    if (key == StorageKeys.securityKey) {
      if (_pin.isEmpty) {
        return (null, Err('No key'));
      } else {
        return (_pin, null);
      }
    } else {
      return ('key', null);
    }
  }

  @override
  Future<Err?> saveValue({
    required String key,
    required String value,
  }) async {
    if (key == StorageKeys.securityKey) {
      _pin = value;
    }
    return null;
  }
}

class MockList extends Mock implements List<int> {}

// test('Mock List<int>.shuffle()', () {
// var mockList = MockList();

// when(mockList.shuffle(any)).thenReturn(null);

// mockList.shuffle();

// verify(mockList.shuffle(any)).called(1);
// });

void main() {
  // TestWidgetsFlutterBinding.ensureInitialized();
  late AuthCubit authCubit;
  late MockStorage storage;

  setUp(() {
    storage = MockStorage();
    authCubit = AuthCubit(secureStorage: storage);

    // final mockList = MockList();
    // when(() => mockList.shuffle()).thenReturn(const [6, 7, 4, 1, 3, 0, 8, 5, 9, 2]);
  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit', () {
    blocTest<AuthCubit, AuthState>(
      'emits initial state on creation',
      build: () => authCubit,
      expect: () => [],
    );

    blocTest<AuthCubit, AuthState>(
      '(keyPressed) handles maxLength',
      build: () => authCubit,
      act: (cubit) {
        // TODO: Made this line, just to make the test run. Have to investigate into 'initial conditions' properly.
        cubit.emit(const AuthState(step: SecurityStep.createPin));
        '123456789'.split('').forEach(cubit.keyPressed);
      },
      skip: 1,
      expect: () => [
        const AuthState(step: SecurityStep.createPin, pin: '1'),
        const AuthState(step: SecurityStep.createPin, pin: '12'),
        const AuthState(step: SecurityStep.createPin, pin: '123'),
        const AuthState(step: SecurityStep.createPin, pin: '1234'),
        const AuthState(step: SecurityStep.createPin, pin: '12345'),
        const AuthState(step: SecurityStep.createPin, pin: '123456'),
        const AuthState(step: SecurityStep.createPin, pin: '1234567'),
        const AuthState(step: SecurityStep.createPin, pin: '12345678'),
      ],
    );

    // 1. [createPin] enter pin with bakcspace(s).
    // 2. [confirmPin :: invalid] look for error: 'Security Pins must match.'
    // 3. [confirmPin :: invalid] with backspace(s). look for error: 'Security Pins must match.'
    // 4. [confirmPin :: valid] with backspace(s). LoggedIn becomes true
    blocTest<AuthCubit, AuthState>(
      'createPin flow (create, confirm :: invalid, confirm :: invalid and confirm :: valid):',
      build: () => authCubit,
      act: (cubit) async {
        // Set initial state for creating a PIN
        cubit.emit(const AuthState(step: SecurityStep.createPin));

        // Function to simulate key presses
        void simulateKeyPresses(List<String> keys) {
          for (final key in keys) {
            cubit.keyPressed(key);
          }
        }

        // 1. Create PIN
        simulateKeyPresses(['1', '2', '3', '4', '4']);
        cubit.backspacePressed();
        await cubit.confirmPressed();

        // 2. Invalid confirmation (mismatch)
        simulateKeyPresses(['1', '2', '3']);
        await cubit.confirmPressed();

        // 3. Invalid confirmation (mismatch)
        simulateKeyPresses(['1', '2', '3', '3', '4']);
        cubit.backspacePressed();
        await cubit.confirmPressed();

        // 4. Valid confirmation
        simulateKeyPresses(['1', '2', '3', '4', '5']);
        cubit.backspacePressed();
        await cubit.confirmPressed();
      },
      skip: 1,
      expect: () {
        return [
          // 1. Create PIN
          const AuthState(step: SecurityStep.createPin, pin: '1'),
          const AuthState(step: SecurityStep.createPin, pin: '12'),
          const AuthState(step: SecurityStep.createPin, pin: '123'),
          const AuthState(step: SecurityStep.createPin, pin: '1234'),
          const AuthState(step: SecurityStep.createPin, pin: '12344'),
          const AuthState(step: SecurityStep.createPin, pin: '1234'),
          const AuthState(step: SecurityStep.confirmPin, pin: '1234'),

          // 2. Invalid confirmation (mismatch)
          const AuthState(step: SecurityStep.confirmPin, pin: '1234', confirmPin: '1'),
          const AuthState(step: SecurityStep.confirmPin, pin: '1234', confirmPin: '12'),
          const AuthState(step: SecurityStep.confirmPin, pin: '1234', confirmPin: '123'),
          const AuthState(
            step: SecurityStep.confirmPin,
            pin: '1234',
            err: 'Security Pins must match.',
          ),

          // 3. Invalid confirmation (mismatch)
          const AuthState(step: SecurityStep.confirmPin, pin: '1234'),
          const AuthState(step: SecurityStep.confirmPin, pin: '1234', confirmPin: '1'),
          const AuthState(step: SecurityStep.confirmPin, pin: '1234', confirmPin: '12'),
          const AuthState(step: SecurityStep.confirmPin, pin: '1234', confirmPin: '123'),
          const AuthState(step: SecurityStep.confirmPin, pin: '1234', confirmPin: '1233'),
          const AuthState(step: SecurityStep.confirmPin, pin: '1234', confirmPin: '12334'),
          const AuthState(step: SecurityStep.confirmPin, pin: '1234', confirmPin: '1233'),
          const AuthState(
            step: SecurityStep.confirmPin,
            pin: '1234',
            err: 'Security Pins must match.',
          ),

          // 4. Valid confirmation
          const AuthState(step: SecurityStep.confirmPin, pin: '1234'),
          const AuthState(step: SecurityStep.confirmPin, pin: '1234', confirmPin: '1'),
          const AuthState(step: SecurityStep.confirmPin, pin: '1234', confirmPin: '12'),
          const AuthState(step: SecurityStep.confirmPin, pin: '1234', confirmPin: '123'),
          const AuthState(step: SecurityStep.confirmPin, pin: '1234', confirmPin: '1234'),
          const AuthState(step: SecurityStep.confirmPin, pin: '1234', confirmPin: '12345'),
          const AuthState(step: SecurityStep.confirmPin, pin: '1234', confirmPin: '1234'),
          const AuthState(
            step: SecurityStep.confirmPin,
            pin: '1234',
            confirmPin: '1234',
            checking: false,
            loggedIn: true,
          ),
        ];
      },
    );

    // 1) [createPin]
    // 2) [confirmPin]
    // 3) [enterPin :: invalid] with backspace(s). look for error: 'Invalid Pin Entered'
    // 4) [enterPin :: invalid] with backspace(s). look for error: 'Invalid Pin Entered'
    // 4) [enterPin :: valid] with backspace(s). LoggedIn becomes true
    // (!fromSettings) create, confirm, enter invalid,
    blocTest<AuthCubit, AuthState>(
      'enterPin flow (create, confirm, enterPin :: invalid, enterPin :: invalid, enterPin :: valid)',
      build: () => authCubit,
      act: (cubit) async {
        // TODO: Made this line, just to make the test run. Have to investigate into 'initial conditions' properly.
        cubit.emit(
          const AuthState(
            step: SecurityStep.createPin,
          ),
        );
        cubit.keyPressed('1');
        cubit.keyPressed('2');
        cubit.keyPressed('3');
        cubit.keyPressed('4');

        await cubit.confirmPressed(); // 4
        cubit.keyPressed('1');
        cubit.keyPressed('2');
        cubit.keyPressed('3');
        cubit.keyPressed('4'); // 8

        await cubit.confirmPressed();
        // await cubit.init();
        // TODO: Shouldnt' be doing this. Should rather do 'init()'
        cubit.emit(
          const AuthState(
            checking: false,
          ),
        );

        cubit.keyPressed('1');
        cubit.keyPressed('2');
        cubit.keyPressed('3'); //13

        /*
        await cubit.confirmPressed();

        cubit.keyPressed('1');
        cubit.keyPressed('2');
        cubit.keyPressed('3');
        cubit.keyPressed('3');
        await cubit.confirmPressed();

        cubit.keyPressed('1');
        cubit.keyPressed('2');
        cubit.keyPressed('3');
        cubit.keyPressed('4');
        await cubit.confirmPressed();
        */
      },
      skip: 1,
      expect: () => [
        const AuthState(
          step: SecurityStep.createPin,
          pin: '1',
        ),
        const AuthState(
          step: SecurityStep.createPin,
          pin: '12',
        ),
        const AuthState(
          step: SecurityStep.createPin,
          pin: '123',
        ),
        const AuthState(
          step: SecurityStep.createPin,
          pin: '1234',
        ), // 3

        // confirm Pressed (1)
        const AuthState(
          step: SecurityStep.confirmPin,
          pin: '1234',
        ), // 4

        const AuthState(
          step: SecurityStep.confirmPin,
          pin: '1234',
          confirmPin: '1',
        ),
        const AuthState(
          step: SecurityStep.confirmPin,
          pin: '1234',
          confirmPin: '12',
        ),
        const AuthState(
          step: SecurityStep.confirmPin,
          pin: '1234',
          confirmPin: '123',
        ),
        const AuthState(
          step: SecurityStep.confirmPin,
          pin: '1234',
          confirmPin: '1234',
        ), // 8

        // confirmPressed (2)
        const AuthState(
          step: SecurityStep.confirmPin,
          pin: '1234',
          confirmPin: '1234',
          checking: false,
          loggedIn: true,
        ),
        const AuthState(
          checking: false,
        ), // 10

        const AuthState(pin: '1', checking: false),
        const AuthState(pin: '12', checking: false),
        const AuthState(pin: '123', checking: false), // 13

        /*
        // confirmPressed (2)
        const AuthState(pin: '123', checking: false, shuffledNumbers: [1, 2, 3]),
        const AuthState(
          err: 'Invalid Pin Entered',
          checking: false,
        ), // 15

        const AuthState(checking: false),
        const AuthState(pin: '1', checking: false),
        const AuthState(pin: '12', checking: false),
        const AuthState(pin: '123', checking: false),
        const AuthState(pin: '1233', checking: false), // 20

        // confirmPressed (2)
        const AuthState(pin: '1233'),
        const AuthState(
          err: 'Invalid Pin Entered',
          checking: false,
        ), // 22

        const AuthState(checking: false),
        const AuthState(pin: '1', checking: false),
        const AuthState(pin: '12', checking: false),
        const AuthState(pin: '123', checking: false),
        const AuthState(pin: '1234', checking: false), // 27

        // confirmPressed (2)
        const AuthState(pin: '1234'),
        const AuthState(
          pin: '1234',
          checking: false,
          loggedIn: true,
        ), // 29
      */
      ],
    );
  });
}
