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
    
    struct Input {
        var searchObservable: Observable<String?>
    }
    
    struct Output {
        var sections: Observable<[Section]>
    }
    
    init(apodService: ApodServiceProtocol) {
        self.apodService = apodService
    }
    
    func transform(with input: Input) -> Output {
        //Just for testing purpose
        let startOfMonth = Date().startOfMonth()
        let formattedStartOfTheMonth = startOfMonth?.formattedDate ?? ""
        
        let sections = Observable.combineLatest(self.apodService.getApod(start: formattedStartOfTheMonth, end: Date.formattedToday), input.searchObservable)
            .flatMapLatest { (result, searchText) -> Observable<[Section]> in
                switch result {
                case .success(let value):
                    
                    guard let searchText = searchText, !searchText.isEmpty else {
                        return .just([Section(model: "", items: value)])
                    }
                    
                    let parts = searchText.components(separatedBy: " ").filter { !$0.isEmpty }
                    
                    let result = value.filter { currentApod in
                        let matches = parts.filter { part in
                            let part = part.lowercased()
                            let result = currentApod.title?.lowercased().contains(part) ?? false
                                || currentApod.date?.contains(part) ?? false
                            
                            return result
                        }
                        
                        return matches.count == parts.count
                    }
                    
                    return .just([Section(model: "", items: result)])
                case .failure(_):
                    return .just([])
                }
            }
        
        return Output(sections: sections)
    }
}
