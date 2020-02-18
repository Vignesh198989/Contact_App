//
//  ContactsListViewModel.swift
//  Contacts
//
//  Created by Vignesh Radhakrishnan on 06/02/20.
 
//

import Foundation

protocol ListCellViewModel {
    var name: String {get}
    var profilePicturePath: String? {get}
    var favourite: Bool {get}
}

struct ContactListSection {
    let sectionTitle: String
    let contacts: [Contact]
}
struct Image {
    static let profilePicturePlaceHolder = "placeholder_photo"
}
final class ContactsListViewModel {
    
    private(set) var contactListSections: [ContactListSection] = []
    private let service: ContactsGetListService
    typealias CellViewModel = ContactCell.ViewModel
    
    init(service: ContactsGetListService = ContactsService()) {
        self.service = service
    }
    
    func fetchContacts(withSuccess onSuccess: @escaping () -> Void, andError onFailure: @escaping (_ error: Error?) -> Void) {
        service.getContacts(onSuccess: { (contacts) in
            if let contacts = contacts {
                self.prepareContactsData(contacts: contacts)
            }
            onSuccess()
        }) { (error) in
            onFailure(error)
        }
    }
    private func prepareContactsData(contacts : [Contact]) {
        let sortedContacts = contacts.sorted(by: { $0.displayName < $1.displayName })
        self.contactListSections = []
        let sectionTitles = UILocalizedIndexedCollation.current().sectionTitles
        var calicutaingSections: [ContactListSection] = []
        for title in sectionTitles {
            let contacts : [Contact]? = sortedContacts.filter({ $0.displayName.capitalized.hasPrefix(title)})
            if let sectionContacts = contacts {
                let section = ContactListSection.init(sectionTitle: title, contacts: sectionContacts)
                calicutaingSections.append(section)
            }
        }
        self.contactListSections = calicutaingSections
    }
    func getContactListSection() -> [ContactListSection] {
        return contactListSections
    }
    
    func getCellViewModel(atIndex index:Int, inSection sectionIndex: Int) -> ListCellViewModel? {
        let contacts = contactListSections[sectionIndex].contacts
        let contact = contacts[index]
        let viewModel: CellViewModel = CellViewModel(contact: contact)
        return viewModel
    }
}
