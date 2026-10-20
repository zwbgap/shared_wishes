import 'dart:math';

import '../constants/app_constants.dart';

/// 邀请码工具（字符集已剔除 O / 0 / I / 1 / L 等易混淆字符）。

/// 生成 [AppConstants.inviteCodeLength] 位邀请码。
String generateInviteCode({Random? random}) {
  final Random rand = random ?? Random.secure();
  const String charset = AppConstants.inviteCodeCharset;
  return List<String>.generate(
    AppConstants.inviteCodeLength,
    (_) => charset[rand.nextInt(charset.length)],
  ).join();
}

/// 规范化输入：去空格并转大写。
String normalizeInviteCode(String input) => input.trim().toUpperCase();

/// 校验邀请码格式（长度 + 字符集）。
bool isValidInviteCode(String input) {
  final String code = normalizeInviteCode(input);
  if (code.length != AppConstants.inviteCodeLength) return false;
  return code
      .split('')
      .every((String c) => AppConstants.inviteCodeCharset.contains(c));
}
