//
//  ContactDetailViewModel.swift
//  Contacts
//
//  Created by Vignesh Radhakrishnan on 06/02/20.
 
//

import Foundation

final class ContactDetailViewModel {
    
    typealias CellViewModel = InformationTableViewCell.ViewModel
    private(set) var editContact: Contact
    private let service: ContactsGetDetailService & ContactsUpdateService
    var fields: [Field] {
        return [.phone,.email]
    }
    
    init( contact : inout Contact,service: ContactsGetDetailService & ContactsUpdateService = ContactsService()) {
        self.editContact = contact
        self.service = service
    }
    
    func fetchContactDetails(withSuccess onSuccess: @escaping () -> Void, andError onFailure: @escaping (_ error: Error?) -> Void) {
        self.service.getContactDetail(id: editContact.id, withSuccess: { (contact) in
            self.editContact = contact
            onSuccess()
        }) { (error) in
            onFailure(error)
        }
    }
    func cellViewModel(atIndex index: Int) -> InformationCellViewModel? {
           let field = fields[index]
           return CellViewModel(contact: editContact, field: field)
       }
    
     func favorite(withSuccess onSuccess: @escaping () -> Void, andError onFailure: @escaping (_ error: Error?) -> Void) {
        service.favorite(contact: editContact, withSuccess: { (contact) in
            self.editContact = contact
            onSuccess()
        }) { (error) in
            onFailure(error)
        }
    }
    func getEditContact() -> Contact {
        return editContact
    }
        
}
