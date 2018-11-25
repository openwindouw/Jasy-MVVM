//
//  ListViewModel.swift
//  Jasy
//
//  Created by User on 11/24/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

typealias Section = AnimatableSectionModel<String, ApodModel>

struct ListViewModel {
    private var apodService: ApodServiceProtocol
    
    struct Output {
        var sections: Observable<[Section]>
    }
    
    init(apodService: ApodServiceProtocol) {
        self.apodService = apodService
    }
    
    func transform() -> Output {
        
        let sections = self.apodService.getApod(start: "", end: "")
            .flatMapLatest { result -> Observable<[Section]> in
                switch result {
                case .success(let value):
                    return .just([Section(model: "", items: value)])
                case .failure(_):
                    return .just([])
                }
            }
        
        return Output(sections: sections)
    }
}
