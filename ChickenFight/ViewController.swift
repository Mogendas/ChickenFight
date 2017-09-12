//
//  ViewController.swift
//  ChickenFight
//
//  Created by Johan Wejdenstolpe on 2017-08-07.
//  Copyright © 2017 Johan Wejdenstolpe. All rights reserved.
//

import UIKit
import Contacts
import Messages

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GetDataFromDBProtocal, ApiConnectorProtocol {
    
    @IBOutlet weak var btnNewChallenge: UIButton!
    
//    let list: [String] = ["One", "Two", "three"]
    var challengesList = [Challenge]()
    var waitingList = [Challenge]()
    var doneList = [Challenge]()
    var useChallenge: Challenge?
    var countryCode = "46"
    
    var refreshControl = UIRefreshControl()
    let sectionTitleArray: [String] = ["Challanges", "Waiting", "Done"]
    let dbConnector = DatabaseConnector()
    let apiConnector = ApiConnector()
    var contacts = [GameContact]()
    var friendsList = [GameContact]()
//    var verificationCode: String?
    
    @IBOutlet weak var challengesTableView: UITableView!
    
    @IBOutlet weak var contactsTableView: UITableView!

    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var newChallengeView: UIView!
    
    @IBOutlet weak var numberOfGAmesPlayed: UILabel!
    @IBOutlet weak var numberOfGamesWon: UILabel!
    @IBOutlet weak var btnChallengeOutlet: UIButton!
    
    @IBOutlet weak var scFirstAttack: UISegmentedControl!
    @IBOutlet weak var scSecondAttack: UISegmentedControl!
    @IBOutlet weak var scThirdAttack: UISegmentedControl!
    @IBOutlet weak var scFirstDefence: UISegmentedControl!
    @IBOutlet weak var scSecondDefence: UISegmentedControl!
    @IBOutlet weak var scThirdDefence: UISegmentedControl!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        let mask = UIInterfaceOrientationMask.portrait
        return mask
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive(_:)),
            name: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)
//        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        
        challengesTableView.delegate = self
        challengesTableView.dataSource = self
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
//        contactsTableView.tableHeaderView = nil
        btnNewChallenge.imageView?.contentMode = .scaleAspectFit
        dbConnector.delegate = self
        apiConnector.delegate = self
        contactView.layer.cornerRadius = 15
        newChallengeView.layer.cornerRadius = 15
//        let numbers = "467654321,461234567,"
//        dbConnector.checkPhonenumbers(numbersToCheck: numbers)
//        print("\(formatNumber(number: "073423525432"))")
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(ViewController.refresh), for: UIControlEvents.valueChanged)
        self.challengesTableView.addSubview(refreshControl)
//        updateContactsArray()
//        dbConnector.getStats()
//        let userSettings = UserDefaults()
//        if (userSettings.string(forKey: "userPhonenumber") != nil){
//            updateContactsArray()
//            dbConnector.getStats()
//        }
        
        
        
        
//        dbConnector.newUser(phonenumber: "4493939393")
//        let random = randomNumber()
//        print("Random: \(random)")
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
        
        // Test sms
//        sendSmsVerification(phonenumber: "46702666888")
        //End test sms
        
