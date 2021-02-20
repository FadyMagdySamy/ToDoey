//
//  ViewController.swift
//  Todoey
//
//  Created by Fady Magdy on 2/14/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//
import UIKit
import CoreData
import ChameleonFramework

class TodoListViewController: swipeTableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var itemArray = [Item]()
    var selectedCategory : Category?{
        didSet{
          
            loadItems()
        }
        
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.separatorStyle = .none
        searchBar.delegate = self
        
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if let hexColour = selectedCategory?.color{
            title = selectedCategory!.name
            
            guard  let navBar = navigationController?.navigationBar else {fatalError("navigation Bar doesn't exist")
               
            }
            
            if let navBarColour =  UIColor(hexString: hexColour){
            navBar.backgroundColor = navBarColour
            navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
           // searchBar.barTintColor = navBarColour
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
            }
           
        }
    }
    
    //MARK: - tableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        if  let colour = UIColor(hexString: selectedCategory!.color!)?.darken(byPercentage:  CGFloat(indexPath.row) / CGFloat(itemArray.count))
                                                                                
                                                                               {
            cell.backgroundColor = colour
            cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            
        }
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        
        return cell
    }
    
    //MARK: - tableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //delete items
        
        
        /*   context.delete(itemArray[indexPath.row])
         self.itemArray.remove(at: indexPath.row)
         */
        self.saveItems()
        
        
        
        
        
        //updating title
        // itemArray[indexPath.row].setValue("completed", forKey: "title")
        // self.saveItems()
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - delete from swipe
    override func updateModel(at indexPath : IndexPath){
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        self.saveItems()
        tableView.reloadData()
        
    }
    
    
    //MARK: - save items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "add new todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add item", style: .default) { (action) in
            if let t = textField.text {
                
                let newItem =  Item(context: self.context)
                newItem.title = t
                newItem.done = false
                
                newItem.parentCategory = self.selectedCategory
                
                self.itemArray.append(newItem)
                self.saveItems()
                
                
                
                
                
                self.tableView.reloadData()
            }
        }
        alert.addAction(action)
        alert.addTextField { (textFieldItem) in
            textFieldItem.placeholder = "create new item"
            textField = textFieldItem
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    func saveItems(){
        do {
            try context.save()
        }
        catch{
            print("error in saving context \(error)")
        }
    }
    
    //MARK: - load items
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest() , predicate : NSPredicate?=nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name matches %@",selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
            
        }else
        {
            request.predicate = categoryPredicate
        }
        
        
        do{
            
            itemArray = try context.fetch(request)
            
            
        } catch{
            print("error in fetching request\(error)")
        }
        tableView.reloadData()
    }
    
    
    
}



//MARK: - SEARCH BAR METHODS
extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        let searchPredicate = NSPredicate(format: "title contains[cd] %@",searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: searchPredicate)
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

