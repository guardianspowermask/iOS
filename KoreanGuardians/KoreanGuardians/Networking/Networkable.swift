//
//  Networkable.swift
//  KoreanGuardians
//
//  Created by SAY on 26/07/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import Moya
import SwiftyJSON

protocol Networkable {
    var provider: MoyaProvider<GuardiansAPI> { get }
    func getCategory(completion: @escaping (NetworkResult<[Category]>) -> Void)
    func getItem(categoryIdx: Int, order: Int, completion: @escaping (NetworkResult<ItemData>) -> Void)
    func putReport(itemIdx: Int, completion: @escaping (NetworkResult<DefaultVO>) -> Void)
}

extension Networkable {
    func fetchData<T: Codable>(api: GuardiansAPI, networkData: T.Type, completion: @escaping (NetworkResult<(resCode: Int, resResult: T)>) -> Void) {
        provider.request(api) { (result) in
            switch result {
            case let .success(res) :
                do {
                    print(JSON(res.data))
                    let resCode = res.statusCode
                    let data = try JSONDecoder().decode(T.self, from: res.data)
                    completion(.success((resCode, data)))
                } catch let err {
                    print("Decoding Err " + err.localizedDescription)
                }
            case let .failure(err) :
                if let error = err as NSError?, error.code == -1009 {
                    completion(.failure(.networkConnectFail))
                } else {
                    completion(NetworkResult.failure(.networkError(msg: err.localizedDescription)))
                }
            }
        }
    }
}
