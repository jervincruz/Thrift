//
//  AddItemView.swift
//  Thrift
//
//  Created by Jervin Cruz on 2/20/18.
//  Copyright © 2018 Jervin Cruz. All rights reserved.
//

import UIKit
import CoreData

class AddItemView : ViewController {
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var expenses = [Expense]()
    
    let categories = ["Food", "Auto", "Clothing", "Leisure", "Utilities", "Misc"]
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let days = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]
    let years = [2018, 2019, 2020, 2021, 2022]
    
    var selectedCategory : String = ""
    var selectedMonth : Int = 0
    var selectedDay : Int = 0
    var selectedYear : Int = 0
    
    var expensesViewController = ExpensesViewController()
    
    // Outlets
    @IBOutlet weak var monthPicker: UIPickerView!
    @IBOutlet weak var dayPicker: UIPickerView!
    @IBOutlet weak var yearPicker: UIPickerView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    
    @IBAction func addExpense(_ sender: Any) {
        
        let name = nameTextField.text!
        let price = Double(priceTextField.text!)!
        let newExpense = Expense(context: context) // Create new Expense Object with context
        newExpense.name = name
        newExpense.price = price
        newExpense.category = selectedCategory
        newExpense.month = Int16(selectedMonth)
        newExpense.day = Int16(selectedDay)
        newExpense.year = Int16(selectedYear)
        newExpense.date = saveDate()
        expenses.append(newExpense)
        
        print(newExpense.date!)
        
        saveExpense()
        loadExpenses()
    }
    
    override func viewDidLoad(){
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        print("\(month)/\(day)/\(year)")
        
        // If user chooses current date & category
        selectedCategory = "Food"
        selectedMonth = month
        selectedDay = day
        selectedYear = year

        monthPicker.selectRow(month - 1, inComponent: 0, animated: true)
        dayPicker.selectRow(day - 1, inComponent: 0, animated: true)
        yearPicker.selectRow(0, inComponent: 0, animated: true)
    }
    
    func saveExpense(){
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    override func loadExpenses(with request : NSFetchRequest<Expense> = Expense.fetchRequest()){
        do {
            expenses = try context.fetch(request)
            for expense in expenses {
                print("Name: ", expense.name!)
                print("Price: ", expense.price)
                print("Category: ", expense.category!)
            }
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    func saveDate() -> String {
        var month : String = ""
        var completeDate : String = ""
        switch selectedMonth {
        case 1:
            month = "January"
        case 2:
            month = "February"
        case 3:
            month = "March"
        case 4:
            month = "April"
        case 5:
            month = "May"
        case 6:
            month = "June"
        case 7:
            month = "July"
        case 8:
            month = "August"
        case 9:
            month = "September"
        case 10:
            month = "October"
        case 11:
            month = "November"
        case 12:
            month = "December"
        default:
            month = "January"
        }
        completeDate = "\(selectedDay) \(month), \(selectedYear)"
        return completeDate
    }
    
}


//MARK: - Category and Date Selection
extension AddItemView : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return 6
        case 1:
            return 12
        case 2:
            return 31
        case 3:
            return 5
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag{
        case 0:
            return "\(categories[row])"
        case 1:
            return "\(months[row])"
        case 2:
            return "\(days[row])"
        case 3:
            return "\(years[row])"
        default: return " "
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag{
        case 0:
            selectedCategory = categories[row]
            print("Category: ", selectedCategory)
        case 1:
            selectedMonth = row + 1
            print("Month: ", selectedMonth)
        case 2:
            selectedDay = days[row]
            print("Day: ", selectedDay)
        case 3:
            selectedYear = years[row]
            print("Year: ", selectedYear)
        default:
            return
        }
    }
    
    // MARK: - Segue: Pass Context to ExpenseViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chartsSegue" {
            let vc = segue.destination as! ViewController
            vc.vcContext = context
            
        }
    }

}
