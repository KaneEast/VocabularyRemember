//
//  WGProviderFactory.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/09.
//

import Alamofire
import Foundation
import Moya

final class CustomLoggingPlugin: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
//        print("Sending request with Method: \(request.request?.method?.rawValue ?? "")")
        print("Sending request with URL   : \(request.request?.url?.absoluteString ?? "")", "with Method: \(request.request?.method?.rawValue ?? "")")
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            print("Received response with status code: \(response.statusCode)")
        case .failure(let error):
            print("Request failed with error: \(error)")
        }
    }
}

struct WGProviderFactory {
    static let shared = Self.makeProvider()
    //static let policies: [String: ServerTrustPolicy] = [:]
    static func makeProvider() -> MoyaProvider<WGService> {
        // serverTrustPolicyManager
        return MoyaProvider<WGService>(plugins: [CustomLoggingPlugin()])
    }
}

