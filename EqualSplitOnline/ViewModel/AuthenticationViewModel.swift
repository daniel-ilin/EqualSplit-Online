//
//  AuthenticationViewModel.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 30.12.2021.
//

import Foundation
import UIKit

protocol AuthenticationViewModel {
    var formIsValid: Bool {get}
    var buttonBackgroundColor: UIColor {get}
    var buttonTitleColor: UIColor {get}
}

protocol FormViewModel {
    func updateForm()
}

struct LoginViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? .systemBlue : .systemBlue.withAlphaComponent(0.4)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .systemBlue : .systemBlue.withAlphaComponent(0.4)
    }
}


struct RegistrationViewModel: AuthenticationViewModel {
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
            && fullname?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? .systemBlue : .systemBlue.withAlphaComponent(0.4)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : .white.withAlphaComponent(0.67)
    }
    
    var email: String?
    var password: String?
    var fullname: String?
}
