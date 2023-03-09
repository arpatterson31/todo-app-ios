//
//  CategoryViewController.swift
//  todoapp
//
//  Created by Audrey Patterson on 3/9/23.
//

import UIKit

class CategoryViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemPink
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    }
    
}