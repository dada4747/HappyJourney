//
//  AddTravellerCell.swift
//  ExtactTravel
//
//  Created by Admin on 24/08/22.
//

import UIKit
protocol AddTTravellerCellDelegate {
    func categorySelected(sender: UIButton, cell: UITableViewCell)
    func typeSelected(sender: UIButton, cell: UITableViewCell)
    func firstNameTextField(sender: UITextField, cell: UITableViewCell)
    func lastNameTextField(sender: UITextField, cell: UITableViewCell)
}

class AddTTravellerCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var btn_travType: UIButton!
    @IBOutlet weak var tf_travTypeField: UITextField!
    @IBOutlet weak var tf_NameTitle: UITextField!
    @IBOutlet weak var btn_nameTitleButton: UIButton!
    @IBOutlet weak var tf_firstName: UITextField!
    @IBOutlet weak var tf_lastName: UITextField!
    var delegate: AddTTravellerCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        tf_firstName.delegate = self
        tf_lastName.delegate = self
        tf_travTypeField.text = "Adult"
        tf_NameTitle.text = "Mr"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func categoryBtnTapped(_ sender: UIButton) {
        delegate?.categorySelected(sender: sender, cell: self)
    }
    @IBAction func nameTitleBtnTapped(_ sender: UIButton) {
        delegate?.typeSelected(sender: sender, cell: self)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
    }
    
    @objc func valueChanged(_ textField: UITextField){
        if textField == tf_firstName {
            delegate?.firstNameTextField(sender: textField, cell: self)
        } else if textField == tf_lastName {
            delegate?.lastNameTextField(sender: textField, cell: self)
        }
        
    }
}
