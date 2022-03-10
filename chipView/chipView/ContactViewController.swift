//
//  ContactViewController.swift
//  chipView
//
//  Created by cuongdd on 10/03/2022.
//

import UIKit
import ContactsUI

class ContactViewController: UIViewController, CNContactPickerDelegate {
    
    @IBOutlet weak var givenNameLabel: UILabel!
    @IBOutlet weak var phoneNumbersLabel: UILabel!
    @IBOutlet weak var emailAddressesLabel: UILabel!
    
    var slectEmail: ((String?) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        givenNameLabel.text = ""
        phoneNumbersLabel.text = ""
        emailAddressesLabel.text = ""
    }
    
    @IBAction func tapShowContacts(_ sender: Any) {
        onClickPickContact()
    }
    
    //MARK:- contact picker
    func onClickPickContact(){
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys =
        [CNContactGivenNameKey, CNContactPhoneNumbersKey]
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController,
                       didSelect contactProperty: CNContactProperty) {
        
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        // You can fetch selected name and number in the following way
        
        // user name
        let givenName: String = contact.givenName
        let familyName: String = contact.familyName
        let userName = givenName + " " + familyName
        
        // user phone number
        let userPhoneNumbers: [CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
        let firstPhoneNumber: CNPhoneNumber = userPhoneNumbers[0].value
        
        
        // user phone number string
        let primaryPhoneNumberStr:String = firstPhoneNumber.stringValue
        
        let emailAddresses = contact.emailAddresses.first?.value
        
        givenNameLabel.text = userName
        phoneNumbersLabel.text = primaryPhoneNumberStr
        emailAddressesLabel.text = "\(emailAddresses ?? "nill")"
        if let email = emailAddresses {
            slectEmail?(email as String)
        }
        
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
    }
}