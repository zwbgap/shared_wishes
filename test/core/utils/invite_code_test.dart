import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:shared_wishes/core/constants/app_constants.dart';
import 'package:shared_wishes/core/utils/invite_code.dart';

void main() {
  group('generateInviteCode', () {
    test('长度为 8 且只含字符集字符', () {
      final String code = generateInviteCode(random: Random(42));
      expect(code.length, AppConstants.inviteCodeLength);
      for (final String c in code.split('')) {
        expect(AppConstants.inviteCodeCharset.contains(c), isTrue,
            reason: '字符 $c 不在邀请码字符集内');
      }
    });

    test('不含易混淆字符 O / 0 / I / 1 / L', () {
      for (int seed = 0; seed < 50; seed++) {
        final String code = generateInviteCode(random: Random(seed));
        expect(code, isNot(contains('O')));
        expect(code, isNot(contains('0')));
        expect(code, isNot(contains('I')));
        expect(code, isNot(contains('1')));
        expect(code, isNot(contains('L')));
      }
    });
  });

  group('normalizeInviteCode', () {
    test('去空格并转大写', () {
      expect(normalizeInviteCode('  abcd2345 '), 'ABCD2345');
      expect(normalizeInviteCode('abcd 2345'), 'ABCD 2345');
    });
  });

  group('isValidInviteCode', () {
    test('合法码通过（小写自动转大写）', () {
      expect(isValidInviteCode('ABCD2345'), isTrue);
      expect(isValidInviteCode('abcd2345'), isTrue);
    });

    test('长度不符拒绝', () {
      expect(isValidInviteCode('ABC123'), isFalse);
      expect(isValidInviteCode('ABCD23456'), isFalse);
      expect(isValidInviteCode(''), isFalse);
    });

    test('含字符集外字符拒绝', () {
      expect(isValidInviteCode('ABCD234O'), isFalse); // O 不在字符集
      expect(isValidInviteCode('ABCD234!'), isFalse);
      expect(isValidInviteCode('ABCD 234'), isFalse); // 内部空格
    });
  });
}
