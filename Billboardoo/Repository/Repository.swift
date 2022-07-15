//
//  Repository.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/15.
//

import Foundation
import RxSwift
class Repository{
    static let shared:Repository = Repository()
    
    //private let semaphore = DispatchSemaphore(value: 1)
    
    private func fetch(url: String, onComplete: @escaping (Result<Data,Error>) -> Void )
    {
        URLSession.shared.dataTask(with: URL(string: url)!) { data, res, err in
            
            if let err = err {
                onComplete(.failure(err))
                return
            }
            
            guard let data = data else {
                let httpResponse = res as! HTTPURLResponse
                onComplete(.failure(NSError(domain: "no data", code: httpResponse.statusCode,userInfo: nil)))
                return
            }
            
            onComplete(.success(data))
        }.resume()
    }
    
    public func fetchRx(url: String) -> Observable<Data>
    { 
        return Observable.create { emitter in
            
            self.fetch(url: url) { result in
                switch result{
                
                case let .success(data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                
                case let .failure(err):
                    emitter.onError(err)
                }
            }
            
            return Disposables.create()
        }
        
    }
}
