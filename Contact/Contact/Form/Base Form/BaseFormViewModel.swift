//
//  BaseFormViewModel.swift
//  Contacts
//
//  Created by Vignesh Radhakrishnan on 06/02/20.
//

import Foundation

class BaseFormViewModel {
    
    private(set) var contact: Contact
    private(set) var formFields : [FormField]
    
    init(contact : Contact) {
        self.formFields = contact.contactFields
        self.contact = contact
    }
    
     func valiate() -> Error? {
        var errors = [Error]()
        for formField in self.formFields {
            let mandatoryValidation = MandatoryValidation()
            let mandatoryValidationResult = mandatoryValidation.validate(value:  formField.getFieldValue())
            switch formField.getField() {
            case .phone :
                if !mandatoryValidationResult {
                    let error: Error = RegistrationError.EmptyPhoneNumber
                    return error
                }
                
                let phoneNumberValidation = PhoneNumberValidation()
                if !phoneNumberValidation.validate(value: formField.getFieldValue()) {
                    let error: Error = RegistrationError.invalidPhoneNumber
                    errors.append(error)
                }
            case .email:
                if !mandatoryValidationResult {
                    let error: Error = RegistrationError.EmptyEmail
                    errors.append(error)
                }
                let emailValidation = EmailValidation()
                if !emailValidation.validate(value: formField.getFieldValue()) {
                    let error: Error = RegistrationError.invalidEmail
                    errors.append(error)
                }
                
            default :
                break
            }
        }
        if errors.isEmpty {
            return nil
        } else {
            return errors[0]
        }
    }
}
