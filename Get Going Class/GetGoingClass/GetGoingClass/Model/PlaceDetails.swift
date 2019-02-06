//
//  PlaceDetails.swift
//  GetGoingClass
//
//  Created by Admin on 2019-01-23.
//  Copyright © 2019 SMU. All rights reserved.
//

import Foundation

class PlaceDetails: NSObject, NSCoding {
    struct PropertyKey {
        static let idKey = "id"
        static let nameKey = "name"
        static let vicinityKey = "vicinity"
        static let formattedAddressKey = "formattedAddress"
        static let iconKey = "icon"
        static let ratingKey = "rating"
        static let place_idKey = "place_id"
        static let phoneKey = "formatted_phone_number"
        static let websiteKey = "website"
    }
    
    var id: String
    var name: String?
    var vicinity: String?
    var formattedAddress: String?
    var rating: Double?
    var icon: String?
    var address: String? {
        return formattedAddress ?? vicinity
    }
    var place_id: String?
    var formatted_phone_number: String?
    var website: String?
    
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PropertyKey.idKey)
        aCoder.encode(name, forKey: PropertyKey.nameKey)
        aCoder.encode(vicinity, forKey: PropertyKey.vicinityKey)
        aCoder.encode(formattedAddress, forKey: PropertyKey.formattedAddressKey)
        aCoder.encode(rating, forKey: PropertyKey.ratingKey)
        aCoder.encode(icon, forKey: PropertyKey.iconKey)
        aCoder.encode(place_id, forKey: PropertyKey.place_idKey)
        aCoder.encode(formatted_phone_number, forKey: PropertyKey.formattedAddressKey)
        aCoder.encode(website, forKey: PropertyKey.websiteKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: PropertyKey.idKey) as? String ?? ""
        let name = aDecoder.decodeObject(forKey:PropertyKey.nameKey) as? String
        let vicinity = aDecoder.decodeObject(forKey:PropertyKey.vicinityKey) as? String
        let formattedAddress = aDecoder.decodeObject(forKey:PropertyKey.formattedAddressKey) as? String
        let rating = aDecoder.decodeObject(forKey:PropertyKey.ratingKey) as? Double
        let icon = aDecoder.decodeObject(forKey:PropertyKey.iconKey) as? String
        let place_id = aDecoder.decodeObject(forKey: PropertyKey.place_idKey) as? String
        let website = aDecoder.decodeObject(forKey: PropertyKey.websiteKey) as? String
        let formatted_phone_number = aDecoder.decodeObject(forKey: PropertyKey.phoneKey) as? String
        self.init(id: id, name: name, vicinity: vicinity, formattedAddress: formattedAddress, rating: rating, icon: icon, place_id: place_id, website: website, formatted_phone_number: formatted_phone_number)
    }
    
    init(id: String, name: String?, vicinity: String?, formattedAddress: String?, rating: Double?, icon: String?, place_id: String?, website: String?, formatted_phone_number: String?) {
        
        self.id = id
        self.name = name
        self.vicinity = vicinity
        self.formattedAddress = formattedAddress
        self.rating = rating
        self.icon = icon
        self.place_id = place_id
        self.website = website
        self.formatted_phone_number = formatted_phone_number
    }
    
    
    //MARK - Iinitializers
    init?(json: [String: Any]) {
        guard let id = json["id"] as? String else { return nil }
        self.id = id
        self.name = json["name"] as? String
        self.vicinity = json["vicinity"] as? String
        self.formattedAddress = json["formatted_address"] as? String
        self.rating = json["rating"] as? Double
        self.icon = json["icon"] as? String
        self.place_id = json["place_id"] as? String
        self.website = json["website"] as? String
        self.formatted_phone_number = json["formatted_phone_number"] as? String
    }
}
