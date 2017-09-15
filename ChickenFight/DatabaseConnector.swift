//
//  DatabaseConnector.swift
//  ChickenFight
//
//  Created by Johan Wejdenstolpe on 2017-08-14.
//  Copyright © 2017 Johan Wejdenstolpe. All rights reserved.
//

import Foundation

protocol GetDataFromDBProtocal: class {
    func phonenumbersChecked(numbers: [String])
    func updateChallengeList(challengeList: [Challenge])
    func updateStats(games: String, gamesWon: String)
    func refresh()
    func endRefresh()
}

class DatabaseConnector: NSObject, URLSessionDelegate {
    
    weak var delegate: GetDataFromDBProtocal!
    
    let urlPath = "https://wejdenma16.000webhostapp.com/chickenfight/chickenfight.php"
    let newUserUrlPath = "https://wejdenma16.000webhostapp.com/chickenfight/newuser.php"
    
    func loadPhonenumber() -> String {
        // Load locally stored phonenumber
        var phonenumber = ""
        let userDefaults = UserDefaults()
        if (userDefaults.string(forKey: "userPhonenumber") != nil){
            phonenumber = userDefaults.string(forKey: "userPhonenumber")!
        }
        
        return phonenumber
    }
    
    func newUser(phonenumber: String) {
        let url: URL = URL(string: newUserUrlPath)!
        let request = NSMutableURLRequest(url: url)
        
        request.httpMethod = "POST"
        let postParameters = "phonenumber=" + phonenumber
        
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, responce, error in
            
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            
            if data != nil {
                // Check if user created
                var jsonResult: [String: Any] = [String: Any]()
                
                do {
                    jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                    
                } catch let error as NSError {
                    print(error)
                }
                
                if jsonResult.count != 0 {
                    if let status = jsonResult["status"] as? String, let message = jsonResult["message"] as? String{
                        
                        if status == "Success"{
                            print("Status: \(message)")
                            DispatchQueue.main.async {
                                self.delegate.refresh()
                            }
                            
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    func checkPhonenumbers(numbersToCheck: String){
        let url: URL = URL(string: urlPath)!
        let phonenumber = loadPhonenumber()

        let request = NSMutableURLRequest(url: url)
        
        request.httpMethod = "POST"
        var postParameters = "action=checkphonenumbers"
        postParameters += "&phonenumber=" + phonenumber
        postParameters += "&numberstosearchfor=" + numbersToCheck

        request.httpBody = postParameters.data(using: .utf8)

        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            
            if data != nil {
                self.parsePhonenumbersJSON(data!)
            }
            
        }
        task.resume()
    }
    
    func parsePhonenumbersJSON(_ data: Data){

        var jsonResult: [[String: Any]] = [[String: Any]]()
    
        
        do {
            
            try jsonResult = JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as! [[String: Any]]
            
        } catch let error as NSError {

            print("Error: \(error)")
        }

        var phoneNumbers: [String] = [String]()
        
        if jsonResult.count != 0 {
            for number in jsonResult {
                if let phoneNumber = number["phonenumber"] as? String{
                    phoneNumbers.append(phoneNumber)
                }
            }
            DispatchQueue.main.async {
                self.delegate.phonenumbersChecked(numbers: phoneNumbers)
            }
        }else{
            DispatchQueue.main.async {
                self.delegate.endRefresh()
            }
        }
    }
    
    func getChallenges(){
        let url: URL = URL(string: urlPath)!
        let phonenumber = loadPhonenumber()
        let request = NSMutableURLRequest(url: url)
        
        request.httpMethod = "POST"
        var postParameters = "action=getchallenges"
        postParameters += "&phonenumber=" + phonenumber
        
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, responce, error in
            
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            
            if data != nil {
                self.parseChallengesJSON(data!)
            }
            
        }
        task.resume()
    }
    
    func parseChallengesJSON(_ data: Data){
        var jsonResult: [[String: Any]] = [[String: Any]]()
        
        do {
            
            try jsonResult = JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as! [[String: Any]]
            
        } catch let error as NSError {
            print("Error: \(error)")
        }
        
        if jsonResult.count != 0 {
            var challengesList = [Challenge]()
            for game in jsonResult {
                if let gameID = game["game_id"] as? String, let attacker = game["attacker"] as? String, let defender = game["defender"] as? String, let watched = game["watched"] as? String {
                    
                    let challenge = Challenge()
                    challenge.challengeID = Int(gameID)!
                    challenge.attacker = attacker
                    challenge.defender = defender
                    
                    if let attackMoves = game["attacker_moves"] as? String{
                        if attackMoves != "" {
                            challenge.attackerMoves = Moves(moves: attackMoves)
                        }
                    }
                    
                    if let defMoves = game["defender_moves"] as? String{
                        if defMoves != ""{
                            challenge.defenderMoves = Moves(moves: defMoves)
                        }
                    }
                    
                    if watched == "0" {
                        challenge.watched = false
                    }else{
                        challenge.watched = true
                    }
                    
                    challengesList.append(challenge)
                }
            }
            DispatchQueue.main.async {
                self.delegate.updateChallengeList(challengeList: challengesList)
            }
        }else{
            DispatchQueue.main.async {
                self.delegate.endRefresh()
            }
        }
    }
    
    func newChallenge(challenge: Challenge){
        
            let url: URL = URL(string: urlPath)!
            let phonenumber = loadPhonenumber()
            let request = NSMutableURLRequest(url: url)
            let moves = challenge.attackerMoves?.getMovesAsString()
            let opponent = challenge.defender
            
            request.httpMethod = "POST"
            var postParameters = "action=newchallenge"
            postParameters += "&phonenumber=" + phonenumber
            postParameters += "&moves=" + moves!
            postParameters += "&opponent=" + opponent!
            
            request.httpBody = postParameters.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                data, responce, error in
                
                if error != nil{
                    print("error is \(String(describing: error))")
                    return;
                }
                
                if data != nil {
                    // Check for success
                    self.getChallenges()
                }
            }
            task.resume()
    }
    
    func updateChallenge(moves: Moves, challengeid: Int){
        let url: URL = URL(string: urlPath)!
        let phonenumber = loadPhonenumber()
        let request = NSMutableURLRequest(url: url)
        
        
        request.httpMethod = "POST"
        var postParameters = "action=updatechallenge"
        postParameters += "&phonenumber=" + phonenumber
        postParameters += "&moves=" + moves.getMovesAsString()
        postParameters += "&gameid=" + "\(challengeid)"
        
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, responce, error in
            
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            
            if data != nil {
                // Check for success
                self.getChallenges()
            }
            
        }
        task.resume()
    }
    
    func getStats(){
        let url: URL = URL(string: urlPath)!
        let phonenumber = loadPhonenumber()
        let request = NSMutableURLRequest(url: url)
        
        
        request.httpMethod = "POST"
        var postParameters = "action=getstats"
        postParameters += "&phonenumber=" + phonenumber
        
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, responce, error in
            
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            
            if data != nil {
                // Check for success
                self.parseStats(data: data!)
            }
        }
        task.resume()
    }
    
