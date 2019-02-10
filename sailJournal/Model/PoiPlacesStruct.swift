//
//  PoiPlacesStruct.swift
//  sailJournal
//
//  Created by Dmitry Pyatin on 09.12.2017.
//  Copyright © 2017 Dmitry Pyatin. All rights reserved.
//

import Foundation


//    MARK: данные для POI JSON
struct PoiPlaces: Codable {
    
    //let places: Poi
    //let pages: Int
    let id: Int
    let lat: Double
    let lng: Double
    let rating: Double?
    let name: String?
    let description: String?
    let picture: String?
    let thumb: String?
    let user_id: Int
    let last_page: Int
}


//struct Poi:  Codable {
//    let id: Int
//    let lat: Double
//    let lng: Double
//    let rating: Double?
//    let name: String?
//    let description: String?
//    let picture: String?
//    let thumb: String?
//    let user_id: Int
//}

struct Facilities: Codable {
    let pages: Int
}


//MARK: структура для новых мест добавляемых пользователем
struct NewPoiPlacesStruct {
    let lat: Double
    let lng: Double
    let name: String
}


//MARK: структура для отправки геолокации
struct UserLocationData: Encodable {
    let name: Int
    let lat: Double
    let lng: Double
    let speed: Double
    let course: Double
    let dateNow: String
  
}

//MARK: структура для новостей
struct News: Codable {
    let id: Int
    let picture: UrlPicture
    let user_id: Int
    let place_id: Int?
    let message: String
    let likes: Int
    let created_at: String
    let updated_at: String
    let sight_id: Int?
    let restaurant_id: Int?
    let marina_id: Int?
    let place_charter_id: Int?
    let route_id: Int?
    let yacht_id: Int?
    let anchorage_id: Int?
}

struct UrlPicture: Codable {
    let url: String
    let thumb: ThumbUrl
}

struct ThumbUrl: Codable {
    let url: String
}

struct Users: Decodable {
    let id: Int
    let name: String
    let qualification: String
    let photourl: String
    let totalNM: Float
    let comment: String?
    let totalExpedition: Int
    let email: String?
}

struct UserID: Decodable {
    let user_id: Int
}


//MARK: структура для отправки формы при регистрации
struct UserRegistrationData: Encodable {
    let name: String
    let email: String
    
}




