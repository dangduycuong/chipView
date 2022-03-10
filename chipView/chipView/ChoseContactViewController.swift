//
//  ChoseContactViewController.swift
//  chipView
//
//  Created by cuongdd on 09/03/2022.
//

import UIKit
import ContactsUI
import Contacts

class ChoseContactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var titleString: String?
    var contacts = [FetchedContact]()
    var suggestContacts = [FetchedContact]()
    
    var closureContact: ((FetchedContact) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        setDisplay()
        tableView.register(ChoseContactCell.nib(), forCellReuseIdentifier: ChoseContactCell.identifier())
        createListContact()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let titleString = titleString {
            title = titleString
        }
    }
    
    func setDisplay() {
        searchView.layer.cornerRadius = 16
        
        searchView.layer.shadowColor = UIColor.black.cgColor
        searchView.layer.shadowOpacity = 0.8
        searchView.layer.shadowOffset = .zero
        searchView.layer.shadowRadius = 10
    }
    
    // MARK:
    
    func createListContact() {
        print("Attempting to fetch contacts")
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("failed to request access", error)
                return
            }
            
            if granted {
                print("access granted")
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        print(contact.givenName)
                        var item = FetchedContact()
                        item.firstName = contact.givenName
                        item.lastName = contact.familyName
                        item.telephone = contact.phoneNumbers.first?.value.stringValue
                        
                        for email in contact.emailAddresses{
                            if let emailAddresses = email.value as? String {
                                item.emailAddresses = emailAddresses
                                print("This contact already has this email", emailAddresses)
                                return
                            }
                        }
                        self.contacts.append(item)
                        self.suggestContacts.append(item)
                        //                        self.contacts.append(FetchedContact(firstName: contact.givenName, lastName: contact.familyName, telephone: contact.phoneNumbers.first?.value.stringValue ?? "", iconContact: contact.imageData))
                    })
                } catch let error {
                    print("Failed to enumerate contact", error)
                }
            } else {
                print("access denied")
            }
        }
        //        suggestContacts = contacts
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChoseContactCell.identifier(), for: indexPath) as! ChoseContactCell
        cell.infoContact = suggestContacts[indexPath.row]
        cell.fillData()
        return cell
    }
    
    func filterContact() {
        if searchTextField.text == "" {
            suggestContacts = contacts
        } else {
            suggestContacts = contacts.filter { (data: FetchedContact) in
                if let text = searchTextField.text, let name = data.firstName, let phone = data.telephone {
                    if name.lowercased().range(of: text.lowercased()) != nil || phone.lowercased().range(of: text.lowercased()) != nil {
                        return true
                    }
                }
                return false
            }
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        closureContact?(suggestContacts[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        filterContact()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        filterContact()
    }
    
}

struct FetchedContact {
    var firstName: String?
    var lastName: String?
    var telephone: String?
    var iconContact: Data?
    
    var emailAddresses: String?
}
