//
//  swipeTableViewController.swift
//  Todoey
//
//  Created by Fady Magdy on 2/20/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class swipeTableViewController: UITableViewController , SwipeTableViewCellDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .left else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.updateModel(at: indexPath)
            // handle action by updating model with deletion
           
          /*  context.delete(self.categories[indexPath.row])
            categories.remove(at: indexPath.row)
            saveCategories()
            tableView.reloadData()
            */
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    
    
    //tableView datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:  indexPath)
        as! SwipeTableViewCell
        tableView.rowHeight = 70.0
        cell.delegate = self
        
        return cell
       
    }
    func updateModel(at indexPath:IndexPath){
        print("hello from parent")
    }

    }

