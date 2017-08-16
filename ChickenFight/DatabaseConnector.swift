//
//  DatabaseConnector.swift
//  ChickenFight
//
//  Created by Johan Wejdenstolpe on 2017-08-14.
//  Copyright © 2017 Johan Wejdenstolpe. All rights reserved.
//

import Foundation

protocol GetDataFromDBProtocal: class {
    func phonenumbersChecked(locations: [String])
}

class DatabaseConnector: NSObject, URLSessionDelegate {
    
    weak var delegate: GetDataFromDBProtocal!
    
    let urlPath = "https://wejdenma16.000webhostapp.com/chickenfight/chickenfight.php"
    
    func formatNumber(number: String) -> String {
        
        var formattedNumber = String(number.characters.filter({ "0123456789".characters.contains($0) }))
        var index = formattedNumber.index(formattedNumber.startIndex, offsetBy: 2)
        var startOfString = formattedNumber.substring(to: index)
//        var start = getFirst(number: formattedNumber, offset: 2)
        if startOfString == "00"{
            formattedNumber = formattedNumber.substring(from: index)
        }
        
        index = formattedNumber.index(formattedNumber.startIndex, offsetBy: 1)
        
//        print(range)
        startOfString = formattedNumber.substring(to: index)
        
        if startOfString == "0"{
            formattedNumber = formattedNumber.substring(from: index)
            formattedNumber = "46" + formattedNumber
        }
        return formattedNumber
    }
    
//    func getFirst(number: String, offset: Int) -> String {
//        let index = number.index(number.startIndex, offsetBy: offset)
//        let startOfString = number.substring(to: index)
//        
//        return startOfString
//    }
    
    func checkPhonenumbers(numbersToCheck: String){
        let url: URL = URL(string: urlPath)!
        let phonenumber = "46704672965"
//        let searchnumbers = "46704672965,461234567"
//        let searchnumbers = numbersToCheck

        let request = NSMutableURLRequest(url: url)
        
        request.httpMethod = "POST"
        var postParameters = "action=checkphonenumbers"
        postParameters += "&phonenumber=" + phonenumber
        postParameters += "&numberstosearchfor=" + numbersToCheck
//        print(postParameters)
        request.httpBody = postParameters.data(using: .utf8)
        
//        let dataString = String(describing: NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue))
//        print("\(dataString)")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            
            if data != nil {
//                print("Data:")
//                let dataString = String(describing: NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
//                print("\(dataString)")
                self.parsePhonenumbersJSON(data!)
            }
            
        }
        task.resume()
        
    }
    
    func parsePhonenumbersJSON(_ data: Data){
//        print("Parse:")
        var jsonResult: [[String: Any]] = [[String: Any]]()
    
        
        do {
            
            try jsonResult = JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as! [[String: Any]]
            
        } catch let error as NSError {
            print("ERROR:")
            print("Error: \(error)")
        }
        
//        print(jsonResult)
        var phoneNumbers: [String] = [String]()
//        var jsonElement: [String: Any] = [String: Any]()
        
        
        
        for number in jsonResult {
            if let phoneNumber = number["phonenumber"] as? String{
                phoneNumbers.append(phoneNumber)
            }
        }
        
//        for i in (0...jsonResult.count - 1) {
//            jsonElement = jsonResult[i] as! [String: Any]
//        }
        
        print("\(phoneNumbers)")
        
//            print(numbers)
    }
}
