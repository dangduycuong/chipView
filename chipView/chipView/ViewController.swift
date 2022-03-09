//
//  ViewController.swift
//  chipView
//
//  Created by cuongdd on 09/03/2022.
//

import UIKit
import MessageUI
import SafariServices
import VisionKit
import PDFKit
import Contacts

class ViewController: UIViewController, UINavigationControllerDelegate {
    let mailButton = UIButton()
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var tagsArray = [String]()
    var fileName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide Keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        setupButton()
    }
    
    @objc func showMailComposer() {
        if MFMailComposeViewController.canSendMail() {
            let fileManager = FileManager.default
            let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            var docURL = documentDirectory.appendingPathComponent("Scanned-Docs.pdf")
            docURL = documentDirectory.appendingPathComponent(fileName)
            
            let fileData = try? Data(contentsOf: docURL.absoluteURL)
            
            let composer = MFMailComposeViewController()
            composer.mailComposeDelegate = self
            composer.setToRecipients(tagsArray)
            composer.setSubject("Hey there!")
            if let data = fileData {
                composer.addAttachmentData(data, mimeType: "mimeType", fileName: fileName)
            }
            composer.setMessageBody("<h1> Hi, I'd like to know </h1>", isHTML: true)
            present(composer, animated: true)
        } else {
            guard let url = URL(string: "https://www.google.com") else {
                return
            }
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true, completion: nil)
        }
    }
    
    func setupButton() {
        cameraButton.setTitle("", for: .normal)
        
        view.addSubview(mailButton)
        mailButton.backgroundColor = .systemBlue
        mailButton.addTarget(self, action: #selector(showMailComposer), for: .touchUpInside)
        mailButton.setTitle(NSLocalizedString("Email me", comment: ""), for: .normal)
        mailButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        mailButton.setImage(UIImage(named: "icons8-email_send"), for: .normal)

        mailButton.translatesAutoresizingMaskIntoConstraints = false
        mailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mailButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mailButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        mailButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    func createTagCloud(OnView view: UIView, withArray data: [AnyObject]) {
        
        for tempView in view.subviews {
            if tempView.tag != 0 {
                tempView.removeFromSuperview()
            }
        }
        
        var xPos: CGFloat = 15.0
        var ypos: CGFloat = 130.0
        var tag: Int = 1
        for str in data  {
            let startstring = str as! String
            let width = startstring.widthOfString(usingFont: UIFont(name: "verdana", size: 13.0)!)
            let checkWholeWidth = CGFloat(xPos) + CGFloat(width) + CGFloat(13.0) + CGFloat(25.5 )//13.0 is the width between lable and cross button and 25.5 is cross button width and gap to righht
            if checkWholeWidth > UIScreen.main.bounds.size.width - 30.0 {
                //we are exceeding size need to change xpos
                xPos = 15.0
                ypos = ypos + 29.0 + 8.0
            }
            
            let bgView = UIView(frame: CGRect(x: xPos, y: ypos, width:width + 17.0 + 38.5 , height: 29.0))
            bgView.layer.cornerRadius = 14.5
            bgView.backgroundColor = UIColor(red: 33.0/255.0, green: 135.0/255.0, blue:199.0/255.0, alpha: 1.0)
            bgView.tag = tag
            
            let textlable = UILabel(frame: CGRect(x: 17.0, y: 0.0, width: width, height: bgView.frame.size.height))
            textlable.font = UIFont(name: "verdana", size: 13.0)
            textlable.text = startstring
            textlable.textColor = UIColor.white
            bgView.addSubview(textlable)
            
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: bgView.frame.size.width - 2.5 - 23.0, y: 3.0, width: 23.0, height: 23.0)
            button.backgroundColor = UIColor.white
            button.layer.cornerRadius = CGFloat(button.frame.size.width)/CGFloat(2.0)
            button.setImage(UIImage(named: "icons8-delete"), for: .normal)
            button.tag = tag
            button.addTarget(self, action: #selector(removeTag(_:)), for: .touchUpInside)
            bgView.addSubview(button)
            xPos = CGFloat(xPos) + CGFloat(width) + CGFloat(17.0) + CGFloat(43.0)
            view.addSubview(bgView)
            tag = tag  + 1
            topConstraint.constant = ypos
        }
        
    }
    
    @objc func removeTag(_ sender: AnyObject) {
        tagsArray.remove(at: (sender.tag - 1))
        createTagCloud(OnView: self.view, withArray: tagsArray as [AnyObject])
    }
    
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in }))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func clickToAddTag(_ sender: Any) {
        if inputTextField.text?.count != 0 {
            tagsArray.append(inputTextField.text!)
            createTagCloud(OnView: self.view, withArray: tagsArray as [AnyObject])
        }
    }
    
    @IBAction func tapToOpenCamera(_ sender: Any) {
        openVisionKit()
    }
    
    
    @IBAction func tapToGetContact(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChoseContactViewController") as! ChoseContactViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
//    func getAllContacts() {
//
//        let status = CNContactStore.authorizationStatus(for: CNEntityType.contacts) as CNAuthorizationStatus
//
//        if status == CNAuthorizationStatus.denied {
//
//            let alert = UIAlertController(title:nil, message:"This app previously was refused permissions to contacts; Please go to settings and grant permission to this app so it can use contacts", preferredStyle:UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated:true, completion: nil)
//            return
//        }
//
//        let store = CNContactStore()
//        store.requestAccess(for: .contacts, completionHandler: { (granted, error) in
//            if !granted {
//
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    // user didn't grant access;
//                    // so, again, tell user here why app needs permissions in order  to do it's job;
//                    // this is dispatched to the main queue because this request could be running on background thread
//                })
//                return
//            }
//
//        })
//        store.requestAccessForEntityType(CNEntityType.Contacts) { (granted: Bool, error: NSError?) -> Void in
//
//            if !granted {
//
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//
//                    // user didn't grant access;
//                    // so, again, tell user here why app needs permissions in order  to do it's job;
//                    // this is dispatched to the main queue because this request could be running on background thread
//                })
//                return
//            }
//
//            let arrContacts = NSMutableArray() // Declare this array globally, so you can access it in whole class.
//
//            let request = CNContactFetchRequest(keysToFetch:[CNContactIdentifierKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey, CNContactPhoneNumbersKey, CNContactFormatter.descriptorForRequiredKeysForStyle(CNContactFormatterStyle.FullName)])
//
//            do {
//
//                try store.enumerateContactsWithFetchRequest(request, usingBlock: { (contact:CNContact, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
//
//                    let arrEmail = contact.emailAddresses as NSArray
//
//                    if arrEmail.count > 0 {
//
//                        let dict = NSMutableDictionary()
//                        dict.setValue((contact.givenName+" "+contact.familyName), forKey: "name")
//                        let emails = NSMutableArray()
//
//                        for index in 0...arrEmail.count {
//
//                            let email:CNLabeledValue = arrEmail.objectAtIndex(index) as! CNLabeledValue
//                            emails .addObject(email.value as! String)
//                        }
//                        dict.setValue(emails, forKey: "email")
//                        arrContacts.addObject(dict) // Either retrieve only those contact who have email and store only name and email
//                    }
//                    arrContacts.addObject(contact) // either store all contact with all detail and simplifies later on
//                })
//            } catch {
//
//                return;
//            }
//        }
//    }
    
}


