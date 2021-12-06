//
//  ItemStore.swift
//  LootLogger
//
//  Created by Victor Beltran on 12/5/21.
//

import UIKit

class ItemStore {
    var allItems = [Item]()
    
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
}
