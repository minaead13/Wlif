//
//  SignupViewModel.swift
//  Wlif
//
//  Created by OSX on 02/07/2025.
//

import Foundation

class SignupViewModel {
    
    let validator: LoginValidatorProtocol
    
    init(validator: LoginValidatorProtocol) {
        self.validator = validator
    }
    
    func register(fullName: String, email: String, completion:  @escaping (Result<UserModel, Error>) -> Void){
        guard validator.isFullNameValid(fullName) && validator.isEmailValid(email)  else {
            completion(.failure(ErrorHelper.makeError("Not valid data")))
            return
        }
        
        let parameters = [
            "name": fullName,
            "email": email
        ] as [String: Any]
        
        NetworkManager.instance.request(Urls.register, parameters: parameters, method: .post, type: UserModel.self) { [weak self] (baseModel, message) in
            if let data = baseModel?.data {
                completion(.success(data))
            } else {
                completion(.failure(ErrorHelper.makeError(message ?? "Unknown error")))
            }
        }
    }
}
