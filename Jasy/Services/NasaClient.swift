//
//  NasaClient.swift
//  Jasy
//
//  Created by Vladimir Espinola on 9/14/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import AlamofireLogging

typealias DataResponse = Alamofire.DataResponse
typealias JSONObject = [String: Any]
typealias JDictionary = [String : AnyObject]

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum Encoding {
    case `default`
    case json
    case query
    
    var alamofire: ParameterEncoding {
        switch self {
        case .default:
            return URLEncoding.default
        case .json:
            return JSONEncoding.default
        case .query:
            return URLEncoding.queryString
        }
    }
}

class NASAClient {
    
    static func request<T: Codable>(verb: HTTPMethod = .get, url: String, parameters: [String: AnyObject] = [:], headers: [String: String] = [:], encoding: Encoding = .default) -> Observable<Result<T>> {
        return Observable.create { observable in
            
            let request = SUDSessionManager.shared.request(url,
                                                           method: verb,
                                                           parameters: parameters,
                                                           encoding: encoding.alamofire,
                                                           headers: headers)
            
            request.log().responseData(completionHandler: { response in
                
                
                guard response.error == nil, let data = response.data else {
                    
                    observable.onNext(.failure(response.error!))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    observable.onNext(.success(result))
                } catch let realError {
                    print(realError.localizedDescription)
                    observable.onNext(.failure(realError))
                }
                
                
                observable.onCompleted()
            })
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

class SUDSessionManager: SessionManager {
    static let shared: SUDSessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let manager = SUDSessionManager(configuration: configuration)
        return manager
    }()
}
