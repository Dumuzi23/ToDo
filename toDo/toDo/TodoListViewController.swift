//
//  ViewController.swift
//  toDo
//
//  Created by Tatsuya Amida on 2020/07/21.
//  Copyright © 2020 T.A. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()

    let defaults =  UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)

//        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
//            itemArray = items
//        }

    }

    //MARK: Tableview Datasource Methods

    // 行数を指定するメソッド（必須）
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    // セルを作成し、tableViewに返すメソッド（必須）
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")

        let item = itemArray[indexPath.row]

        cell.textLabel?.text = item.title

        if item.done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    //MARK: Tableview Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // 選択したセルがチェックされていればチェックを外す。チェックされていなければチェックする。
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        tableView.reloadData()

        // セルが選択された後、選択状態が解除されるようにする
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: 新しいタスクの追加

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Today Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // AlertのAdd Itemボタンを押した時の動作
            let newItem = Item()
            // textFieldのtextプロパティがnilになることは無いので、forced unwrapして良い
            newItem.title = textField.text!

            self.itemArray.append(newItem)

            // UserDefaultsにitemArrayを保存
            self.defaults.set(self.itemArray, forKey: "TodoListArray")

            self.tableView.reloadData()
        }

        // Alertにテキストフィールドを追加
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

}

