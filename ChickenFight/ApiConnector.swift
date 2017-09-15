//
//  ApiConnector.swift
//  ChickenFight
//
//  Created by Johan Wejdenstolpe on 2017-08-16.
//  Copyright © 2017 Johan Wejdenstolpe. All rights reserved.
//

import Foundation

protocol ApiConnectorProtocol: class {
    func smsVerificationSent(phonenumber: String, verificatoinCode: String)
}

class ApiConnector {
    
    weak var delegate: ApiConnectorProtocol!
    
    func verifyPhonenumber(phonenumber: String, vericationCode: String){
 
        var urlString = "https://www.textmagic.com/app/api?username=johanwejdenstolpe&password=x45Y21C4Fx&cmd=send&text="
        urlString += "Your+Chicken+Fight+verificaton+code+is+\(vericationCode)"
        urlString += "&phone="
        urlString += phonenumber
        urlString += "&unicode=0"
        
        let url: URL = URL(string: urlString)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if error != nil {
                print("Error: \(String(describing: error))")
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                
                switch httpResponse.statusCode {
                    
                case 200:
                    DispatchQueue.main.async {
                        self.delegate.smsVerificationSent(phonenumber: phonenumber, verificatoinCode: vericationCode)
                    }
                    break
                    
                default:
                    break
                }
            }
        }
        
        task.resume()
    }
}
