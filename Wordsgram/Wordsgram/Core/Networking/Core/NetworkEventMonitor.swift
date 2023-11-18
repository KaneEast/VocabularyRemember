//
//  NetworkEventMonitor.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/18.
//

import Alamofire

import Foundation
class MyLogger: EventMonitor {
  let queue = DispatchQueue(label: "com.myapp.networklogger")
  
  func requestDidFinish(_ request: Request) {
    print("Request finished: \(request)")
  }
  
  func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
    print("Response received:")
    printPrettyJson(response.data)
  }
  
  func printPrettyJson(_ jsonData: Data?) {
    guard let jsonData else {
      print("Error: Cannot convert string to Data")
      return
    }
    
    do {
      let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
      let prettyJsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
      if let prettyPrintedString = String(data: prettyJsonData, encoding: .utf8) {
        print(prettyPrintedString)
      }
    } catch {
      print("Error: \(error.localizedDescription)")
    }
  }
  
}

