import IronchipCommonsIos
import CoreLocation

public struct MyLibrary {
    var apiKey: String
    
    public init(apikey: String) {
        self.apiKey = apikey
    }
    
    public func transactionPost(transactionId: String, userId: String, extraData: [String:Any]) -> String? {
        var extraDataSJON = ""
        
        let arch: String? = "not available"
        let modelName: String? = DeviceService().modelName()
        let model: String? = DeviceService().model()
        let systemName: String? = DeviceService().systemName()
        let systemVersion: String? = DeviceService().systemVersion()
        var rooted: Bool? = false
        
        let coord: CLLocationCoordinate2D = Gps().getCoordinates()
        let long = coord.longitude
        let lat = coord.latitude
        
        let uuid: String? = DeviceService().uuid()
        
        let isCydiaInstalled: Bool? = JailBroken().isCydiaAppInstalled()
        let isDeviceJailbroken: Bool? = JailBroken().isDeviceJailbroken()
        let isEmulated: Bool? = EmulatedService().isEmulated()
        
        print("cydia \(String(describing: isCydiaInstalled))")
        print("isDeviceJailbroken \(String(describing: isDeviceJailbroken))")
        print("isEmulated \(String(describing: isEmulated))")
        
        if ((isCydiaInstalled != nil ) || (isDeviceJailbroken != nil) || (isEmulated != nil)) {
            rooted = true
        } else {
            rooted = false
        }
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: extraData, options: [])
            extraDataSJON = String(data: jsonData, encoding: String.Encoding.ascii)!
            
        } catch{
            print(error.localizedDescription)
        }
        
        let connectedWifi: String! = WifiService().getWiFiBssid()
        
        let properties = [
            "cpu_abi": arch! as String,
            "manufacturer": model!,
            "model": modelName!,
            "os": systemName!,
            "version": systemVersion!
        ]
        
        let device: [String : Any] = [
            "id": uuid!,
            "properties": properties,
            "rooted": rooted!
        ]
        
        let user: [String : Any] = [
            "id": userId
        ]
        
        let geoLocation: [String : Any] = [
            "latitude": lat,
            "longitude": long,
        ]
        
        let jsonObject: [String : Any] = [
            "device": device,
            "electromagneticLocation": "",
            "extraData": extraDataSJON,
            "geoLocation": geoLocation,
            "id": transactionId,
            "user": user,
            "connected_bssid": connectedWifi!
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject:jsonObject)
        print(jsonObject)
        let headers:[String:String] = ["Content-Type":"application/json;charset=UTF-8","Accept":"application/json","Authorization":apiKey]
        
        let result = RestService().postRequest("https://testing.transaction.lbfraud.ironchip.com/transaction", data: jsonData, headers: headers)
        
        let splitResult = result?.components(separatedBy: ":")
        let splitResult1    = splitResult?[1]
        let splitResult2 = splitResult1?.replacingOccurrences(of: "\"", with: "")
        let traceabilityID = splitResult2?.replacingOccurrences(of: "}", with: "")
        
        return traceabilityID
    }
}

