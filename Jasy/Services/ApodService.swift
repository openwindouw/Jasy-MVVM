//
//  ApodService.swift
//  Jasy
//
//  Created by Vladimir Espinola on 9/15/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import Foundation
import RxSwift

protocol ApodServiceProtocol {
    func getApod(start: String, end: String) -> Observable<Result<[ApodModel]>>
}

struct ApodService: ApodServiceProtocol {
    func getApod(start: String, end: String) -> Observable<Result<[ApodModel]>> {
        
        let parameters: JDictionary = [
            "start_date" : start,
            "end_date" : end,
            "api_key" : ClientConstants.apiKey
        ] as [String: AnyObject]
        
        let endpoint = ClientConstants.base + "/planetary/apod"
        
        return NASAClient.request(verb: .get, url: endpoint, parameters: parameters, encoding: .query)
            .retry(3)
    }
}
