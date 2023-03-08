//
//  ViewController.swift
//  todoapp
//
//  Created by Audrey Patterson on 3/7/23.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    // interface to the user's defaults database - key value pairs stored persistently across launches of the app
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.darkGray
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        // refactor after creating an Item class - previous todos were stored in an array
        let newItem = Item()
        newItem.title = "laundry"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "feed rey-rey"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "finish ios course"
        itemArray.append(newItem3)
        
        // this goes into the the defaults object and pulls out what is in local storage if there are items and uses that on page load.
//        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
//            itemArray = items
//        }
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
                
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // reloads the table to get the checkmarks back
        tableView.reloadData()
        
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
            // add new item using our Item Class
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            // adds to the defaults object, much like local storage
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            // reloads the table view once a new todo task has been added to my array
            self.tableView.reloadData()
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
}

