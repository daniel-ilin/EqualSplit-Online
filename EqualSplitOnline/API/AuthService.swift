//
//  AuthService.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 30.12.2021.
//

import Alamofire
import JGProgressHUD

typealias Completion = (DataResponse<Token, AFError>) -> ()
typealias ErrorHandler = (String)->Void

struct AuthCredentials {
    let email: String
    let name: String
    let password: String
}

enum UserListAPIResponse {
    case Success(Tokens)
    case Fail(APIError) /// Error code, Error message
}

struct AuthService {
    
    static var activeUser: ActiveUser?
    
    static func registerUser(withCredentials credentials: AuthCredentials,
                             completion: @escaping ((AFDataResponse<Data?>) -> Void),
                             activateUserHandler: @escaping ()->Void,
                             errorHandler: @escaping ()->Void) {
        
        
        let params: [String: String] = [
            "email": credentials.email,
            "name": credentials.name,
            "password": credentials.password
        ]
        
        let callurl = API_URL + "/register"
        
        AF.request(callurl, method: .post, parameters: params).validate().response { response in
            
            switch response.result {
            case .success:
                completion(response)
            case .failure:
                if response.response?.statusCode == 403 {
                    activateUserHandler()
                } else {
                    errorHandler()
                }
            }
        }
    }
    
    
    
    
    static func loginUser(withEmail email: String, password: String,
                          completion: @escaping ()->Void,
                          errorHandler: @escaping ()->Void,
                          activateUserHandler: @escaping ()->Void) {
        
        let params: [String: String] = [
            "email": email,
            "password": password
        ]
        
        let callurl = API_URL + "/login"
        AF.request(callurl, method: .post, parameters: params).validate().responseDecodable(of: Tokens.self) { response in
            
            switch response.result {
            case .success:
                do {
                    let tokens = try response.result.get()
                    guard let accessToken = tokens.accessToken, let refreshToken = tokens.refreshToken else { return }
                    KeychainService.setAccessTokenTo(accessToken)
                    KeychainService.setRefreshTokenTo(refreshToken)
                    completion()
                } catch let error {
                    print(error)
                }
            case .failure (let error):
                if response.response?.statusCode == 403 {
                    activateUserHandler()
                } else {
                    errorHandler()
                }
            }
        }
    }
    
    
    
    
    static func logout(completion: @escaping (AFDataResponse<Data?>)->Void) {
        let callurl = API_URL + "/logout"
        guard let refreshToken = KeychainService.getRefreshToken() else { return }
        let params = [String: String]()
        
        let headers: HTTPHeaders = [
            "x-auth-token": refreshToken
        ]
        
        AF.request(callurl, method: .delete, parameters: params, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            KeychainService.removeRefreshToken()
            KeychainService.removeAccessToken()
            activeUser = nil
            
            switch response.result {
            case .success:
                completion(response)
            case .failure (let error):
                print(error)
            }
        }
    }
    
    
    
    static func requestAccessToken(completion: @escaping()->Void,
                                   errorHandler: @escaping (AFError)->Void) {
        let callurl = API_URL + "/login/token"
        guard let refreshToken = KeychainService.getRefreshToken() else { return }        
        
        let headers: HTTPHeaders = [
            "x-auth-token": refreshToken
        ]
        
        AF.request(callurl, method: .get, headers: headers).validate().responseDecodable(of: Tokens.self) { response in
            
            switch response.result {
            case .success:
                do {
                    let tokens = try response.result.get()
                    guard let accessToken = tokens.accessToken else { return }
                    KeychainService.setAccessTokenTo(accessToken)
                    completion()
                } catch let error {
                    print(error)
                }
            case .failure:
                logout { response in
                    print("Successful logout")
                }
            }
        }
    }
    
    static func checkIfUserLoggedIn() -> Bool {
        if KeychainService.getRefreshToken() != nil {
            return true
        }
        return false
    }
    
}
