# 🚀 설치 및 실행 가이드

QR 기반 실시간 EXPO 모니터링 시스템의 설정 및 실행 방법을 안내합니다.

## 🔧 설정 파일

### 1. `lib/config.dart`
환경별 설정을 저장하기 위해 이 파일을 생성하세요.

```dart
// lib/config.dart

class Config {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com/expo-backend.php',
  );
}
```

### 2. `expo-backend/config.php`
백엔드 폴더 내에 이 파일을 생성하여 데이터베이스 자격 증명을 관리하세요.

```php
<?php
// expo-backend/config.php

define('DB_HOST', getenv('DB_HOST') ?: 'localhost');
define('DB_USER', getenv('DB_USER') ?: 'your_db_user');
define('DB_PASS', getenv('DB_PASS') ?: 'your_db_password');
define('DB_NAME', getenv('DB_NAME') ?: 'expo_database');
?>
```

## 🚀 애플리케이션 실행

### Flutter Web 프론트엔드
1. 의존성 설치:
```bash
cd <project-root>
flutter pub get
```
2. 크롬에서 실행:
```bash
flutter run -d chrome
```
3. 웹 빌드:
```bash
flutter build web
```

### PHP 백엔드
1. 모든 PHP 파일을 웹 서버(Apache 또는 Nginx)의 `expo-backend/` 디렉터리에 배치하세요.
2. `expo-backend.php` 상단에 `config.php`를 포함하세요:
```php
require 'config.php';
```
3. 웹 서버가 `expo-backend/` 디렉터리를 제공하도록 설정하세요.

## 📄 라이선스

이 프로젝트는 **MIT License** 하에 배포됩니다.