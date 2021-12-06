//
//  ItemsViewController.swift
//  LootLogger
//
//  Created by Victor Beltran on 12/5/21.
//

import UIKit

class ItemsViewController: UITableViewController {
    var itemStore: ItemStore!
    
    @IBAction func addNewItem(_ sender: UIButton) {
        // create item and add it to the store
        let newItem = itemStore.createItem()
        // fogure out where that item is in the array
        if let index = itemStore.allItems.firstIndex(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
        
        // insert this new row into the table
        tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        // if you are currently in editing mode..
        if isEditing {
            // change text of button to inform user of state
            sender.setTitle("Edit", for: .normal)
            // turn off editing mode
            setEditing(false, animated: true)
        } else {
            // change text of button to inform user of state
            sender.setTitle("Done", for: .normal)
            // enter edititg mode
            setEditing(true, animated: true)
        }
       
    }
    override func  viewDidLoad() {
         super.viewDidLoad()
         
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
}
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create an instance of UITableViewCell with default appearance
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        // set the text on the cell with the description of the item
        // that is at the nth index of iteml. where n = row this cell
        // will appear in on the table view
        let item = itemStore.allItems[indexPath.row]
        // configure the cell with the item
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        cell.valueLabel.text = "$\(item.valueInDollars)"
        
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // if the table view is asking to commit a delete command...
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]
            // remove the item from the store
            itemStore.removeItem(item)
            // also remove that row from the table view with an animation
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // update the model
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // if the triggered segue is the "showItem" segue
        switch segue.identifier {
        case "showItem":
            // figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                // get the item associated with this row and pass it along
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
            }
    default:preconditionFailure("Unexpected segue identifier.")
    }
  }
        
}

