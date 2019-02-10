//
//  CoreDataHandler.swift
//  lessonCoreData
//
//  Created by Dmitry Pyatin on 10.12.2017.
//  Copyright © 2017 Dmitry Pyatin. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHandler: NSObject {

    //MARK - get data
    private class func getContext() -> NSManagedObjectContext  {
        
        let appDelegate  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return appDelegate//appDelegate.persistentContainer.viewContext
        
    }
    
    
    class func saveObjectNews(entityName: String, id: Int, picture: String, user_id: Int, place_id: Int, message: String, likes: Int,created_at: String,updated_at: String, sight_id: Int,restaurant_id: Int,marina_id: Int,place_charter_id: Int,route_id: Int, yacht_id: Int, anchorage_id: Int) -> Bool {
        
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        
        manageObject.setValue(id, forKey: "id")
        manageObject.setValue(picture, forKey: "picture")
        manageObject.setValue(user_id, forKey: "user_id")
        manageObject.setValue(place_id, forKey: "place_id")
        manageObject.setValue(message, forKey: "message")
        manageObject.setValue(likes, forKey: "likes")
        manageObject.setValue(created_at, forKey: "created_at")
        manageObject.setValue(updated_at, forKey: "updated_at")
        manageObject.setValue(sight_id, forKey: "sight_id")
        manageObject.setValue(restaurant_id, forKey: "restaurant_id")
        manageObject.setValue(marina_id, forKey: "marina_id")
        manageObject.setValue(place_charter_id, forKey: "place_charter_id")
        manageObject.setValue(route_id, forKey: "route_id")
        manageObject.setValue(yacht_id, forKey: "yacht_id")
        manageObject.setValue(anchorage_id, forKey: "anchorage_id")
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }

        
    }
    
    //MARK - save data for entity PoiPlacesData, передаем имя таблицы и атрибуты таблицы
    class func saveObjectPoi(entityName: String, lat: Double, lng: Double, name: String, poiplacesid: Int, rating: Double, picture: String, thumb: String, user_id: Int, descriptionplace: String, imageData: NSData) -> Bool {
        
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)

        manageObject.setValue(lat, forKey: "lat")
        manageObject.setValue(lng, forKey: "lng")
        manageObject.setValue(name, forKey: "name")
        manageObject.setValue(poiplacesid, forKey: "poiplacesid")
        manageObject.setValue(rating, forKey: "rating")
        manageObject.setValue(picture, forKey: "picture")
        manageObject.setValue(thumb, forKey: "thumb")
        manageObject.setValue(user_id, forKey: "user_id")
        manageObject.setValue(descriptionplace, forKey: "descriptionplace")
                manageObject.setValue(imageData, forKey: "imageData")
        

        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    //MARK - save data for entity UsersData, передаем имя таблицы и атрибуты таблицы
    class func saveObjectUsers(entityName: String, name: String, qualification: String, photoURL: String, totalNM: Float, comment: String, totalExpedition: Int, userid: Int, email: String, imageData: NSData) -> Bool {
        
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)

        
        manageObject.setValue(name, forKey: "name")
        manageObject.setValue(qualification, forKey: "qualification")
        manageObject.setValue(photoURL, forKey: "photourl")
        manageObject.setValue(totalNM, forKey: "totalNM")
        manageObject.setValue(comment, forKey: "comment")
        manageObject.setValue(totalExpedition, forKey: "totalExpedition")
        manageObject.setValue(userid, forKey: "userid")
        manageObject.setValue(email, forKey: "email")
        manageObject.setValue(imageData, forKey: "imageData")
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    
    
    
    //MARK - select data POiPlacesData
    class func fetchObjectPoi() -> [PoiPlacesData]? {
        
        let contex = getContext()
        var poiplacesdata:[PoiPlacesData]? = nil
        
        do {
            poiplacesdata = try contex.fetch(PoiPlacesData.fetchRequest())
            return poiplacesdata
        } catch {
            return poiplacesdata
        }
    }
    
    //MARK - select data UsersData
    class func fetchObjectUsers() -> [UsersData]? {
        
        let contex = getContext()
        var usersdata:[UsersData]? = nil
        
        do {
            usersdata = try contex.fetch(UsersData.fetchRequest())
            return usersdata
        } catch {
            return usersdata
        }
    }
    
    
    
    //MARK - single delete
    class func deleteObject(object: NSManagedObject /*User*/) -> Bool {
        
        let context = getContext()
        context.delete(object/*user*/)
        
        do {
           try context.save()
            return true
        } catch {
            
            return false
        }
    }
    
    //MARK - POI full delete
    class func cleanDeletePoi() -> Bool {
        
        let contex = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: PoiPlacesData.fetchRequest())
        
        do {
            try contex.execute(delete)
            return true
        }catch {
            
            return false
        }
        
    }
    
    
    
    //MARK - users full delete
    class func cleanDeleteUsers() -> Bool {
        
        let contex = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: UsersData.fetchRequest())
        
        do {
            try contex.execute(delete)
            return true
        }catch {
            
            return false
        }
        
    }
    
    
    //MARK - news full delete
    class func cleanDeleteNews() -> Bool {
        
        let contex = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: NewsData.fetchRequest())
        
        do {
            try contex.execute(delete)
            return true
        }catch {
            
            return false
        }
        
    }
    
    
    //MARK - filtered data
    class func filterDataPoi(filterText: String, strong: Int) -> [PoiPlacesData]? {
        
        let contex = getContext()
        let fetchRequest:NSFetchRequest<PoiPlacesData> = PoiPlacesData.fetchRequest()
        var poiplacesdata:[PoiPlacesData]? = nil
        var formatFilter: String?
        //MARK - маска фильтрации, в данном случае содержит
        
        //let predicate = NSPredicate(format: "name contains[c] %@", filterText)
        
        
        if strong == 0 {
            formatFilter = "name contains[c] %@"
        } else {
            formatFilter = "user_id == %@"
        }
        
        let predicate = NSPredicate(format: formatFilter!, filterText)
        
        
        fetchRequest.predicate = predicate
        do {
            poiplacesdata = try contex.fetch(fetchRequest)
            return poiplacesdata
        }catch {
            return poiplacesdata
        }
    }
    
    
    
    //MARK - filtered data
    class func filterDataUser(filterText: String, strong: Int) -> [UsersData]? {
        
        let contex = getContext()
        let fetchRequest:NSFetchRequest<UsersData> = UsersData.fetchRequest()
        var usersdata:[UsersData]? = nil
        var formatFilter: String?
        //MARK - маска фильтрации, в данном случае содержит
        
        if strong == 0 {
            formatFilter = "name contains[c] %@"
        } else {
            formatFilter = "userid == %@"
        }
        
        //let predicate = NSPredicate(format: "name contains[c] %@", filterText)
        let predicate = NSPredicate(format: formatFilter!, filterText)

        fetchRequest.predicate = predicate
        
        do {
            usersdata = try contex.fetch(fetchRequest)
        
            return usersdata
            
        }catch {
            
            return usersdata
            
        }
        
        
        
        
    }
    
    
}
