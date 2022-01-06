//
//  SessionService.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 01.01.2022.
//

import Alamofire

struct UserService {
    
    static func fetchUserData(completion: @escaping AuthCompletion) {
        
        let callurl = "\(API_URL)/userdata"
                
        AF.request(callurl, method: .get).validate().responseDecodable(of: Sessions.self) { response in            
            guard response.value != nil else {return}
            if response.response?.statusCode == 200 {
                completion(response)
            } else {
                print("DEBUG - Could not fetch userdata: \(String(describing: response.error?.localizedDescription))")
            }
        }
    }
    
}
