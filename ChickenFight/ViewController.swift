//
//  ViewController.swift
//  ChickenFight
//
//  Created by Johan Wejdenstolpe on 2017-08-07.
//  Copyright © 2017 Johan Wejdenstolpe. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var btnNewChallenge: UIButton!
    
    let list: [String] = ["One", "Two", "three"]
    let sectionTitleArray: [String] = ["Challanges", "Waiting", "Done"]
    
    var contacts = [GameContact]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        let mask = UIInterfaceOrientationMask.portrait
        return mask
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        btnNewChallenge.imageView?.contentMode = .scaleAspectFit
        
        let dbConnector = DatabaseConnector()
        let numbers = "461234567,467654321"
        dbConnector.checkPhonenumbers(numbersToCheck: numbers)
        print("\(dbConnector.formatNumber(number: "073423525432"))")
        
        updateContactsArray()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    phoneNumbers.append(phoneNumber.value.stringValue)
                    
                }
                
                let newContact = GameContact(name: name, phoneNumbers: phoneNumbers)
                self.contacts.append(newContact)
                
            })
//            print("Contacts: \(self.contacts)")
            for gc in self.contacts {
                print("Name: \(gc.name), First number: \(gc.phoneNumbers[0])")
            }
        }
//        print("Contacts: \(self.contacts)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitleArray[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
}