    func parseStats(data: Data){
        var jsonResult: [[String: Any]] = [[String: Any]]()
        
        do {
            
            try jsonResult = JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as! [[String: Any]]
            
        } catch let error as NSError {
            print("Error: \(error)")
        }
        
        if jsonResult.count != 0 {
            if let games: String = jsonResult.first?["number_of_games"] as? String, let gamesWon: String = jsonResult.first?["number_of_wins"] as? String {
                DispatchQueue.main.async {
                    self.delegate.updateStats(games: games, gamesWon: gamesWon)
                }
            }
        }
    }
    
    func updateWins(phonenumber: String){
        let url: URL = URL(string: urlPath)!

        let request = NSMutableURLRequest(url: url)
        
        
        request.httpMethod = "POST"
        var postParameters = "action=updatewins"
        postParameters += "&phonenumber=" + phonenumber
        
        
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, responce, error in
            
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            
            if data != nil {
                // Check for success
                var jsonResult: [String: Any] = [String: Any]()
                
                do {
                    jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                    
                } catch let error as NSError {
                    print(error)
                }
                
                if jsonResult.count != 0 {
                    if let status = jsonResult["status"] as? String, let message = jsonResult["message"] as? String{
                        
                        if status == "Success"{
                            print("Status: \(message)")
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    func updateGames(phonenumber: String){
        let url: URL = URL(string: urlPath)!

        let request = NSMutableURLRequest(url: url)

        
        request.httpMethod = "POST"
        var postParameters = "action=updategames"
        postParameters += "&phonenumber=" + phonenumber
        
        
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, responce, error in
            
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            
            if data != nil {
                // Check for success
                var jsonResult: [String: Any] = [String: Any]()
                
                do {
                    jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                    
                } catch let error as NSError {
                    print(error)
                }
                
                if jsonResult.count != 0 {
                    if let status = jsonResult["status"] as? String, let message = jsonResult["message"] as? String{
                        
                        if status == "Success"{
                            print("Status: \(message)")
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    func setWatched(challengeid: Int){
        let url: URL = URL(string: urlPath)!
        let phonenumber = loadPhonenumber()
        let request = NSMutableURLRequest(url: url)
        
        
        request.httpMethod = "POST"
        var postParameters = "action=watched"
        postParameters += "&phonenumber=" + phonenumber
        postParameters += "&gameid=" + "\(challengeid)"
        
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, responce, error in
            
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            
            if data != nil {
                // Check for success
                var jsonResult: [String: Any] = [String: Any]()
                
                do {
                    jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                    
                } catch let error as NSError {
                    print(error)
                }
                
                if jsonResult.count != 0 {
                    if let status = jsonResult["status"] as? String, let message = jsonResult["message"] as? String{
                        
                        if status == "Success"{
                            print("Status: \(message)")
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
}
