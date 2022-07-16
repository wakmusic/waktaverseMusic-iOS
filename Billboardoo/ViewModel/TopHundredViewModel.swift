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
    
    let total100Observable = BehaviorSubject<[SimpleViwer]>(value: []) //BehaviorSubject 사용
    let time100Observable = BehaviorSubject<[SimpleViwer]>(value: [])
    let weekly100Observable = BehaviorSubject<[SimpleViwer]>(value: [])
    let montly100Observable = BehaviorSubject<[SimpleViwer]>(value: [])
    let daily100Observable = BehaviorSubject<[SimpleViwer]>(value: [])
    
    private func jsonDecode(category:Topcategory) -> Observable<[SimpleViwer]>
    {
        var url:String
        
        switch category {
        case .total100:
            url = ApiCollections.totalTop100
        case .time100:
            url = ApiCollections.timeTop100
        case .weekly100:
            url = ApiCollections.weaklyTop100
        case .monthly100:
            url = ApiCollections.monthlyTop100
        
        case .daily100:
            url = ApiCollections.dailyTop100
        }
        
        url = url.replacingOccurrences(of: "100", with: "20") //Main Page는 20개만 보이면 되므로 /100 - > /20으로
        
        print(url)
        let result = Repository.shared.fetchRx(url: url)
            .map { data -> [SimpleViwer] in
                let response:[SimpleViwer] = try! JSONDecoder().decode([SimpleViwer].self, from: data)
                print(response)
                return response
                
                //jsonDecoder 후
            }
        
        return result
        
    }
    
    
    init()
    {
        jsonDecode(category: .total100)
            .take(1)
            .bind(to:total100Observable) //bind
        
        jsonDecode(category: .monthly100)
            .take(1)
            .bind(to: montly100Observable)

        jsonDecode(category: .time100)
            .take(1)
            .bind(to:time100Observable)

        jsonDecode(category: .weekly100)
            .take(1)
            .bind(to: weekly100Observable)

        jsonDecode(category: .daily100)
            .take(1)
            .bind(to: daily100Observable)
        
        
    }
    
}

enum Topcategory{
    
    case total100
    case time100
    case weekly100
    case monthly100
    case daily100
    
}
