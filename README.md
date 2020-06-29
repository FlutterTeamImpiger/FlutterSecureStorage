# store_critical_data

A Flutter plugin to store critical data in secure storage:
* [Keychain](https://developer.apple.com/library/content/documentation/Security/Conceptual/keychainServConcepts/01introduction/introduction.html#//apple_ref/doc/uid/TP30000897-CH203-TP1) is used for iOS
* AES encryption is used for Android. AES secret key is encrypted with RSA and RSA key is stored in [KeyStore](https://developer.android.com/training/articles/keystore.html)

*Note*
* KeyStore was introduced in Android 4.3 (API level 18). The plugin wouldn't work for earlier versions.

## Getting Started
```dart
import 'package:store_critical_data/store_critical_data.dart';

// Create storage
final _storage = new StoreCriticalData();

// write String value
_storage.writeString(key: “key”, value: “value”);

// Read String value
String value = _storage.readString(key: "key");

// write Double value
_storage.writeDouble(key: “key”, value: “value”);

// Read Double value
final double value = _storage.readDoubleNew(key: "key");

// Clear value
_storage.clear(key: "userName");

// Clear All
 _storage.clearAll();

```

### Configure Android version
In `[project]/android/app/build.gradle` set `minSdkVersion` to >= 18.
```
android {
    ...

    defaultConfig {
        ...
        minSdkVersion 18
        ...
    }

}
```
*Note* By default Android backups data on Google Drive. It can cause exception java.security.InvalidKeyException:Failed to unwrap key.


