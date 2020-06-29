import Flutter
import UIKit

// Constant Identifiers
let userAccount = "AuthenticatedUser"

// Arguments for the keychain queries
let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)


public class SwiftStoreCriticalDataPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {

    // create Channel:
    let channel = FlutterMethodChannel(name: "impiger_securestroage", binaryMessenger: registrar.messenger())
    let instance = SwiftStoreCriticalDataPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

print(call.method)
    let arguments =  call.arguments
            let params = arguments as?[String: Any]
            if params != nil{

                if let key = params?["key"] as? String{
                    if (call.method == "write_string") {

                        let stringValue = params?["value"] as? String
                        self.convertStringToData(key: key, value: stringValue ?? "")

                    }else if (call.method == "write_boolean"){

                        let boolValue = params?["value"] as? Bool
                        let boolAsString = String(boolValue ?? false)
                        self.convertStringToData(key: key, value: boolAsString )

                    }else if (call.method == "write_int"){

                        let intValue = params?["value"] as? Int
                        let intValues = "\(intValue ?? 0)"
                        self.convertStringToData(key: key, value: intValues )

                    }else if (call.method == "write_double"){

                        let doubleValue = params?["value"] as? Double
                        let doubleValues = "\(doubleValue ?? 0)"
                        self.convertStringToData(key: key, value: doubleValues )

                    }else if (call.method == "read_string"){

                        if let stringValue = self.load(service: key as NSString){
                            result(stringValue)
                        }

                    }else if (call.method == "read_boolean"){

                        if let stringValue = self.load(service: key as NSString){
                            let boolValue = stringValue.boolValue
                            result(boolValue)
                        }
                    }else if (call.method == "read_int"){

                        if let stringValue = self.load(service: key as NSString){
                            let intValue = stringValue.intValue
                            result(intValue)
                        }
                    }else if (call.method == "read_double"){

                        if let stringValue = self.load(service: key as NSString){
                            let doubleValue = stringValue.doubleValue
                            result(doubleValue)
                        }
                    }
                    else if (call.method == "clear"){
                       if let resultValue = clear(key: key as NSString){
                             result(resultValue)
                        }
                    }
                    else if (call.method == "clear_all"){
                        if let resultValue = clearAll(){
                             result(resultValue)
                        }
                    }
                }
            }
  }
  /// String value convert to NSData for save to keychain
      func convertStringToData(key: String, value: String) {
          let dataFromString: NSData = value.data(using: String.Encoding.utf8, allowLossyConversion: false)! as NSData
          self.saveToKeyChain(key: key, dataFrom: dataFromString)
      }

      /// Store function
      func saveToKeyChain(key : String, dataFrom: NSData){

          // Instantiate a new default keychain query
          let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, key, userAccount, dataFrom], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])

          // Delete any existing items
          SecItemDelete(keychainQuery as CFDictionary)

          // Add the new keychain item
          SecItemAdd(keychainQuery as CFDictionary, nil)
      }

      /// Read function
      func load(service: NSString) -> NSString? {

          // Instantiate a new default keychain query
          // Tell the query to return a result
          // Limit our results to one item
          let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, kCFBooleanTrue!, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
          var dataTypeRef :AnyObject?

          // Search for the keychain items
          let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
          var contentsOfKeychain: NSString? = nil
          if status == errSecSuccess {
              if let retrievedData = dataTypeRef as? NSData {
                  contentsOfKeychain = NSString(data: retrievedData as Data, encoding: String.Encoding.utf8.rawValue)
              }
          }else{
              print("Nothing was retrieved from the keychain. Status code \(status)")
          }
          return contentsOfKeychain
      }

    /// Clear specific item
    func clear(key: NSString) -> Bool? {

        // Instantiate a keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, key, userAccount], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue])
        // Delete items
        SecItemDelete(keychainQuery as CFDictionary)
        return true
    }

    /// Clear all item
    func clearAll() -> Bool? {

        // Instantiate a keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, userAccount], forKeys: [kSecClassValue, kSecAttrAccountValue])
        // Delete all items
        SecItemDelete(keychainQuery as CFDictionary)
        return true
    }
}
