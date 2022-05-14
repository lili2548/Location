

import Foundation
import RealmSwift
import Realm

@objcMembers class ISSModel: Object, Codable {
    dynamic var id: String = ""
    dynamic var timestamp: Double = 0
    dynamic var latitude: Double = 0
    dynamic var longitude: Double = 0
    
    enum OuterKeys: String, CodingKey{
        case timestamp
        case issPosition = "iss_position"
    }
    
    enum ISSPositionKeys: String, CodingKey{
        case latitude
        case longitude
    }
    
    required init(from decoder: Decoder) throws {
        let outerContainer = try decoder.container(keyedBy: OuterKeys.self)
        let issposition = try outerContainer.nestedContainer(keyedBy: ISSPositionKeys.self, forKey: .issPosition)
        
        self.timestamp = try outerContainer.decode(Double.self, forKey: .timestamp)
        let stringLat = try issposition.decode(String.self, forKey: .latitude)
        let stringLong = try issposition.decode(String.self, forKey: .longitude)
        
        self.latitude = Double(stringLat) ?? 0
        self.longitude = Double(stringLong) ?? 0
        self.id = UUID().uuidString
        super.init()
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    required override init(){
        super.init()
    }
    
}
