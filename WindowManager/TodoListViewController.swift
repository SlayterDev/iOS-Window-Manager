//
//  TodoListViewController.swift
//  WindowManager
//
//  Created by bslayter on 6/19/17.
//
//

import UIKit
import RealmSwift

class TodoListViewController: WindowViewController, UITableViewDelegate, UITableViewDataSource {
    
    let reuseIdentifier = "todoIdentifier"
    
    var tableView: UITableView!
    
    var todoItems: Results<TodoModel>?
    
    var notificationToken: NotificationToken!
    var realm: Realm!
    
    override var windowTitle: String {
        get {
            return "Todo List"
        }
    }
    
    override var wantsNavigationController: Bool {
        get {
            return true
        }
        set {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
        tableView = UITableView().then {
            $0.delegate = self
            $0.dataSource = self
            
            self.view.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.edges.equalTo(self.view)
            }
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        do {
            self.realm = try Realm()
            self.notificationToken = realm.addNotificationBlock { _, _ in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            self.todoItems = realm.objects(TodoModel.self)
        } catch let error as NSError {
            print("Error occured opening realm: \(error.localizedDescription)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = todoItems else { return 0 }
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        guard let item = todoItems?[indexPath.row] else { return cell }
        
        cell.textLabel?.text = item.title
        if item.isComplete {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func addItem() {
        let av = UIAlertController(title: "New Todo Item", message: "Enter a title for your todo item.", preferredStyle: .alert)
        av.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Take out the trash"
        })
        av.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            guard let title = av.textFields?.first?.text else { return }
            
            let newItem = TodoModel()
            newItem.title = title
            newItem.id = UUID().uuidString
            try? self.realm.write {
                self.realm.add(newItem)
            }
        }))
        av.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(av, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = todoItems?[indexPath.row] else { return }
        
        try? realm.write {
            item.isComplete = !item.isComplete
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let item = todoItems?[indexPath.row] else { return }
            
            try? realm.write {
                realm.delete(item)
            }
        }
    }
}
