import IronchipCommonsIos
import CoreLocation

public struct MyLibrary {
    var apiKey: String
    
    public init(apikey: String) {
        self.apiKey = apikey
    }
    
    public func transactionPost(transactionId: String, userId: String, extraData: [String:Any]) -> String {
        var extraDataSJON = ""
        
        let arch: String? = DeviceService().getArchitecture()
        let modelName: String? = DeviceService().modelName()
        let model: String? = DeviceService().model()
        let systemName: String? = DeviceService().systemName()
        let systemVersion: String? = DeviceService().systemVersion()
        var rooted: Bool? = false
        
        let coord: CLLocationCoordinate2D = Gps().getCoordinates()
        let long = coord.longitude
        let lat = coord.latitude
        
        let uuid: String? = DeviceService().uuid()
        
        let cydia: Bool? = JailBroken().isCydiaAppInstalled()
        if cydia == true {
            rooted = true
        } else {
            rooted = JailBroken().isDeviceJailbroken()
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
        
        let jsonObject = [
            "device": device,
            "electromagneticLocation": "",
            "extraData": extraDataSJON,
            "geoLocation": geoLocation,
            "id": transactionId,
            "user": user,
            "connected_bssid": connectedWifi!
        ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject:jsonObject)
        let headers:[String:String] = ["Content-Type":"application/json;charset=UTF-8","Accept":"application/json","Authorization":apiKey]
        let result = RestService().postRequest("https://testing.transaction.lbfraud.ironchip.com/transaction", data: jsonData, headers: headers)
        print("[FRAUD-SDK]: result of transaction: " + result)
        return result
        //        // create post request
        //        let url = URL(string: "https://testing.transaction.lbfraud.ironchip.com/transaction")!
        //        var request = URLRequest(url: url)
        //        request.httpMethod = "POST"
        //
        //        // insert json data to the request
        //        request.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        //        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        //        request.httpBody = jsonData
        //
        //        let task = URLSession.shared.dataTask(with: request) { data, response, error in
        //            guard let data = data, error == nil else {
        //                print(error?.localizedDescription ?? "No data")
        //                return
        //            }
        //            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
        //            if let responseJSON = responseJSON as? [String: Any] {
        //                print(responseJSON)
        //            }
        //        }
        //
        //        task.resume()
    }
}

