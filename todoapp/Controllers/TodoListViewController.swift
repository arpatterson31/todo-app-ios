//
//  ViewController.swift
//  todoapp
//
//  Created by Audrey Patterson on 3/7/23.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    // pulls from line 49 in the AppDelegate Class
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemPink
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
       
        loadItems()
    }

    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todoItem = itemArray[indexPath.row]
       
        // withIdentifier needs to be the same as the unique Identifier set in the table view cell attributes
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = todoItem.title
        
        // adds a checkmark on the todo item that was selected using the accessories in the attributes inspector
        // swift ternary ->  value = condition ? valueIfTrue: valueIfFalse
        cell.accessoryType = todoItem.done ? .checkmark : .none

        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        method to update object
//        itemArray[indexPath.row].setValue(value, forKey: key)
        
//        removes from the db - order matters!! delete with context first then delete from our array
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        // highlight the one selected in grey and then removes that highlight
        tableView.deselectRow(at: indexPath, animated: true)
        
   
    }
    
    //MARK - ADD NEW ITEMS
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // local textfield variable to take on what the user enters in our closure
        var textField = UITextField()
        
        // defines the alert
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        // defines the action
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the add item button on my ui alert
            
            
            // Saving data with Core Data
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
            // saves items and encodes it and stores to the data file path
            self.saveItems()
        }
        
        
        
        // adds a textfield to our alert for user input
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        // attaches an action object to the alert
        alert.addAction(action)
        // presents it modally
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manipulation Methods
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        // reloads the table view once a new todo task has been added to my array
        self.tableView.reloadData()
    }
    
    // default parameter which allows us to load items when the app first loads up
    // also has an external and internal parameter
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    
}

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
//        querying using core data - objective-c code being used %@ searchbar.text will be put into that holder
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        loadItems(with: request)

    }
    // func that will go back to the original list once user hits the X or backs out of the search bar
    // func uses the dispatch queue to remove the cursor blink and the keyboard once i am done searching
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}

