//
//  AuthService.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 30.12.2021.
//

import Alamofire
import JGProgressHUD

typealias LoginCompletion = (DataResponse<ActiveUser, AFError>)->Void

struct AuthCredentials {
    let email: String
    let name: String
    let password: String
}

struct AuthService {
    
    static var activeUser: ActiveUser?
    
    static func registerUser(withCredentials credentials: AuthCredentials, completion: @escaping (AFDataResponse<Data?>)->Void) {
        
        
        let request: [String: String] = [
            "email": credentials.email,
            "name": credentials.name,
            "password": credentials.password
        ]
        
        let callurl = "\(API_URL)/register"
        
        AF.request(callurl, method: .post, parameters: request, encoder: JSONParameterEncoder.default).response { response in
            if response.response?.statusCode == 200 {
                completion(response)
            } else {
                return
            }
        }
    }
    
    static func loginUser(withEmail email: String, password: String, completion: @escaping LoginCompletion) {
        let request: [String: String] = [
            "email": email,
            "password": password
        ]
        
        let callurl = "\(API_URL)/login"
        AF.request(callurl, method: .post, parameters: request).validate().responseDecodable(of: ActiveUser.self) { response in
            guard response.value != nil else {return}
            if response.response?.statusCode == 200 {
                do {
                    activeUser = try response.result.get()
                } catch {
                    print("DEBUG - Could not login")
                }                
                completion(response)
            } else {
                print("DEBUG - Could not login: \(String(describing: response.error?.localizedDescription))")
            }
        }
    }
    
    static func logout(completion: @escaping (AFDataResponse<Data?>)->Void) {
        let callurl = "\(API_URL)/logout"
        let request: [String: String] = [:]
                
        AF.request(callurl, method: .delete, parameters: request, encoder: JSONParameterEncoder.default).response { response in
               if response.response?.statusCode == 200 {
                   completion(response)
               } else {
                   print("DEBUG - status: \(String(describing: response.error?.localizedDescription))")
               }
        }
                
    }
    
    static func checkIfUserLoggedIn() -> Bool {
        print("DEBUG: Check if user is logged in")
        return false
    }
    
}
