/*
 * ==============================================================================
 * [fixture_reader] - Đọc File JSON Mẫu Trong Thư Mục Fixtures
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Đọc nội dung file JSON mẫu trong `test/fixtures/<filename>` thành chuỗi String.
 * - Cách dùng: `final jsonString = fixture('user_response.json');`
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Utility function reading JSON mock files from test/fixtures directory.
 * ==============================================================================
 */

import 'dart:io';

String fixture(String name) {
  final currentDir = Directory.current.path;
  final filePath = '$currentDir/test/fixtures/$name';
  return File(filePath).readAsStringSync();
}
