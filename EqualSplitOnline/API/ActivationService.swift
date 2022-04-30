//
//  ActivationService.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 4/23/22.
//

import Foundation
import Alamofire

struct ActivationService {
    
    static func requestActivationCode(forEmail email: String, completion: @escaping ()->Void) {
        
        let params: [String: String] = [
            "email": email
        ]
        
        print("DEBUG: Email for requesting activation \(email)")
        
        let callurl = API_URL + "/mail/code"
        
        AF.request(callurl, method: .post, parameters: params, encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300).response { response in
            switch response.result {
            case .success:
                completion()
            case .failure:
                print("Error")
            }
        }
    }
    
    static func activateUser(withCode code: String, withEmail email: String, completion: @escaping ()->Void) {
        
        let params: [String: String] = [
            "email": email,
            "code": code
        ]
        
        let callurl = API_URL + "/activateuser"
        print(callurl)
        
        AF.request(callurl, method: .put, parameters: params, encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300).response { response in
            switch response.result {
            case .success:
                completion()
            case .failure:
                print("Error")
            }
        }
    }
    
    static func sendResetPasswordLink(to email: String, completion: @escaping ()->Void, errorHandler: @escaping ()->Void) {
        
        let params: [String: String] = [
            "email": email,            
        ]
        
        let callurl = API_URL + "/mail/resetpassword"
        print(callurl)
        
        AF.request(callurl, method: .post, parameters: params, encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300).response { response in
            switch response.result {
            case .success:
                completion()
            case .failure:
                errorHandler()
            }
        }
    }
    
}
