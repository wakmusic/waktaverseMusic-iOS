//
//  TopHundredViewModel.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/15.
//

import Foundation
import RxSwift
import RxCocoa

//protocol TopHundredViewModelType{
//    var allItems: Observable<[Top100]> { get }
//}

class TopHundredViewModel{
    let disposeBag = DisposeBag()
    
    let topObservable = BehaviorSubject<[Top100]>(value: [])
    //let allItems: Observable<[Top100]>
    
    
    init()
    {
        _ = Repository.shared.fetchRx(url: ApiCollections.totalTop100)
            .map { data -> [Top100] in
                let response:[Top100] = try! JSONDecoder().decode([Top100].self, from: data)
                return response
            }
            .take(1)
            .bind(to:topObservable)
             
        
        
        
            
        
     print(topObservable)
    }
   
}
