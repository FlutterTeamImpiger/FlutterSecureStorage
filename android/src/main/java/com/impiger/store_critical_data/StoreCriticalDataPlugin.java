package com.impiger.store_critical_data;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Handler;
import android.os.Looper;
import android.util.Base64;
import android.util.Log;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.nio.charset.Charset;
import java.util.Map;
import io.flutter.plugin.common.BinaryMessenger;
import com.impiger.store_critical_data.ciphers.StorageCipher;
import com.impiger.store_critical_data.ciphers.StorageCipher18Implementation;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * StoreCriticalDataPlugin Class
 * Store the primitive type data.
 */
public class StoreCriticalDataPlugin implements FlutterPlugin, MethodCallHandler {

  private MethodChannel channel;
  private SharedPreferences preferences;
  private Charset charset;
  // Declaring the storageCipher field to be volatile is required for Double-Checked Locking to
  // work correctly: https://www.cs.umd.edu/~pugh/java/memoryModel/DoubleCheckedLocking.html
  private volatile StorageCipher storageCipher;
  private static final String ELEMENT_PREFERENCES_KEY_PREFIX = "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIHNlY3VyZSBzdG9yYWdlCg";
  private static final String SHARED_PREFERENCES_NAME = "FlutterSecureStorage";
  // Necessary for deferred initialization of storageCipher.
  private static Context applicationContext;

  /// Register the Method Channel for native invoke method
  public static void registerWith(Registrar registrar) {
    StoreCriticalDataPlugin instance = new StoreCriticalDataPlugin();
    instance.initInstance(registrar.messenger(), registrar.context());
  }

  /// Set Methodcall Handle for Invoke call
  public void initInstance(BinaryMessenger messenger, Context context) {
    try {
      applicationContext = context.getApplicationContext();
      preferences = context.getSharedPreferences(SHARED_PREFERENCES_NAME, Context.MODE_PRIVATE);
      charset = Charset.forName("UTF-8");

      StorageCipher18Implementation.moveSecretFromPreferencesIfNeeded(preferences, context);

      channel = new MethodChannel(messenger, "impiger_securestroage");
      channel.setMethodCallHandler(this);
    } catch (Exception e) {
      Log.e("FlutterSecureStoragePl", "Registration failed", e);
    }
  }

  /**
   * This must be run in a separate Thread from an async method to avoid hanging UI thread on
   * live devices in release mode.
   * The most convenient place for that appears to be onMethodCall().
   */

