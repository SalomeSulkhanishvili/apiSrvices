//
//  APIServices.swift
//  GetJsonData
//
//  Created by Salome Sulkhanishvili on 14.02.22.
//

import Foundation

class APIServicies {
    static func getVaccines(completion: @escaping (Result<Vaccines,Error>) -> Void) {
        guard let url = URL(string: "http://covid-restrictions-api.noxtton.com/v1/vaccine") else { return }
        APIServicies.getURL(with: url, completion: { result in
            completion(result)
        })
    }
    
    static func getNations(completion: @escaping (Result<nationalities,Error>) -> Void) {
        guard let url = URL(string: "http://covid-restrictions-api.noxtton.com/v1/nationality") else { return }
        APIServicies.getURL(with: url, completion: { result in
            completion(result)
        })
    }

    
    
    static func getAirports(completion: @escaping (Result<Airports,Error>) -> Void) {
        guard let url = URL(string: "http://covid-restrictions-api.noxtton.com/v1/airport") else { return }
        APIServicies.getURL(with: url, completion: { result in
            completion(result)
        })
    }
    
    static func getRestrictionsInfo(from country: String, to airportCode: String, with vaccine: String, completion: @escaping (Result<Restrictions,Error>) -> Void) {
        let strUrl = "http://covid-restrictions-api.noxtton.com/v1/restriction/TBS/GVA?nationality=\(country)&vaccine=\(vaccine)&transfer=\(airportCode)"
        guard let url = URL(string: strUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            if let err = err {
                completion(.failure(err))
            }
            
            guard let data = data else { return }
            do {
                let dataDictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                print(dataDictionary)
                if let allRestricitons = dataDictionary["restricions"] as? [String: Any],
                    let restricitons = allRestricitons["RIX"] as? [String: Any] {
                    let restriction = Restrictions(with: restricitons)
                    completion(.success(restriction))
                }
            } catch let err {
                completion(.failure(err))
            }
        }.resume()
    }
    
    static func getURL<T: Codable>(with url: URL, completion: @escaping (Result<T,Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            if let err = err {
                completion(.failure(err))
            }
            
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch let err {
                completion(.failure(err))
            }
        }.resume()
    }
    
    struct Vaccines: Codable {
        var data: [String]
        
        private enum CodingKeys: String, CodingKey {
            case data = "vaccines"
        }
    }
    
    struct nationalities: Codable {
        var data: [String]
        
        private enum CodingKeys: String, CodingKey {
            case data = "nationalities"
        }
    }
    
    struct Airports: Codable {
        var data: [Airport]
        
        private enum CodingKeys: String, CodingKey {
            case data = "airports"
        }
    }
    
    struct Airport: Codable {
        var code: String
        var country: String
        var city: String
        
        private enum CodingKeys: String, CodingKey {
            case code, country, city
        }
    }
    // MARK: - Restricitons
    struct Restrictions {
        var type: String
        var generalRestricitons: GeneralRestricitons?
//        var byVaccination: RestrictionsByVaccination? = nil
//        var byNationalities: [RestrictionsByNationality]? = nil
        
        init(with data: [String: Any]) {
            type = data["type"] as? String ?? ""
            if let general = data["generalRestrictions"] as? [String: Any] {
                generalRestricitons = GeneralRestricitons(with: general)
            }
            
//            if let general = data["restrictionsByVaccination"] as? [String: Any] {
//                byVaccination = byVaccination(with: general)
//            }
//
//            if let general = data["restrictionsByNationality"] as? [String: Any] {
//                byNationalities = RestrictionsByNationality(with: general)
//            }
        }

    }
    
    struct GeneralRestricitons {
        var allowsTourists: String
        var allowsBusinessVisit: String
        var pcrRequiredForNoneResidents: String
        var pcrRequiredForResidents: String
        var generalInformation: String
        
        init(with data: [String: Any]) {
            allowsTourists = data["allowsTourists"] as? String ?? ""
            allowsBusinessVisit = data["allowsBusinessVisit"] as? String ?? ""
            pcrRequiredForNoneResidents = data["pcrRequiredForNoneResidents"] as? String ?? ""
            pcrRequiredForResidents = data["pcrRequiredForResidents"] as? String ?? ""
            generalInformation = data["generalInformation"] as? String ?? ""
        }
       
    }
    
    struct RestrictionsByVaccination: Codable {
        var isAllowed: Bool
        var dozesRequired: Int
        var minDaysAfterVaccination: Int
        var maxDaysAfterVaccination: Int
        
        private enum CodingKeys: String, CodingKey {
            case isAllowed, dozesRequired, minDaysAfterVaccination, maxDaysAfterVaccination
        }
    }
    
    struct RestrictionsByNationality: Codable {
        var type: String
        var data: [RestrictionsByNationalityData]?
        private enum CodingKeys: String, CodingKey {
            case type, data
        }
    }
    
    struct RestrictionsByNationalityData: Codable {
        var allowsTourists: Bool?
        var allowsBusinessVisit: Bool?
        var pcrRequired: Bool?
        var fastTestRequired: Bool?
        var biometricPassportRequired: Bool?
        var locatorFormRequired: Bool?
        var covidPassportRequired: Bool?
        
        private enum CodingKeys: String, CodingKey {
            case allowsTourists, allowsBusinessVisit, pcrRequired, fastTestRequired, biometricPassportRequired, locatorFormRequired, covidPassportRequired
        }
    }
}
