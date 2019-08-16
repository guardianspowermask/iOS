//
//  NetworkManager.swift
//  KoreanGuardians
//
//  Created by SAY on 26/07/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import Foundation
import Moya

struct NetworkManager: Networkable {
    static let sharedInstance = NetworkManager()
    let provider = MoyaProvider<GuardiansAPI>()
}

extension NetworkManager {
   func getCategory(completion: @escaping (NetworkResult<[Category]>) -> Void) {
        fetchData(api: .getCategory, networkData: CategoryVO.self) { (result) in
            switch result {
            case .success(let successResult):
                guard let data = successResult.resResult.data else {
                    return
                }
                completion(.success(data))
            case .failure(let errorType):
                switch errorType {
                case .networkConnectFail:
                    completion(.failure(.networkConnectFail))
                case .networkError(let msg):
                    completion(.failure(.networkError(msg: msg)))
                }
            }
        }
    }
    func getItem(categoryIdx: Int, order: Int, completion: @escaping (NetworkResult<ItemData>) -> Void) {
        fetchData(api: .getItem(categoryIdx: categoryIdx, order: order), networkData: ItemVO.self) { (result) in
            switch result {
            case .success(let successResult):
                guard let data = successResult.resResult.data else {
                    return
                }
                completion(.success(data))
            case .failure(let errorType):
                switch errorType {
                case .networkConnectFail:
                    completion(.failure(.networkConnectFail))
                case .networkError(let msg):
                    completion(.failure(.networkError(msg: msg)))
                }
            }
        }
    }
    func putReport(itemIdx: Int, completion: @escaping (NetworkResult<DefaultVO>) -> Void) {
        fetchData(api: .putReport(itemIdx: itemIdx), networkData: DefaultVO.self) { (result) in
            switch result {
            case .success(let successResult):
                completion(.success(successResult.resResult))
            case .failure(let errorType):
                switch errorType {
                case .networkConnectFail:
                    completion(.failure(.networkConnectFail))
                case .networkError(let msg):
                    completion(.failure(.networkError(msg: msg)))
                }
            }
        }
    }
}
