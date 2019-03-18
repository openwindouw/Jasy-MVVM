//
//  ApodModel.swift
//  Jasy
//
//  Created by Vladimir Espinola on 9/15/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import Foundation
import RxDataSources
import RealmSwift

class ApodModel: Object, Codable {
    @objc dynamic var copyright: String?
    @objc dynamic var date: String
    @objc dynamic var explanation: String
    @objc dynamic var hdurl: String?
    @objc dynamic var mediaType: String?
    @objc dynamic var serviceVersion: String?
    @objc dynamic var title: String
    @objc dynamic var url: String?
}

extension ApodModel: IdentifiableType {
    var identity: String {
        return date
    }
}

//extension ApodModel: Equatable {
//    static func == (lhs: ApodModel, rhs: ApodModel) -> Bool {
//        return lhs.date == rhs.date
//    }
//}

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
}
