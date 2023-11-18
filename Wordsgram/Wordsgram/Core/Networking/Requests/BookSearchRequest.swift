//
//  BookSearchRequest.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/18.
//

import Alamofire
import Foundation

struct BookSearchRequest: APIRequest {
  typealias Response = BookSearchResponse
  
  var environment: NetworkEnvironment { .googlebook }
  var path: String { "/volumes" }
  var method: HTTPMethod { .get }
  var parameters: Encodable?
  var headers: HTTPHeaders?
  var encoding: ParameterEncoding { URLEncoding.default }
  
  init(title: String, author: String) {
    self.parameters = [
      "q": "\(title)+inauthor:\(author)",
      "key": "AIzaSyD6HIRAMsM7jI3p4rVYQ03DjXLlYlNzJGs",
    ]
  }
}

struct BookSearchResponse: Codable {
    let kind: String
    let totalItems: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let selfLink: String
    let volumeInfo: VolumeInfo?
    let id: String
    let saleInfo: SaleInfo?
    let accessInfo: AccessInfo?
    let searchInfo: SearchInfo?
    let kind: Kind
    let etag: String
}

// MARK: - AccessInfo
struct AccessInfo: Codable {
    let viewability: Viewability?
    let publicDomain: Bool
    let country: Country?
    let accessViewStatus: AccessViewStatus?
    let webReaderLink: String
    let quoteSharingAllowed: Bool
    let textToSpeechPermission: TextToSpeechPermission?
    let pdf: Epub?
    let embeddable: Bool
    let epub: Epub?
}

enum AccessViewStatus: String, Codable {
    case none = "NONE"
    case sample = "SAMPLE"
}

enum Country: String, Codable {
    case jp = "JP"
}

// MARK: - Epub
struct Epub: Codable {
    let isAvailable: Bool
    let acsTokenLink: String?
}

enum TextToSpeechPermission: String, Codable {
    case allowed = "ALLOWED"
}

enum Viewability: String, Codable {
    case noPages = "NO_PAGES"
    case partial = "PARTIAL"
}

enum Kind: String, Codable {
    case booksVolume = "books#volume"
}

// MARK: - SaleInfo
struct SaleInfo: Codable {
    let country: Country?
    let saleability: Saleability?
    let isEbook: Bool
    let listPrice: SaleInfoListPrice?
    let offers: [Offer]?
    let retailPrice: SaleInfoListPrice?
    let buyLink: String?
}

// MARK: - SaleInfoListPrice
struct SaleInfoListPrice: Codable {
    let amount: Int
    let currencyCode: String
}

// MARK: - Offer
struct Offer: Codable {
    let listPrice, retailPrice: OfferListPrice?
    let finskyOfferType: Int
}

// MARK: - OfferListPrice
struct OfferListPrice: Codable {
    let amountInMicros: Int
    let currencyCode: String
}

enum Saleability: String, Codable {
    case forSale = "FOR_SALE"
    case notForSale = "NOT_FOR_SALE"
}

// MARK: - SearchInfo
struct SearchInfo: Codable {
    let textSnippet: String
}

// MARK: - VolumeInfo
struct VolumeInfo: Codable {
    let ratingsCount: Int?
    let averageRating: Double?
    let publisher: String?
//    let industryIdentifiers: [IndustryIdentifier]?
    let title: String
    let readingModes: ReadingModes?
    let language: String?
    let infoLink: String?
    let imageLinks: ImageLinks?
    let panelizationSummary: PanelizationSummary?
    let allowAnonLogging: Bool
    let printType: PrintType
    let authors: [String]
    let pageCount: Int?
    let maturityRating: MaturityRating?
    let contentVersion, publishedDate: String?
    let previewLink: String?
    let canonicalVolumeLink: String?
    let categories: [String]?
    let description, subtitle: String?
}

//enum Author: String, Codable {
//    case danielKeyes = "Daniel Keyes"
//    case davidRogers = "David Rogers"
//}

// MARK: - ImageLinks
struct ImageLinks: Codable {
    let thumbnail, smallThumbnail: String?
}

// MARK: - IndustryIdentifier
struct IndustryIdentifier: Codable {
    let type: TypeEnum?
    let identifier: String?
}

enum TypeEnum: String, Codable {
    case isbn10 = "ISBN_10"
    case isbn13 = "ISBN_13"
}

enum Language: String, Codable {
    case en = "en"
    case es = "es"
    case ja = "ja"
}

enum MaturityRating: String, Codable {
    case notMature = "NOT_MATURE"
}

// MARK: - PanelizationSummary
struct PanelizationSummary: Codable {
    let containsImageBubbles, containsEpubBubbles: Bool
}

enum PrintType: String, Codable {
    case book = "BOOK"
}

// MARK: - ReadingModes
struct ReadingModes: Codable {
    let image, text: Bool
}