//        dbConnector.updateWins()
//        dbConnector.updateGames()
    }
    
    func applicationDidBecomeActive(_ notification: NSNotification) {
        let userSettings = UserDefaults()
        if (userSettings.string(forKey: "userPhonenumber") != nil){
            updateContactsArray()
            dbConnector.getStats()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userSettings = UserDefaults()
        
        if (userSettings.string(forKey: "userPhonenumber") == nil){
            startPhonenumberRegistration()
        }
    }
    
    func startPhonenumberRegistration(){
        var phonenumber = ""
        let alert = UIAlertController(title: "Register", message: "Enter your phonenuber to registrate.", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.keyboardType = UIKeyboardType.phonePad
            textField.placeholder = "ex. 00461234567"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            phonenumber = (alert?.textFields![0].text)!
//            print("Text field: \(String(describing: phonenumber))")
            phonenumber = self.formatNumber(number: phonenumber)
            self.sendSmsVerification(phonenumber: phonenumber)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func refresh() {
        updateContactsArray()
        dbConnector.getStats()
    }
    
    func endRefresh(){
        self.refreshControl.endRefreshing()
    }
    
    func reserMovesInNewChallengeView(){
        scFirstAttack.selectedSegmentIndex = UISegmentedControlNoSegment
        scSecondAttack.selectedSegmentIndex = UISegmentedControlNoSegment
        scThirdAttack.selectedSegmentIndex = UISegmentedControlNoSegment
        scFirstDefence.selectedSegmentIndex = UISegmentedControlNoSegment
        scSecondDefence.selectedSegmentIndex = UISegmentedControlNoSegment
        scThirdDefence.selectedSegmentIndex = UISegmentedControlNoSegment
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func btnCancelChallenge(_ sender: UIButton) {
        newChallengeView.isHidden = true
//        useChallenge = nil
    }
    @IBAction func btnContactsViewCancel(_ sender: UIButton) {
        contactView.isHidden = true
    }
    
    @IBAction func btnCreateNewChallenge(_ sender: UIButton) {
//        print(scFirstAttack.isSelected)
//        print(scFirstAttack.selectedSegmentIndex)
        if scFirstAttack.selectedSegmentIndex != -1 && scSecondAttack.selectedSegmentIndex != -1 && scThirdAttack.selectedSegmentIndex != -1 && scFirstDefence.selectedSegmentIndex != -1 && scSecondDefence.selectedSegmentIndex != -1 && scThirdDefence.selectedSegmentIndex != -1 {
            let firstAttack: Int = scFirstAttack.selectedSegmentIndex + 1
            let secondAttack: Int = scSecondAttack.selectedSegmentIndex + 1
            let thirdAttack: Int = scThirdAttack.selectedSegmentIndex + 1
            let firstDefence: Int = scFirstDefence.selectedSegmentIndex + 1
            let secondDefence: Int = scSecondDefence.selectedSegmentIndex + 1
            let thirdDefence: Int = scThirdDefence.selectedSegmentIndex + 1
            let moves = Moves(moves: "\(firstAttack)\(secondAttack)\(thirdAttack)\(firstDefence)\(secondDefence)\(thirdDefence)")
            
            if btnChallengeOutlet.titleLabel?.text == "Challenge" {
                useChallenge?.attackerMoves = moves
                dbConnector.newChallenge(challenge: useChallenge!)
                useChallenge = nil
            }else{
                useChallenge?.defenderMoves = moves
                dbConnector.updateChallenge(moves: moves, challengeid: (useChallenge?.challengeID)!)
                checkWinnerAndUpdateDB(challenge: useChallenge!)
                for friend in friendsList {
                    if friend.phoneNumbers[0] == useChallenge?.attacker {
                        useChallenge?.attacker = friend.name
                    }
                }
                performSegue(withIdentifier: "Fight", sender: self)
                useChallenge = nil
            }
            reserMovesInNewChallengeView()
            newChallengeView.isHidden = true
            
        }else{
            // Info to select all moves
            print("You need to select all moves to continue!")
        }
    }
    
    @IBAction func unwinedAction(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func btnNewCallenge(_ sender: UIButton) {
        contactsTableView.reloadData()
//        print("\(contacts.count)")
        contactView.isHidden = false
//        checkForIngameFriends()
    }
    
    func updateContactsArray(){
        contacts.removeAll()
        let userSettings = UserDefaults()
        var userPhonenumber = ""
        if (userSettings.string(forKey: "userPhonenumber") != nil){
            userPhonenumber = userSettings.string(forKey: "userPhonenumber")!
        }
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (isGranted, error) in
            let keys = [CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey]
            let request1 = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
            
            try? store.enumerateContacts(with: request1, usingBlock: { (contact, error) in
//                print("Name: \(contact.givenName), \(contact.familyName), Phone: ")
//                self.contacts.append(contact)
                
                let name = "\(contact.givenName) \(contact.familyName)"
                var phoneNumbers = [String]()
                if contact.phoneNumbers.count != 0 {
                    for phoneNumber in contact.phoneNumbers {
                        // Whatever you want to do with it
    //                    if let number = phoneNumber.value as? CNPhoneNumber {
    //                        print(phoneNumber.value.stringValue)
    //                    }
    //                    print("Phonenumber:\(phone)")
                        let newNumber: String = self.formatNumber(number: phoneNumber.value.stringValue)
                        if userPhonenumber != newNumber {
                            phoneNumbers.append(newNumber)
                        }
                    }
                    let newContact = GameContact(name: name, phoneNumbers: phoneNumbers)
                    self.contacts.append(newContact)
                }
                
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
        friendsList.removeAll()
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
        challengesList.removeAll()
        waitingList.removeAll()
        doneList.removeAll()
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
        challengesList.sort(by: {$0.challengeID! > $1.challengeID!})
        waitingList.sort(by: {$0.challengeID! > $1.challengeID!})
        doneList.sort(by: {$0.challengeID! > $1.challengeID!})
//        for challenge in doneList {
//            print(challenge.challengeID)
//        }
        endRefresh()
        challengesTableView.reloadData()
    }
    
    func sendSmsVerification(phonenumber: String){
        let verificationCode = randomNumber()
//        print("Code: \(verificationCode)")
        apiConnector.verifyPhonenumber(phonenumber: phonenumber, vericationCode: verificationCode)
    }
    
    func smsVerificationSent(phonenumber: String, verificatoinCode: String){
        // Verify code and save phonenumber in database
        let alert = UIAlertController(title: "Verify sms code", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.keyboardType = UIKeyboardType.phonePad
            textField.placeholder = "Enter code"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let code = (alert?.textFields![0].text)!
            //                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
//            print("Text field: \(String(describing: phonenumber))")
            if code == verificatoinCode {
                let userDefaults = UserDefaults()
                userDefaults.setValue(phonenumber, forKey: "userPhonenumber")
                userDefaults.synchronize()
                self.dbConnector.newUser(phonenumber: phonenumber)
            }
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func updateStats(games: String, gamesWon: String) {
        // Update stats in ui
        numberOfGAmesPlayed.text = games
        numberOfGamesWon.text = gamesWon
    }
    
    func checkWinnerAndUpdateDB(challenge: Challenge){
        var attackerScore = 0
        var defenderScore = 0
        
        if challenge.attackerMoves?.attack1 != challenge.defenderMoves?.defence1{
            attackerScore += 1
        }
        if challenge.attackerMoves?.attack2 != challenge.defenderMoves?.defence2{
            attackerScore += 1
        }
        if challenge.attackerMoves?.attack3 != challenge.defenderMoves?.defence3{
            attackerScore += 1
        }
        if challenge.defenderMoves?.attack1 != challenge.attackerMoves?.defence1{
            defenderScore += 1
        }
        if challenge.defenderMoves?.attack2 != challenge.attackerMoves?.defence2{
            defenderScore += 1
        }
        if challenge.defenderMoves?.attack3 != challenge.attackerMoves?.defence3{
            defenderScore += 1
        }
        if attackerScore > defenderScore{
            dbConnector.updateWins(phonenumber: (challenge.attacker)!)
        }else{
            dbConnector.updateWins(phonenumber: (challenge.defender)!)
        }
        
        dbConnector.updateGames(phonenumber: (challenge.attacker)!)
        dbConnector.updateGames(phonenumber: (challenge.defender)!)
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
            cell.selectionStyle = .none
            if indexPath.section == 0{
                var name = "+\(challengesList[indexPath.row].attacker!)"
                for friend in friendsList {
                    if friend.phoneNumbers[0] == challengesList[indexPath.row].attacker{
                        name = friend.name
                    }
                }
                cell.textLabel?.text = name
            }
            if indexPath.section == 1 {
                var name = "+\(waitingList[indexPath.row].defender!)"
                for friend in friendsList {
                    if friend.phoneNumbers[0] == waitingList[indexPath.row].defender{
                        name = friend.name
                    }
                }
                cell.textLabel?.text = name
                
//                cell.textLabel?.text = waitingList[indexPath.row].defender
            }
            if indexPath.section == 2 {
                var name = "Unknown"
                let userSettings = UserDefaults()
                if let userPhonenumber = userSettings.string(forKey: "userPhonenumber") {
                    if userPhonenumber == doneList[indexPath.row].attacker {
                        name = "+\(doneList[indexPath.row].defender!)"
                        for friend in friendsList {
                            if friend.phoneNumbers[0] == doneList[indexPath.row].defender {
                                name = friend.name
                            }
                        }
                    }else{
                        name = "+\(doneList[indexPath.row].attacker!)"
                        for friend in friendsList {
                            if friend.phoneNumbers[0] == doneList[indexPath.row].attacker {
                                name = friend.name
                            }
                        }
                    }
                    
                    
                }
                
//                for friend in friendsList {
//                    if friend.phoneNumbers[0] == doneList[indexPath.row].defender{
//                        name = friend.name
//                    }else if friend.phoneNumbers[0] == doneList[indexPath.row].attacker{
//                        name = friend.name
//                    }
//                }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == contactsTableView{
//            startChallenge(phonenumber: friendsList[indexPath.row].phoneNumbers[0])
            let newChallengerPhonenumber = friendsList[indexPath.row].phoneNumbers[0]
            let challenge = Challenge()
            challenge.defender = newChallengerPhonenumber
            self.useChallenge = challenge
            
            contactView.isHidden = true
            btnChallengeOutlet.titleLabel?.text = "Challenge"
            newChallengeView.isHidden = false
        }else{
            
            if indexPath.section != 1 {
                
            }
            
            if indexPath.section == 0 {
                useChallenge = challengesList[indexPath.row]
//                for friend in friendsList {
//                    if friend.phoneNumbers[0] == useChallenge?.attacker {
//                        useChallenge?.attacker = friend.name
//                    }
//                }
                
                btnChallengeOutlet.titleLabel?.text = "Fight"
                newChallengeView.isHidden = false
//              print("Fight")
            }
            if indexPath.section == 2 {
                useChallenge = doneList[indexPath.row]
                let userSettings = UserDefaults()
                if (userSettings.string(forKey: "userPhonenumber") != nil){
                    let userPhonenumber = userSettings.string(forKey: "userPhonenumber")
                    if userPhonenumber == useChallenge?.attacker {
                        // You are attacking
                        for friend in friendsList {
                            if friend.phoneNumbers[0] == useChallenge?.defender {
                                useChallenge?.defender = friend.name
                            }
                        }
                    }else{
                        // You are defending
                        for friend in friendsList {
                            if friend.phoneNumbers[0] == useChallenge?.attacker{
                                useChallenge?.attacker = friend.name
                            }
                        }
                    }
                }
                dbConnector.setWatched(challengeid: (useChallenge?.challengeID)!)
                performSegue(withIdentifier: "Fight", sender: self)
                // Show fight
//                print("Show fight")
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Fight" {
            let fightScene = segue.destination as? FightVC
//            let indexPath = self.challengesTableView.indexPathForSelectedRow
            fightScene?.challenge = useChallenge
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
            formattedNumber = countryCode + formattedNumber
        }
        return formattedNumber
    }
    
    func randomNumber()-> String{
        let randomInt = Int(arc4random_uniform(UInt32(9999)) + UInt32(1000))
        let randomString:String = String(randomInt)
        return randomString
    }
    
//    func getCountryCode(){
//        let userSettings = UserDefaults()
//        if let phonenumber = userSettings.string(forKey: "userPhonenumber"){
//            let first = Array(phonenumber)[0]
//            let second = Array(phonenumber)[1]
//            countryCode = "\(first)\(second)"
//            
//        }
//        
//    }
    
}

