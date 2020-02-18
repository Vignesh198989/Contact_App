//
//  Validation.swift
//  Contacts
//
//  Created by Vignesh Radhakrishnan on 06/02/20.
//

protocol Validation {
    func validate(value: String) -> Bool
}

struct MandatoryValidation: Validation {
    func validate(value: String) -> Bool {
        return !value.isEmpty
    }
}
struct PhoneNumberValidation: Validation {
    func validate(value: String) -> Bool {
        let regex = "^[0-9]{6,14}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: value)
    }
}

struct EmailValidation: Validation {
    func validate(value: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: value)
    }
}

enum RegistrationError: Error {
    case invalidEmail
    case invalidPhoneNumber
    case EmptyEmail
    case EmptyPhoneNumber
    case otherError
}

extension RegistrationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return NSLocalizedString("Invalid email address", comment: "Invalid Email")
        case .invalidPhoneNumber:
            return NSLocalizedString("Invalid phoneNumber", comment: "Invalid Phone Number")
        case .EmptyPhoneNumber:
            return NSLocalizedString("Mobile no is required", comment: "Mobile no is required")
        case .otherError:
             return NSLocalizedString("Something is missing in the form", comment: "Something is missing in the form")
        case .EmptyEmail:
              return NSLocalizedString("Email is required", comment: "Email is required")
        }
    }
}
