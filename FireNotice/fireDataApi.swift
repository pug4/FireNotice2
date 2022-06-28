//
//  fireData.swift
//  fireTracker
//
//  Created by JOJO on 4/5/21.
//  Copyright © 2021 Jayu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseMessaging
class FireData{
    
    var FireNear = false
    func getData(lat: Double, lang: Double) -> Bool{
        let url = URL(string: "https://api.ambeedata.com/latest/fire?lat=\(lat)&lng=\(lang)")!
        var request = URLRequest(url: url)
            request.allHTTPHeaderFields = [
                    "x-api-key": "7SFdX0JeSX9CK1q06cQ7z2LOPZAkVQx528fx6OWA"
            ]
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return }
            guard let data = data, let response = response else { return }
            let JSONString = String(data: data, encoding: String.Encoding.utf8)
            print(JSONString!)
            if (JSONString?.contains("confidence"))! && JSONString!.contains("nominal") || JSONString!.contains("high"){
                self.FireNear = true
            }else{
                self.FireNear = false
            }
        }.resume()
    return FireNear
    }
}
