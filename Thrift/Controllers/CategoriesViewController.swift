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
    
    var categoriesVCContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var expenses = [Expense]()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        expensesInCategory.isHidden = true
        loadExpenses()
    }
    
    // Put the predicate to sync the tableview rows with your data, no duplicates will appear
    func loadExpenses(with request : NSFetchRequest<Expense> = Expense.fetchRequest()){
        do {
            expenses = try categoriesVCContext.fetch(request)
            for expense in expenses {
                print("N:", expense.name!, "$", expense.price, "Cat:", expense.category!)
            }
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    @IBAction func handleSelection(_ sender: UIButton) {
        self.expensesInCategory.isHidden = !self.expensesInCategory.isHidden
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
                return 3
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
        
        if expenses[indexPath.row].category == "Food"{
        cell.textLabel?.text = expenses[indexPath.row].name!
        }
        else{
            return cell
        }

        return cell
    }
    
}
