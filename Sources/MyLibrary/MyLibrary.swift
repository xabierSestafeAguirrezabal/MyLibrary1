import IronchipCommonsIos
import CoreLocation

public struct MyLibrary {
    var apiKey: String

     public init(apikey: String) {
          self.apiKey = apikey
      }
    
    public func transactionPost(transactionId: String, userId: String, extraData: [String:Any]) {
        let arch: String? = DeviceService().getArchitecture()
        let modelName: String? = DeviceService().modelName()
        let model: String? = DeviceService().model()
        let systemName: String? = DeviceService().systemName()
        let systemVersion: String? = DeviceService().systemVersion()
        var rooted: Bool? = false
        let coord: CLLocationCoordinate2D = Gps().getCoordinates()
        let long = coord.longitude
        print("[SWIFT LBFRAUD LONG]: ", long)
        let lat = coord.latitude
        print("[SWIFT LBFRAUD LAT]: ", lat)
        let uuid: String? = DeviceService().uuid()
        let cydia: Bool? = isCydiaAppInstalled()
        if cydia == true {
            rooted = true
        } else {
            rooted = isDeviceJailbroken()
        }
        var jsonString: String = ""
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: extraData, options: [])
            jsonString = String(data: jsonData, encoding: String.Encoding.ascii)!
            
        } catch{
            print(error.localizedDescription)
        }
      
        let connectedWifi: String! = getWifi()
//        ModelsExtraDataRequest(from: <#Decoder#>)
        let transaction = ModelsTransactionRequest(
            device: ModelsDeviceRequest(
                id: uuid!,
                properties: ModelsDevicePropertiesRequest(
                    cpuAbi: arch! as String,
                    manufacturer: model!,
                    model: modelName!,
                    os: systemName!,
                    version: systemVersion!),
                    rooted: rooted),
             electromagneticLocation: nil,
             extraData: jsonString,
             geoLocation: ModelsGEOLocationRequest(
                latitude: lat,
                longitude: long),
                id: transactionId,
                user: ModelsUserRequest(id: userId),
                connected_bssid: connectedWifi) // ModelsTransactionRequest | Transaction info
        print("JSONNNNNNN: ", String(describing: transaction))
        // transaction endpoint
//        ClientAPI.transactionPost(apiKey: apiKey,transaction: transaction) { (response, error) in
//            guard error == nil else {
//                print(error ?? "[SWIFT LBFRAUD]: TransactionPost failed")
//                return
//            }
//            if ((response) != nil) {
//                print("[SWIFT LBFRAUD]: TransactionPost OK")
//                dump(response)
//            }
//        }
    }
    
//    public func permissionStatus() -> String {
//         let status: String = Gps().checkPermissionStatus()
//         return status
//     }
    
    func getWifi() -> String {
        var wifi: String = ""
        if #available(macCatalyst 14.0, *) {
            wifi = WifiService().getWiFiBssid() ?? "error Wifi"
        } else {
            // Fallback on earlier versions
        }
        print("[WIFI]",wifi )
         return wifi
     }
    
    func isDeviceJailbroken() -> Bool {
        return JailBroken().isDeviceJailbroken()
       }
    
    func isCydiaAppInstalled() -> Bool {
        return JailBroken().isCydiaAppInstalled()
    }
}

