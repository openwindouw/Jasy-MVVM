//
//  ApodModel.swift
//  Jasy
//
//  Created by Vladimir Espinola on 9/15/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import Foundation
import RxDataSources

class ApodModel: Codable {
    var copyright: String?
    var date: String
    var explanation: String
    var hdurl: String?
    var mediaType: String?
    var serviceVersion: String?
    var title: String
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case explanation = "explanation"
        case hdurl = "hdurl"
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title = "title"
        case url = "url"
    }
}

extension ApodModel: IdentifiableType {
    var identity: String {
        return date
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
    
    var lowImageName: String { return date }
    var highImageName: String { return "hd-\(date)" }
    
    var prettyDate: String {
        return Utilities.convert(currentDate: date, in: DateFormats.default, to: DateFormats.pretty)
    }
}
