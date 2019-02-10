//
//  ApodModel.swift
//  Jasy
//
//  Created by Vladimir Espinola on 9/15/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import Foundation
import RxDataSources

struct ApodModel: Codable {
    let copyright: String?
    let date: String?
    let explanation: String?
    let hdurl: String?
    let mediaType: String?
    let serviceVersion: String?
    let title: String?
    let url: String?
}

extension ApodModel: IdentifiableType {
    var identity: String {
        return date!
    }
}

extension ApodModel: Equatable {
    static func == (lhs: ApodModel, rhs: ApodModel) -> Bool {
        return lhs.date == rhs.date
    }
}

extension ApodModel {
    var highURL: URL? {
        guard let hdurl = hdurl else { return nil }
        return URL(string: hdurl)
    }
    
    var lowURL: URL? {
        guard let lowUrl = url else { return nil }
        return URL(string: lowUrl)
    }
}
