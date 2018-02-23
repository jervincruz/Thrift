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
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let days = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]
    let years = [2018, 2019, 2020, 2021, 2022]
    
    var selectedMonth = ""
    var selectedDay = 0
    var selectedYear = 0
    
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
    
    override func loadExpenses(with request : NSFetchRequest<Expense> = Expense.fetchRequest()){
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
        
        if selectedMonth != "" && selectedDay != 0 && selectedYear != 0 {
            if month == selectedMonth && day == String(selectedDay) && year == String(selectedYear) {
                        cell.textLabel?.text = "\(String(describing: category)) \(String(describing: name)) \(String(describing: price)) \(month)/\(day)/\(year)/"
            }
        }
        else {
        cell.textLabel?.text = "\(String(describing: category)) \(String(describing: name)) \(String(describing: price)) \(month)/\(day)/\(year)/"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        context?.delete(expenses[indexPath.row])
        expenses.remove(at: indexPath.row)
        saveExpense()
        expensesTableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func submitDate(_ sender: Any) {
        expensesTableView.reloadData()
        super.viewDidLoad()
    }
}

extension ExpensesViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 12
        case 1:
            return 31
        case 2:
            return 5
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return months[row]
        case 1:
            return String(days[row])
        case 2:
            return String(years[row])
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedMonth = months[row]
        case 1:
            selectedDay = days[row]
        case 2:
            selectedYear = years[row]
        default:
            return
        }
    }
    
}

