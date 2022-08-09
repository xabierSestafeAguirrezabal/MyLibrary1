import IronchipCommonsIos
import CoreLocation

public struct MyLibrary {
    var apiKey: String
    
    public init(apikey: String) {
        self.apiKey = apikey
    }
    
    private func getInformation() -> [String : Any] {
        let connectedBSSID: String = getConnectedBSSID()
        let device: [String : Any] = getDeviceInformation()
        let geoLocation: [String : Any] = getGeoLocation()
        
        let jsonObject: [String : Any] = [
            "device": device,
            "electromagneticLocation": "",
            "geoLocation": geoLocation,
            "connected_bssid": connectedBSSID
        ]
        
        return jsonObject
    }
    
    private func generateJSON(transactionId: String, userId: String, extraData: [String:Any]) -> [String:Any] {
        var transactionJSON = getInformation()
        var extraDataJSON = ""
        let user = getUser(userId: userId)
        
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: extraData, options: [])
            extraDataJSON = String(data: jsonData, encoding: String.Encoding.ascii)!
        } catch{
            print(error.localizedDescription)
        }
        
        transactionJSON.updateValue(extraDataJSON, forKey: "extraData")
        transactionJSON.updateValue(user, forKey: "user")
        transactionJSON.updateValue(transactionId, forKey: "id")
        print(transactionJSON)
        
        return transactionJSON
    }
    
    private func getUser(userId: String) -> [String : Any] {
        let user: [String : Any] = [
            "id": userId
        ]
        return user
    }
    
    private func getGeoLocation() -> [String : Any] {
        let coord: CLLocationCoordinate2D = GPS().getCoordinates()
        
        let geoLocation: [String : Any] = [
            "latitude": coord.latitude,
            "longitude": coord.longitude,
        ]
        
        return geoLocation
    }
    
    private func getConnectedBSSID() -> String {
        let connectedBSSID: String! = Signals().getWiFiBSSID()
        
        return connectedBSSID
    }
    
    private func getDeviceInformation() -> [String : Any] {
        let arch: String = "not available"
        let isCydiaInstalled: Bool = Device().isCydiaAppInstalled()
        let isDeviceJailbroken: Bool = Device().isDeviceJailbrokened()
        let isEmulated: Bool = Device().isEmulated()
        let model: String = Device().model()
        let modelName: String = Device().modelName()
        let systemName: String = Device().systemName()
        let systemVersion: String = Device().systemVersion()
        let uuid: String? = Device().uuid()
        
        var rooted: Bool = false
        
        if ((isCydiaInstalled ) || (isDeviceJailbroken) || (isEmulated)) {
            rooted = true
        } else {
            rooted = false
        }
        
        let properties = [
            "cpu_abi": arch,
            "manufacturer": model,
            "model": modelName,
            "os": systemName,
            "version": systemVersion
        ]
        
        let device: [String : Any] = [
            "id": uuid!,
            "properties": properties,
            "rooted": rooted
        ]
        
        return device
    }
    
    public func sendTransaction(transactionId: String, userId: String, extraData: [String:Any]) -> String? {
        let generatedJSON = generateJSON(transactionId: transactionId, userId: userId, extraData: extraData)
        let jsonData = try? JSONSerialization.data(withJSONObject: generatedJSON)
        
        let headers:[String:String] = ["Content-Type":"application/json;charset=UTF-8","Accept":"application/json","Authorization":apiKey]
        
        let result = REST().postRequest("https://testing.transaction.lbfraud.ironchip.com/transaction", data: jsonData, headers: headers)
        print(result ?? "default")
        let splitResult = result?.components(separatedBy: ":")
        let splitResult1    = splitResult?[1]
        let splitResult2 = splitResult1?.replacingOccurrences(of: "\"", with: "")
        let traceabilityID = splitResult2?.replacingOccurrences(of: "}", with: "")
        
        return traceabilityID
    }
}


//       
//       let user: [String : Any] = [
//           "id": userId
//       ]
//       
//       let geoLocation: [String : Any] = [
//           "latitude": lat,
//           "longitude": long,
//       ]
//       
//       let jsonObject: [String : Any] = [
//           "device": device,
//           "electromagneticLocation": "",
//           "extraData": extraDataSJON,
//           "geoLocation": geoLocation,
//           "id": transactionId,
//           "user": user,
//           "connected_bssid": connectedWifi!
//       ]
//       
//       let jsonData = try? JSONSerialization.data(withJSONObject:jsonObject)
