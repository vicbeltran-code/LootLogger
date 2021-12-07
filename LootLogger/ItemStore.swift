//
//  ItemStore.swift
//  LootLogger
//
//  Created by Victor Beltran on 12/5/21.
//

import UIKit

class ItemStore {
    
    var allItems = [Item]()
       
       let itemArchiveURL: URL = {
           
           let documentDirectories = FileManager.default.urls(for: .documentDirectory,
                                                              in: .userDomainMask)
           let documentDirectory = documentDirectories.first!
           
           return documentDirectory.appendingPathComponent( "items.plist" )
       }()
       
    @discardableResult func createItem() -> Item {
        
        let newItem  = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
    func removeItem(_ item: Item) {
        
        if let index = allItems.firstIndex(of: item) {
            
            allItems.remove(at: index)
        }
    }
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        
        if fromIndex == toIndex {
            return
    }
        // get reference to object being moved so you can reinsert it
        let movedItem = allItems[fromIndex]
        
        // remove item from array
        allItems.remove(at: fromIndex)
        
        // insert item in array at new location
        allItems.insert(movedItem, at: toIndex)
  }
    @objc func saveChanges() -> Bool {
        
        print("Saving items to : \(itemArchiveURL)")
        
        do {
            
        let encoder = PropertyListEncoder()
            
        let data = try encoder.encode(allItems)
            
            try data.write(to: itemArchiveURL, options: [.atomic])
            
            print("Saved all of the items")
            
            return true
            
        } catch let encodingError {
            
            print("Error encoding allItems: \(encodingError)")
            
            return false
            
        }
    }
    init() {
        do {
            let data = try Data(contentsOf: itemArchiveURL)
            
            let unarchiver = PropertyListDecoder()
            
            let items = try unarchiver.decode([Item].self, from: data)
            
            allItems = items
        } catch {
            print("Error reading in saved itels:\(error)")
        }
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self,
                                       selector: #selector(saveChanges),
                                       name: UIScene.didEnterBackgroundNotification,
                                       object: nil)
    }
    
}