extension ViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            controller.dismiss(animated: true, completion: nil)
            return
        }
        switch result {
        case .cancelled:
            break
        case .failed:
            break
        case .saved:
            break
        case .sent:
            showAlert(title: "Notice", message: "Da gui email")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UIDocumentPickerDelegate, VNDocumentCameraViewControllerDelegate {
    func getFileName() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd'T'HH_mm_ss.'pdf'" //"yyyy-MM-dd'T'HH:mm:ssZ", "yyyy_MM_dd'T'HH_mm_ss.'pdf'", "yyyy_MM_dd'T'HH_mm_ss"
        let string = formatter.string(from: date)
        return string
    }
    
    func openVisionKit() {
        
        DispatchQueue.main.async {
            let documentCameraViewController = VNDocumentCameraViewController()
            documentCameraViewController.delegate = self
            self.present(documentCameraViewController, animated: true)
        }
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        fileName = getFileName()
        convertImageToPDFFile(fileName: fileName, scan: scan)
        controller.dismiss(animated: false)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func convertImageToPDFFile(fileName: String, scan: VNDocumentCameraScan) {
        var docs: [DocumentModel] = []
        let myGroup = DispatchGroup()
        let pdfDocument = PDFDocument()
        let pdfPageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
        
        for index in 0..<scan.pageCount {
            myGroup.enter()
            let image = scan.imageOfPage(at: index)
            let scaledImage = image.resizedImage()
            
            if let dataCom = scaledImage.jpegData(compressionQuality: 0.7), let imagePdf = UIImage(data: dataCom) {
                // Create a PDF page instance from your image
                let pdfPage = PDFPage(image: imagePdf)
                pdfPage!.setBounds(pdfPageRect, for: PDFDisplayBox.artBox)
                pdfDocument.insert(pdfPage!, at: index)
                var doc = DocumentModel(image: imagePdf, content: "")
                image.detechTextFormImage { (result, error) in
                    doc.content = result
                    docs.append(doc)
                    myGroup.leave()
                }
            }
        }
        
        // Get the raw data of your PDF document
        let data = pdfDocument.dataRepresentation()
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let docURL = documentDirectory.appendingPathComponent(fileName)
        do {
            try data?.write(to: docURL)
        } catch(let error) {
            print("error is \(error.localizedDescription)")
        }
        
        myGroup.notify(queue: .main) { [weak self] in
            guard let `self` = self else {return}
        }
    }
    
}

extension String {
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

public struct DocumentModel {
    var id_document: NSNumber?
    var id_enterprise: String?
    var id_trip: String?
    var url: String?
    var page: String?
    var created_at: String?
    var updated_at: String?
    var documentIdTrip: String?
    var image: UIImage?
    var content: String?
    var docType: String?
    
    init(image: UIImage?, content: String?) {
        self.image = image
        self.content = content
    }
}

extension UIImage {
    open var width: CGFloat {
      return size.width
    }
    
    /// Height of the UIImage.
    open var height: CGFloat {
      return size.height
    }
    
    func resizedImage() -> UIImage {
        let imageSize = CGSize(width: 612 * 1.2, height: 792 * 1.2)
        let pageSize = imageSize
        let newSizeResized = getNewSizeResized()
        UIGraphicsBeginImageContextWithOptions(pageSize, false, 0.0)
        draw(in: CGRect(x: (pageSize.width - newSizeResized.width) / 2, y: (pageSize.height - newSizeResized.height) / 2,
                        width: newSizeResized.width, height: newSizeResized.height))
        
        let finalImage: UIImage
        if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
            finalImage = newImage
        } else {
            finalImage = self
        }
        UIGraphicsEndImageContext()
        return finalImage
    }
    
    func getNewSizeResized() -> CGSize {
        let imageSize = CGSize(width: 612 * 1.2, height: 792 * 1.2)
        if self.width < imageSize.width && self.height < imageSize.height {
            return self.size
        }
        var ratio: CGFloat = 1.0
        if (self.width / self.height) > (imageSize.width / imageSize.height) {
            ratio = self.width / imageSize.width
        }
        else {
            ratio = self.height / imageSize.height
        }
        
        let newWidth = self.width / ratio
        let newHeight = self.height / ratio
        
        return CGSize(width: newWidth, height: newHeight)
    }
    
    func detechTextFormImage(complettion: ((String?, Error?) -> Void)?) {
//        let visionImage = VisionImage(image: self)
//        let textRecognizer = TextRecognizer.textRecognizer()
//        textRecognizer.process(visionImage) { result, error in
//            complettion?(result?.text, error)
//        }
    }
}
