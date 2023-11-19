//
//  NetworkSessionManager.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/17.
//

import Foundation
import Alamofire

import Foundation
import Alamofire

class NetworkSessionManager {
  static let shared = NetworkSessionManager()
  private var session: Alamofire.Session
  private var defaultHeaders: HTTPHeaders
  
  init() {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 5 // seconds
    configuration.timeoutIntervalForResource = 30 // seconds
    defaultHeaders = [
      "Content-Type": "application/json",
      "Accept": "application/json"
    ]
    configuration.headers = defaultHeaders
    
    // Setup SSL Pinning
    //        let serverTrustManager = ServerTrustManager(evaluators: [
    //            "yourserver.com": PinnedCertificatesTrustEvaluator(certificates: [
    //                Certificates.serverCertificate
    //            ], acceptSelfSignedCertificates: false, performDefaultValidation: true, validateHost: true)
    //        ])
    
    // TODO: manage sertificate
    //        session = Alamofire.Session(configuration: configuration, serverTrustManager: serverTrustManager)
    session = Alamofire.Session(configuration: configuration, eventMonitors: [MyLogger()])
  }
  
  func combinedHeaders(additionalHeaders: HTTPHeaders?) -> HTTPHeaders {
    var combinedHeaders = defaultHeaders
    additionalHeaders?.forEach { combinedHeaders.add($0) }
    return combinedHeaders
  }
  
  var alamofireSession: Alamofire.Session {
    return session
  }
}

enum Certificates {
  static let serverCertificate: SecCertificate = {
    guard let pathToCert = Bundle.main.path(forResource: "yourServerCertificate", ofType: "cer"),
          let localCertificateData = try? Data(contentsOf: URL(fileURLWithPath: pathToCert)) as CFData,
          let certificate = SecCertificateCreateWithData(nil, localCertificateData) else {
      fatalError("Couldn't load the certificate")
    }
    return certificate
  }()
}


