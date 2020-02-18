//
//  Contact.swift
//  Contacts
//
//  Created by Vignesh Radhakrishnan on 06/02/20.
 
//


import Foundation

struct Contact: Codable {
    let id: Int
    let firstName: String
    let lastName: String?
    let profilePicture: String?
    var favourite: Bool
    var email: String?
    var phoneNumber: String?
    var url: String?
    
        init() {
            self.id = 0
            self.firstName = ""
            self.lastName = ""
            self.profilePicture = ""
            self.phoneNumber = ""
            self.email = ""
            self.url = ""
            self.favourite = false
        }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case profilePicture = "profile_pic"
        case favourite = "favorite"
        case email = "email"
        case phoneNumber = "phone_number"
        case url = "url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        profilePicture = try container.decode(String.self, forKey: .profilePicture)
        favourite = try container.decode(Bool.self, forKey: .favourite)
        
        do {
            email = try container.decode(String.self, forKey: .email)
        }catch {
            email = ""
        }
        
        do {
            phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        }catch {
            phoneNumber = ""
        }
        do {
            url = try container.decode(String.self, forKey: .url)
        }catch {
            url = ""
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(profilePicture, forKey: .profilePicture)
        try container.encode(favourite, forKey: .favourite)
        try container.encode(email, forKey: .email)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(url, forKey: .url)
    }
}

extension Contact {
    var contactFields: [FormField] {
        return  [FormField(withFieldName : NSLocalizedString("first_name", comment: ""),value : firstName, field: .firstName, placeHolder: "Enter first name"),
                 FormField(withFieldName :NSLocalizedString("last_name", comment: ""),value : lastName ?? "", field: .lastName, placeHolder: "Enter last name"),
                 FormField(withFieldName :NSLocalizedString("mobile", comment: ""),value : phoneNumber ?? "", field: .phone, placeHolder: "Enter phone number"),
                 FormField(withFieldName :NSLocalizedString("email", comment: ""),value : email ?? "", field: .email, placeHolder: "Enter email")]
    }
    
    static func formFieldJsonRepresentation(formfields : [FormField]) -> [String: Any] {
        var dict = [String:Any]()
        for formField in formfields {
            switch formField.getField() {
            case .firstName:
                dict["first_name"] = formField.getFieldValue()
            case .lastName:
                dict["last_name"] = formField.getFieldValue()
            case .email:
                 dict["email"] = formField.getFieldValue()
            case .phone:
                 dict["phone_number"] = formField.getFieldValue()
            }
        }
        return dict
    }
}

extension Contact {
    var displayName: String {
        return [firstName, lastName ?? ""].filter{!$0.isEmpty}.joined(separator: " ").capitalized
    }
}

extension Contact: Equatable {
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.id == rhs.id
    }
}
