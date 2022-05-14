
import Foundation
import RealmSwift

class DataBaseManager: NSObject {
    static let sharedInstance = DataBaseManager()
    
    public func writeDataInRealm(data : Object){
        
        var realmConfig = Realm.Configuration.defaultConfiguration
        realmConfig.deleteRealmIfMigrationNeeded = true
        do {
            let realm = try Realm(configuration: realmConfig)
            try! realm.write {
                realm.add(data)
            }
        }catch let error as NSError {
            debugPrint("Error to write data \(error.description)")
        }
    }
    
    public func readDataInRealm<Element: Object>(_ type: Element.Type) -> Results<Element>? {
        var realmConfig = Realm.Configuration.defaultConfiguration
        realmConfig.deleteRealmIfMigrationNeeded = true
        do {
            let realm = try Realm(configuration: realmConfig)
            let response = realm.objects(type)
            return response
        }
        catch let error as NSError {
            debugPrint("Error to read data \(error.description)")
        }
        return nil
    }
    
    /// Actualiza en la base de datos
    ///
    /// - Parameter data: Datos a guardar
    public func updateDataInRealm(data : Object){
        var realmConfig = Realm.Configuration.defaultConfiguration
        realmConfig.deleteRealmIfMigrationNeeded = true
        
        do {
            let realm = try Realm(configuration: realmConfig)
            try! realm.write {
                realm.add(data, update: .modified)
            }
        }
        catch let error as NSError {
            debugPrint("Error to write data \(error.description)")
        }
    }
    
    /// Elimina Usuario de RMK en la base de datos
    ///
    /// - Parameter data: Datos a guardar
    public func deleteDataInRealm(data : Object){
        var realmConfig = Realm.Configuration.defaultConfiguration
        realmConfig.deleteRealmIfMigrationNeeded = true

        do {
            let realm = try Realm(configuration: realmConfig)
            try! realm.write {
                realm.delete(data)
            }
        }
        catch let error as NSError {
            debugPrint("Error to write data \(error.description)")
        }
    }
}
