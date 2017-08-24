//
//  ViewController.swift
//  ChickenFight
//
//  Created by Johan Wejdenstolpe on 2017-08-07.
//  Copyright © 2017 Johan Wejdenstolpe. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GetDataFromDBProtocal {
    
    @IBOutlet weak var btnNewChallenge: UIButton!
    
//    let list: [String] = ["One", "Two", "three"]
    var challengesList = [Challenge]()
    var waitingList = [Challenge]()
    var doneList = [Challenge]()
    let sectionTitleArray: [String] = ["Challanges", "Waiting", "Done"]
    let dbConnector = DatabaseConnector()
    var contacts = [GameContact]()
    var friendsList = [GameContact]()
    
    @IBOutlet weak var challengesTableView: UITableView!
    
    @IBOutlet weak var contactsTableView: UITableView!

    @IBOutlet weak var contactView: UIView!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        let mask = UIInterfaceOrientationMask.portrait
        return mask
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        challengesTableView.delegate = self
        challengesTableView.dataSource = self
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
//        contactsTableView.tableHeaderView = nil
        btnNewChallenge.imageView?.contentMode = .scaleAspectFit
        dbConnector.delegate = self
        contactView.layer.cornerRadius = 20
//        let numbers = "467654321,461234567,"
//        dbConnector.checkPhonenumbers(numbersToCheck: numbers)
//        print("\(formatNumber(number: "073423525432"))")
        
        updateContactsArray()
//        dbConnector.getChallenges()
        
        
        // Test newChallenge
//        let opponent = "461234567"
//        let moves = Moves(moves: "111333")
//        let challenge = Challenge(opponent: opponent, myMoves: moves)
//        dbConnector.newChallenge(challenge: challenge)
        // End test newChallenge
        
        // Test uppdateChallenge
//        let gameid = 10
//        let moves = Moves(moves: "333111")
//        dbConnector.updateChallenge(moves: moves, challengeid: gameid)
        // End test updateChallenge
        
        // Test watched
//        let gameid = 10
//        dbConnector.setWatched(challengeid: gameid)
        // End test wathed
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnNewCallenge(_ sender: UIButton) {
        contactsTableView.reloadData()
//        print("\(contacts.count)")
        contactView.isHidden = false
//        checkForIngameFriends()
    }
    
    func updateContactsArray(){
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (isGranted, error) in
            let keys = [CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey]
            let request1 = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
            
            try? store.enumerateContacts(with: request1, usingBlock: { (contact, error) in
//                print("Name: \(contact.givenName), \(contact.familyName), Phone: ")
//                self.contacts.append(contact)
                
                let name = "\(contact.givenName) \(contact.familyName)"
                var phoneNumbers = [String]()
                
                for phoneNumber in contact.phoneNumbers {
                    // Whatever you want to do with it
//                    if let number = phoneNumber.value as? CNPhoneNumber {
//                        print(phoneNumber.value.stringValue)
//                    }
//                    print("Phonenumber:\(phone)")
                    let newNumber = self.formatNumber(number: phoneNumber.value.stringValue)
                    phoneNumbers.append(newNumber)
                    
                }
                
                let newContact = GameContact(name: name, phoneNumbers: phoneNumbers)
                self.contacts.append(newContact)
                
            })
//            print("Contacts: \(self.contacts)")
//            for gc in self.contacts {
//                print("Name: \(gc.name), First number: \(gc.phoneNumbers[0])")
//            }
//            self.contactsTableView.reloadData()
            self.checkForIngameFriends()
        }
//        print("Contacts: \(self.contacts)")
    }
    
    func checkForIngameFriends(){
        var numbersToCheck = ""
        for contact in contacts {
            for number in contact.phoneNumbers {
                numbersToCheck += "\(number),"
//                print(number)
            }
        }
//        print("NumbersToCheck: \(numbersToCheck)")
        dbConnector.checkPhonenumbers(numbersToCheck: numbersToCheck)
    }
    
    func phonenumbersChecked(numbers: [String]){
        // Update a new array with contacts
        for number in numbers {
            for contact in contacts {
                if contact.phoneNumbers.contains(number){
                    let name = contact.name
                    var excistingNumber = [String]()
                    excistingNumber.append(number)
                    let newContact = GameContact(name: name, phoneNumbers: excistingNumber)
                    friendsList.append(newContact)
                }
            }
        }
        dbConnector.getChallenges()
    }
    
    func updateChallengeList(challengeList: [Challenge]){
        for challenge in challengeList{
            if challenge.defenderMoves == nil {
                if challenge.attacker == dbConnector.loadPhonenumber() {
                    waitingList.append(challenge)
                }else{
                    challengesList.append(challenge)
                }
            }else{
                doneList.append(challenge)
            }
        }
        challengesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0
        if tableView == challengesTableView {
            switch section {
            case 0:
                rows = challengesList.count
            break;
                
            case 1:
                rows = waitingList.count
            break;
                
            case 2:
                rows = doneList.count
            break;
                
            default:
                rows = 0
            }
        }else{
            return friendsList.count
        }
        return rows
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == challengesTableView {
            return 3
        }else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == challengesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//            cell.textLabel?.text = list[indexPath.row]
            if indexPath.section == 0{
                var name = "Temp"
                for friend in friendsList {
                    if friend.phoneNumbers[0] == challengesList[indexPath.row].attacker{
                        name = friend.name
                    }
                }
                cell.textLabel?.text = name
            }
            if indexPath.section == 1 {
                var name = "Temp"
                for friend in friendsList {
                    if friend.phoneNumbers[0] == waitingList[indexPath.row].defender{
                        name = friend.name
                    }
                }
                cell.textLabel?.text = name
                
//                cell.textLabel?.text = waitingList[indexPath.row].defender
            }
            if indexPath.section == 2 {
                var name = "Temp"
                for friend in friendsList {
                    if friend.phoneNumbers[0] == doneList[indexPath.row].defender{
                        name = friend.name
                    }else if friend.phoneNumbers[0] == doneList[indexPath.row].attacker{
                        name = friend.name
                    }
                }
                cell.textLabel?.text = name
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
            cell.textLabel?.text = friendsList[indexPath.row].name
//            print("\(contacts[indexPath.row].name)")
//            print(contacts.count)
            return cell
        }
//        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == challengesTableView{
            return sectionTitleArray[section]
        }else{
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == challengesTableView{
            return 28
        }else{
            return 0
        }
    }
    
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
    
}

