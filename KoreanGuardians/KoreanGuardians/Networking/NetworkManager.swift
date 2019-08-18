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
    func login(kakaoId: String, userName: String, completion: @escaping (NetworkResult<String>) -> Void) {
        fetchData(api: .login(kakaoId: kakaoId, userName: userName), networkData: LoginVO.self) { (result) in
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
    func getComment(itemIdx: Int, completion: @escaping (NetworkResult<[Comment]>) -> Void) {
        fetchData(api: .getComment(itemIdx: itemIdx), networkData: CommentVO.self) { (result) in
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
    func writeComment(itemIdx: Int, content: String, completion: @escaping (NetworkResult<String>) -> Void) {
        fetchData(api: .writeComment(itemIdx: itemIdx, content: content), networkData: DefaultVO.self) { (result) in
            switch result {
            case .success(let successResult):
                guard let data = successResult.resResult.message else {
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
    func getFeedback(itemIdx: Int, completion: @escaping (NetworkResult<Feedback>) -> Void) {
        fetchData(api: .getFeedback(itemIdx: itemIdx), networkData: FeedbackVO.self) { (result) in
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
    func reportComment(commentIdx: Int, completion: @escaping (NetworkResult<String>) -> Void) {
        fetchData(api: .reportComment(commentIdx: commentIdx), networkData: DefaultVO.self) { (result) in
            switch result {
            case .success(let successResult):
                guard let data = successResult.resResult.message else {
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
}
