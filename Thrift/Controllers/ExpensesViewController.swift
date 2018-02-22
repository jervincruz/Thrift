//
//  ExpensesViewController.swift
//  Thrift
//
//  Created by Jervin Cruz on 2/21/18.
//  Copyright © 2018 Jervin Cruz. All rights reserved.
//

import UIKit
import CoreData

class ExpensesViewController : ViewController, UITableViewDataSource, UITableViewDelegate {
    
    var context : NSManagedObjectContext?
    var currentContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var expenses = [Expense]()
    
    @IBOutlet weak var expensesTableView: UITableView!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        loadExpenses()
        expensesTableView.reloadData()
        
    }
    
    func saveExpense(){
        do {
            try context?.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadExpenses(with request : NSFetchRequest<Expense> = Expense.fetchRequest()){
        do {
            context = context == nil ? currentContext : context!
            expenses = (try context?.fetch(request))!
            for expense in expenses {
                print("Name: ", expense.name!)
                print("Price: ", expense.price)
                print("Category: ", expense.category!)
            }
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath)
        
        let category = expenses[indexPath.row].category!
        let name = expenses[indexPath.row].name!
        let price = expenses[indexPath.row].price
        let month  = String(expenses[indexPath.row].month)
        let day = String(expenses[indexPath.row].day)
        let year = String(expenses[indexPath.row].year)
        
        cell.textLabel?.text = "\(String(describing: category)) \(String(describing: name)) \(String(describing: price)) \(month)/\(day)/\(year)/"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        context?.delete(expenses[indexPath.row])
        expenses.remove(at: indexPath.row)
        saveExpense()
        expensesTableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
}
