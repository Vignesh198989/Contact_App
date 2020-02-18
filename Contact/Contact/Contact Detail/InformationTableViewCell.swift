//
//  ContactInformationCell.swift
//  Contacts
//
//  Created by Vignesh Radhakrishnan on 05/02/20
//

import Foundation

protocol InformationCellViewModel {
    var name: String {get}
    var value: String {get}
}

final class InformationTableViewCell: UITableViewCell {

    struct ViewModel: InformationCellViewModel {
        let name: String
        let value: String
    }
    
    @IBOutlet weak var fieldName: UILabel!
    @IBOutlet weak var value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(viewModel: InformationCellViewModel) {
        self.fieldName.text = viewModel.name
        self.value.text = viewModel.value
    }

}

extension InformationTableViewCell.ViewModel {
    init?(contact:Contact, field: Field) {
        switch field {
        case .email:
            self.name = "Email"
            if let value = contact.email, !value.isEmpty {
                self.value = value
            } else {
                self.value = "unavailable"
            }
        case .phone:
            self.name = "Mobile"
            if let value = contact.phoneNumber, !value.isEmpty {
                self.value = value
            } else {
                self.value = "unavailable"
            }
        default:
            return nil
        }
    }
}