  /// Initializing StorageCipher for storage
  private void ensureInitStorageCipher() {
    // Check to avoid unnecessary entry into the synchronized block.
    if (storageCipher == null) {
      synchronized (this) {
        // Check inside the synchronized block to avoid race condition.
        if (storageCipher == null) {
          try {
            Log.d("FlutterSecureStoragePl", "Initializing StorageCipher");
            storageCipher = new StorageCipher18Implementation(applicationContext);
            Log.d("FlutterSecureStoragePl", "StorageCipher initialization complete");
          } catch (Exception e) {
            Log.e("FlutterSecureStoragePl", "StorageCipher initialization failed", e);
          }
        }
      }
    }
  }
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    initInstance(flutterPluginBinding.getBinaryMessenger(),flutterPluginBinding.getApplicationContext());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    channel = null;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    MethodResultWrapper resultRaw = new MethodResultWrapper(result);
    new Thread(new MethodRunner(call, resultRaw)).start();
  }

  private String addPrefixToKey(String key)
  {
    return ELEMENT_PREFERENCES_KEY_PREFIX + "_" + key;
  }

  /**
   * MethodChannel.Result wrapper that responds on the platform thread.
   */
  static class MethodResultWrapper implements Result {

    private final Result methodResult;
    private final Handler handler = new Handler(Looper.getMainLooper());

    MethodResultWrapper(Result methodResult) {
      this.methodResult = methodResult;
    }

    @Override
    public void success(final Object result) {
      handler.post(new Runnable() {
        @Override
        public void run() {
          methodResult.success(result);
        }
      });
    }

    @Override
    public void error(final String errorCode, final String errorMessage, final Object errorDetails) {
      handler.post(new Runnable() {
        @Override
        public void run() {
          methodResult.error(errorCode, errorMessage, errorDetails);
        }
      });
    }

    @Override
    public void notImplemented() {
      handler.post(new Runnable() {
        @Override
        public void run() {
          methodResult.notImplemented();
        }
      });
    }
  }
  /**
   * Wraps the functionality of onMethodCall() in a Runnable for execution in a new Thread.
   */
  class MethodRunner implements Runnable {
    private final MethodCall call;
    private final Result result;

    MethodRunner(MethodCall call, Result result) {
      this.call = call;
      this.result = result;
    }

    @Override
    public void run() {
      try {
        ensureInitStorageCipher();
        String key = getKeyFromCall(call);
          switch (call.method) {
          case "write_string": {
            Map arguments = (Map) call.arguments;
            String value = (String) arguments.get("value");
            write(key, value);
            result.success(null);
            break;
          }
          case "read_string": {
            String value = read(key);
            result.success(value);
            break;
          }
          case "write_boolean": {
            Map arguments = (Map) call.arguments;
            String value = arguments.get("value").toString();
            write(key, value);
            result.success(null);
            break;
          }
          case "read_boolean": {
            String value = read(key);
            result.success(Boolean.valueOf(value));
            break;
          }
          case "write_int": {
            Map arguments = (Map) call.arguments;
            String value = arguments.get("value").toString();
            write(key, value);
            result.success(null);
            break;
          }
          case "read_int": {
            String value = read(key);
            result.success(Integer.valueOf(value));
            break;
          }
          case "write_double": {
            Map arguments = (Map) call.arguments;
            String value = arguments.get("value").toString();
            write(key, value);
            result.success(null);
            break;
          }
          case "read_double": {
            String value = read(key);
            result.success(Double.valueOf(value));
            break;
          }
          case "clear_all": {
            boolean isDone = clearAll();
            result.success(isDone);
            break;
            }
          case "clear": {
            boolean isDone = clear(key);
            result.success(isDone);
            break;
            }
          case "contains": {
            result.success(containsKey(getKeyFromCall(call)));
            break;
            }
          default:
            result.notImplemented();
            break;
        }

      } catch (Exception e) {
        StringWriter stringWriter = new StringWriter();
        e.printStackTrace(new PrintWriter(stringWriter));
        result.error("Exception encountered", call.method, stringWriter.toString());
      }
    }
  }

    /// Get Key Value
    private String getKeyFromCall(MethodCall call) {
      Map arguments = (Map) call.arguments;
      String rawKey = (String) arguments.get("key");
      String key = addPrefixToKey(rawKey);
      return key;
    }

    /// Write value to SharedPreferences
    private void write(String key, String value) throws Exception {
      byte[] result = storageCipher.encrypt(value.getBytes(charset));
      SharedPreferences.Editor editor = preferences.edit();
      editor.putString(key, Base64.encodeToString(result, 0));
      editor.commit();
  }
    /// Load value from SharedPreferences
    private String read(String key) throws Exception {
      String encoded = preferences.getString(key, null);
      return decodeRawValue(encoded);
    }

    /// Clear specific item
    private boolean clear(String key){
      SharedPreferences.Editor editor = preferences.edit();
      editor.remove(key);
      return editor.commit();
  }

    /// Clear all item
    private boolean clearAll(){
      SharedPreferences.Editor editor = preferences.edit();
      editor.clear();
      return editor.commit();
    }

    /// Check if Key was store
    private boolean containsKey(String key){
      return preferences.contains(key);
    }

    /// Convert decode the value
    private String decodeRawValue(String value) throws Exception {

      if (value == null) {
          return null;
      }
      byte[] data = Base64.decode(value, 0);
      byte[] result = storageCipher.decrypt(data);
      return new String(result, charset);
   }
}
