//
//  ChoseContactCell.swift
//  chipView
//
//  Created by cuongdd on 09/03/2022.
//

import UIKit

class ChoseContactCell: BaseTableViewCell {
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var phoneTextView: UITextView!
    
    var infoContact = FetchedContact()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setDisplay()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDisplay() {
    }
    
    func fillData() {
        if let icon = infoContact.iconContact {
            contactImageView.image = UIImage(data: icon)
        }
        nameTextView.text = infoContact.firstName
        phoneTextView.text = "\(infoContact.telephone ?? "") \(infoContact.emailAddresses ?? "")"
    }
    
}

class BaseTableViewCell: UITableViewCell {

    weak var delegate: AnyObject?
    var indexPath: IndexPath?
    
    var isEnableLongPressGestureRecognizer: Bool = false
    lazy var longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if isEnableLongPressGestureRecognizer {
            addGestureRecognizer(longPressGestureRecognizer)
        }
        
        self.selectionStyle = .none
    }
    
    func setIndexPath(_ indexPath: IndexPath?, delegate: AnyObject?) {
        self.indexPath = indexPath
        self.delegate = delegate
    }
}

extension BaseTableViewCell {

    @objc class func identifier() -> String {
        return self.nibName()
    }
    
    @objc func setData(_ data: Any?) {
        
    }
}

extension BaseTableViewCell {

    // MARK: - Actions
    @objc func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
    }
}

extension UIView {
    
    static func nibName() -> String {
        let nameSpaceClassName = NSStringFromClass(self)
        let className = nameSpaceClassName.components(separatedBy: ".").last! as String
        return className
    }
    
    static func nib() -> UINib {
        return UINib(nibName: self.nibName(), bundle: nil)
    }
    
    static func loadFromNib<T: UIView>() -> T {
        let nameStr = "\(self)"
        let arrName = nameStr.split { $0 == "." }
        let nibName = arrName.map(String.init).last!
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! T
    }
}
