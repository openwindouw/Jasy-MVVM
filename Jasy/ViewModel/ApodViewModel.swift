//
//  ApodViewModel.swift
//  Jasy
//
//  Created by Vladimir Espinola on 10/02/2019.
//  Copyright © 2019 Vladimir Espinola. All rights reserved.
//

import Foundation
import RxSwift

struct ApodViewModel {
    private var apodModel: ApodModel
    
    struct Output {
        var apodImage: Observable<UIImage>
    }
    
    init(apod: ApodModel) {
        self.apodModel = apod
    }
}
