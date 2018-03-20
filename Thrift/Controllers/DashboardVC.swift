//
//  ViewController.swift
//  Thrift
//
//  Created by Jervin Cruz on 2/20/18.
//  Copyright © 2018 Jervin Cruz. All rights reserved.
//

import UIKit
import CoreData
import CircleProgressView
import HexColors

class DashboardVC: UIViewController {
    
    var food = 0.0
    var auto = 0.0
    var utilities = 0.0
    var clothing = 0.0
    var leisure = 0.0
    var misc = 0.0
    var totalCost = 0.0
    var total = 0.0 {
        didSet{
            display()
        }
    }
    
    var vcContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var vcExpenses = [Expense]()
    var barItemPressed = true
    var recordsHidden = true
    var graphHidden = true
    
    let date = Date()
    let dateFormatter = DateFormatter()
    var nameOfMonth : String?
    var month : String?
    var year : String?
    var monthYear : String?

    @IBOutlet weak var foodChart: CircleProgressView!
    @IBOutlet weak var autoChart: CircleProgressView!
    @IBOutlet weak var utilitiesChart: CircleProgressView!
    @IBOutlet weak var clothingChart: CircleProgressView!
    @IBOutlet weak var leisureChart : CircleProgressView!
    @IBOutlet weak var miscChart: CircleProgressView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentMonthYear()
        loadExpenses()
    }

    override func viewWillAppear(_ animated: Bool) {
        // When navigating back from other controllers
        loadExpenses()
        display()
    }

    func loadExpenses(with request : NSFetchRequest<Expense> = Expense.fetchRequest()){
        let predicate = NSPredicate(format: "date CONTAINS %@", monthYear!)
        request.predicate = predicate
        do {
            vcExpenses = try vcContext.fetch(request)
            calculateExpenses()
        } catch {
            fatalError("Error fetching expenses \(error)")
        }
    }
    
    func calculateExpenses(){
        var foodExpenses = 0.0
        var autoExpenses = 0.0
        var utilitiesExpenses = 0.0
        var clothingExpenses = 0.0
        var leisureExpenses = 0.0
        var miscExpenses = 0.0
        
        for expense in vcExpenses {
            switch expense.category {
            case "Food"?:
                food += 1
                foodExpenses += expense.price
            case "Auto"?:
                auto += 1
                autoExpenses += expense.price
            case "Utilities"?:
                utilities += 1
                utilitiesExpenses += expense.price
            case "Clothing"?:
                clothing += 1
                clothingExpenses += expense.price
            case "Leisure"?:
                leisure += 1
                leisureExpenses += expense.price
            case "Misc"?:
                misc += 1
                miscExpenses += expense.price
            default:
                return
            }
        }
        totalCost = foodExpenses + autoExpenses + utilitiesExpenses + clothingExpenses + leisureExpenses + miscExpenses
        total = food + auto + utilities + clothing + leisure + misc
    }
    
    func display(){
        let totalCostString = String(format: "%.2f", self.totalCost)
        self.totalPriceLabel.text! = "$ \(totalCostString)"
        DispatchQueue.main.async{
            self.foodChart.setProgress(self.food/self.total, animated: true)
            self.autoChart.setProgress(self.auto/self.total, animated: true)
            self.utilitiesChart.setProgress(self.utilities/self.total, animated: true)
            self.clothingChart.setProgress(self.clothing/self.total, animated: true)
            self.leisureChart.setProgress(self.leisure/self.total, animated: true)
            self.miscChart.setProgress(self.misc/self.total, animated: true)
        }
    }
 
    func getTodaysDate() -> String{
        let date = Date()
        let calendar = Calendar.current
        
        let year = String(calendar.component(.year, from: date))
        var month = String(calendar.component(.month, from: date))
        var day = String(calendar.component(.day, from: date))
        
        month = month.count == 1 ? "0" + month : month
        day = day.count == 1 ? "0" + day : day

        return "\(day) \(month), \(year)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dashboardToAddExpense" {
            let addExpenseVC = segue.destination as! AddExpenseVC
            addExpenseVC.selectedDate = getTodaysDate()
        }
    }
    
    func getCurrentMonthYear(){
        dateFormatter.dateFormat = "LLLL"
        nameOfMonth = dateFormatter.string(from: date)
        month = String(Calendar.current.component(.month, from: date))
        year = String(Calendar.current.component(.year, from: date))

        month = month?.count == 1 ? "0" + month! : month
        
        monthYear = "\(String(describing: month!)), \(String(describing: year!))"
        self.dateLabel.text! = "\(String(describing: nameOfMonth!)) \(String(describing: year!))"
    }
    
}
