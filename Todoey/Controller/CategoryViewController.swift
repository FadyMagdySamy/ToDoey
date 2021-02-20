//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Fady Magdy on 2/16/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class CategoryViewController: swipeTableViewController {
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print(dataFilePath)
        tableView.separatorStyle = .none
        
        
        loadCategories()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("navigation Controller doesn't exist")
        }
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        
        if let  categoryColor = categories[indexPath.row].color{
            
            cell.backgroundColor = UIColor(hexString: categoryColor )
            
            if let hexColour = UIColor(hexString: categoryColor){
                cell.textLabel?.textColor = ContrastColorOf(hexColour, returnFlat: true)
            }
            
          
        }
        
       
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*  context.delete(categories[indexPath.row])
         categories.remove(at: indexPath.row)
         saveCategories()
         tableView.reloadData()
         */
        
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if  let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    
    
    
    
    
    
    
    //MARK: -  data manipulation methods
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //print("I am the add categories")
        
        
        var textField = UITextField()
        let alert = UIAlertController(title: "add new todoey category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add category", style: .default) { (action) in
            if let t = textField.text {
                
                
                
                
                let newCategory = Category(context: self.context)
                
                newCategory.name = t
                newCategory.color = UIColor.randomFlat().hexValue()
                
                self.categories.append(newCategory)
                
                
                
                self.saveCategories()
                
                self.tableView.reloadData()
            }}
        alert.addAction(action)
        alert.addTextField { (textFieldItem) in
            textFieldItem.placeholder = "create new category"
            textField = textFieldItem
        }
        
        self.present(alert, animated: true, completion: nil)
        
        
        
        self.saveCategories()
    }
    
    //MARK: - save categories
    func saveCategories(){
        do {
            try context.save()
        }
        catch{
            print("error in saving context \(error)")
        }
        
    }
    
    //MARK: - load categories
    
    func loadCategories(with request:NSFetchRequest<Category> = Category.fetchRequest()) {
        do{
            categories = try context.fetch(request)
            
        } catch{
            print("error in fetching request\(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - delete from swipe
    
    override func updateModel(at indexPath : IndexPath){
        
        context.delete(categories[indexPath.row])
        categories.remove(at: indexPath.row)
        saveCategories()
        tableView.reloadData()
        
    }
    
}



