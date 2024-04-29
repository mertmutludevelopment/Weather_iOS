//
//  NetworkManager.swift
//  Weather
//
//  Created by MERT MUTLU on 29.04.2024.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager{
    
    static let instance = NetworkManager()
    
    let headers : HTTPHeaders = [
            "Accept": "*/*",
            "User-Agent": "Mozilla/5.0 (compatible; Rigor/1.0.0; http://rigor.com)"
        ]

        public func fetch<T:Codable> (_ method: HTTPMethod, url: String, requestModel: T?, model: T.Type, completion: @escaping (AFResult<Codable>) -> Void)
        {
            AF.request(
                url,
                method: method,
                parameters: NetworkManager.toParameters(model: requestModel),
                encoding: JSONEncoding.default,
                headers: headers
            )
            .validate()
            .responseJSON { response in

                switch response.result {
                    case .success(let value as [String: AnyObject]):
                        do{
                            let responseJsonData = JSON(value)
                            let responseModel = try JSONDecoder().decode(model.self, from: responseJsonData.rawData())
                            completion(.success(responseModel))
                        }
                        catch let parsingError{
                            print("Success (error): \(parsingError)")
                        }

                    case .failure(let error):
                            print("Failure: \(error)")
                            completion(.failure(error))

                        default: fatalError("Fatal error.")
                        
                    }
            }
        }

    static func toParameters<T:Encodable>(model: T?) -> [String:AnyObject]?
        {
            if(model == nil)
            {
                return nil
            }
            
            let jsonData = modelToJson(model:model)
            let parameters = jsonToParameters(from: jsonData!)
            return parameters! as [String: AnyObject]
        }

        static func modelToJson<T:Encodable>(model:T)  -> Data?
        {
            return try! JSONEncoder().encode(model.self)
        }

        static func jsonToParameters(from data: Data) -> [String: Any]?
        {
            return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        }
}
