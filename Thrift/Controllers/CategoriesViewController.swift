//
//  CategoriesViewController.swift
//  Thrift
//
//  Created by Jervin Cruz on 2/23/18.
//  Copyright © 2018 Jervin Cruz. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var expensesInCategory: UITableView!
    @IBOutlet weak var datePicker: UIPickerView!
    
    var categoriesVCContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var expenses = [Expense]()
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let days = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]
    let years = [2018, 2019, 2020, 2021, 2022]
    
    
    var month = 0
    var day = 0
    var year = 0
    var category = ""
    
    override func viewDidLoad(){
        super.viewDidLoad()
        expensesInCategory.isHidden = true
        loadExpenses(month, day, year)
    }
    
    // Put the predicate to sync the tableview rows with your data, no duplicates will appear
    func loadExpenses(with request : NSFetchRequest<Expense> = Expense.fetchRequest(), predicate : NSPredicate? = nil,_ month : Int,_ day : Int,_ year : Int){
        
        let monthPredicate = NSPredicate(format: "month == %@", NSNumber(value: month))
        let dayPredicate = NSPredicate(format: "day == %@", NSNumber(value: day))
        let yearPredicate = NSPredicate(format: "year == %@", NSNumber(value: year))
        
        var comboPredicates = NSCompoundPredicate(andPredicateWithSubpredicates: [monthPredicate, dayPredicate, yearPredicate])
        
        if let anotherPredicate = predicate {
            comboPredicates = NSCompoundPredicate(andPredicateWithSubpredicates: [monthPredicate, dayPredicate, yearPredicate, anotherPredicate])
            request.predicate = comboPredicates
        }
        
        do {
            expenses = try categoriesVCContext.fetch(request)
            for expense in expenses {
                print("N:", expense.name!, "$", expense.price, "Cat:", expense.category!)
            }
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    // Food Category
    @IBAction func handleSelection(_ sender: UIButton) {
        print(" \(month)/\(day)/\(year)")
        self.expensesInCategory.isHidden = !self.expensesInCategory.isHidden
        category = "Food"
       
        let foodPredicate = NSPredicate(format: "category == %@", category)
        loadExpenses(with: Expense.fetchRequest(), predicate: foodPredicate, month, day, year)

        expensesInCategory.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var food = 0
        var auto = 0
        var utilities = 0
        var clothing = 0
        var leisure = 0
        var misc = 0
        
        for expense in expenses {
            switch expense.category {
            case "Food"?:
                food += 1
            case "Auto"?:
                auto += 1
            case "Utilities"?:
                utilities += 1
            case "Clothing"?:
                clothing += 1
            case "Leisure"?:
                leisure += 1
            case "Misc"?:
                misc += 1
            default:
                return 0
            }
   
        }

        return food
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryItemCell", for: indexPath)
        
        cell.transform = CGAffineTransform(translationX: 0, y: 1)
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0.05*Double(indexPath.row), options: [.curveEaseInOut], animations: {
            cell.transform = CGAffineTransform(translationX: 0, y: 0)
            cell.alpha = 1
        }, completion: nil)
        
        if expenses[indexPath.row].category == "Food" {
        cell.textLabel?.text = expenses[indexPath.row].name!
        }
        else{
            return cell
        }

        return cell
    }
    
}

extension CategoriesViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
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
            return "\(months[row])"
        case 1:
            return "\(days[row])"
        case 2:
            return "\(years[row])"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            month = row + 1
        case 1:
            day = row + 1
        case 2:
            year = row + 2018
        default:
            return
            
        }
    }
    
}
