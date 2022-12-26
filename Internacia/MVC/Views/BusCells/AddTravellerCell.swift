//
//  AddTravellerCell.swift
//  Internacia
//
//  Created by Admin on 29/10/22.
//

import UIKit
protocol AddTravellerCellDelegate {
//    func categorySelected(sender: UIButton, cell: UITableViewCell)
    func typeSelected(sender: UIButton, cell: UITableViewCell)
    func firstNameTextField(sender: UITextField, cell: UITableViewCell)
    func lastNameTextField(sender: UITextField, cell: UITableViewCell)
}

class AddTravellerCell: UITableViewCell, UITextFieldDelegate, TravellerTitleCellDelegate {
    func travellerTitleForcell(title: String, indexPath: IndexPath) {
        tf_NameTitle.text = title
//        delegate?.typeSelected(title: title, cell: self)
    }
    
//    @IBOutlet weak var btn_travType: UIButton!
//    @IBOutlet weak var tf_travTypeField: UITextField!
    @IBOutlet weak var tf_NameTitle: UITextField!
    @IBOutlet weak var btn_nameTitleButton: UIButton!
    @IBOutlet weak var tf_firstName: UITextField!
    @IBOutlet weak var tf_lastName: UITextField!
    var selectedIndexPath : IndexPath?
    var delegate: AddTravellerCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        tf_firstName.delegate = self
        tf_lastName.delegate = self
//        tf_travTypeField.text = "Adult"
//        tf_NameTitle.text = "Mr"
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
    
//    @IBAction func categoryBtnTapped(_ sender: UIButton) {
//        delegate?.categorySelected(sender: sender, cell: self)
//    }
    @IBAction func nameTitleBtnTapped(_ sender: UIButton) {
//        print("name title button tapped")
//        let indexPath =  selectedIndexPath //tbl_traveller.indexPath(for: cell)
//        let parent_view = sender.superview
//        let fieldRect: CGRect = (self.contentView.convert((parent_view?.bounds)!, from: parent_view) )
//
//        // table pop view...
//        let tbl_popView = Bundle.main.loadNibNamed("TablePopView", owner: nil, options: nil)![0] as! TablePopView
//        tbl_popView.frame = CGRect.init(x: 0, y: 0, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
//        tbl_popView.customIndex = indexPath
//        tbl_popView.delegate_titleCell = self
//        tbl_popView.DType = .TitleCell
//        tbl_popView.title_array = ["Mr", "Ms", "Mrs", "Miss", "Master" ]
//        tbl_popView.changeMainView_Frame(rect: fieldRect)
//        self.contentView.addSubview(tbl_popView)
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
