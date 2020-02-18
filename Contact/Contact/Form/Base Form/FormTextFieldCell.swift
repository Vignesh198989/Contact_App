//
//  FormTextFieldCell.swift
//  Contacts
//
//  Created by Vignesh Radhakrishnan on 06/02/20.
//

import Foundation

protocol FormTextFieldCellDelegate : class {
    func didUpdate(text : String,indexPath : IndexPath)
}

final class FormTextFieldCell: UITableViewCell,FormCellDataSource {
   
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    
    weak var delegate : FormTextFieldCellDelegate?
    private(set) var indexPath : IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func configureCell(datasource: ConfigureCellProtocol, delegate: FormTextFieldCellDelegate?, indexPath: IndexPath) {
        self.nameLabel.text = datasource.getFieldName()
        self.textField.text = datasource.getFieldValue()
        self.textField.placeholder = datasource.getPlaceHolder()
        self.delegate = delegate
        self.indexPath = indexPath
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
}

extension FormTextFieldCell : UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.delegate?.didUpdate(text: textField.text ?? "", indexPath: self.indexPath)
    }
}
