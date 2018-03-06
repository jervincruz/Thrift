//
//  OverviewViewController.swift
//  Thrift
//
//  Created by Jervin Cruz on 2/26/18.
//  Copyright © 2018 Jervin Cruz. All rights reserved.
//

import UIKit
import Charts
import CoreData
import CircleProgressView

class OverviewViewController : UIViewController, ChartViewDelegate {
    
    let days = ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"]
    let dollars1 : [Double] = [30, 50, 10, 0, 70, 80, 20]
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var weeklyNumbers : [Double] = []
    var orderedDates = [String]()
    var dateToExpense = [String:Double]()
    var weekday = Date()
    var expenses = [Expense]()
    var weekExpense = [String : Double]()
    var yearMonthDay : [String] = []
    
    var food = 0.0
    var auto = 0.0
    var utilities = 0.0
    var clothing = 0.0
    var leisure = 0.0
    var misc = 0.0
    var totalCost = 0.0
    var total = 0.0{
        didSet{
            loadCharts()
        }
    }
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var foodChart: CircleProgressView!
    @IBOutlet weak var autoChart: CircleProgressView!
    @IBOutlet weak var utilitiesChart: CircleProgressView!
    @IBOutlet weak var clothingChart: CircleProgressView!
    @IBOutlet weak var leisureChart: CircleProgressView!
    @IBOutlet weak var miscChart: CircleProgressView!
    @IBOutlet weak var chartControl: UISegmentedControl!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.lineChartView.delegate = self
        self.lineChartView.chartDescription?.text! = "Tap node for details"
        self.lineChartView.chartDescription?.textColor = UIColor.white
        self.lineChartView.gridBackgroundColor = UIColor.darkGray
        self.lineChartView.noDataText = "No data provided"
        self.lineChartView.rightAxis.enabled = false
        self.lineChartView.xAxis.labelPosition = .bottom
        self.lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        
        /** Load Line Chart First **/
        loadExpenses()
        weeklyData()
    
        /** Load Progress Chart (Week) **/
        let weekPredicate = NSPredicate(format: "date == %@ OR date == %@ OR date == %@ OR date == %@ OR date == %@  OR date == %@ OR date == %@", orderedDates[0], orderedDates[1], orderedDates[2], orderedDates[3], orderedDates[4], orderedDates[5], orderedDates[6])
        loadExpenses(weekPredicate)
        loadCharts()
    }
    
    func loadExpenses(with request : NSFetchRequest<Expense> = Expense.fetchRequest(), _ predicate : NSPredicate? = nil){
        request.predicate = predicate
        do{
            expenses = try context.fetch(request)
            calculateExpenses()
        }
        catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    // MARK: - Load Circle Progress View [Day,Week,Year]
    func loadCharts(){
        DispatchQueue.main.async{
            self.foodChart.setProgress(self.food/self.total, animated: true)
            self.autoChart.setProgress(self.auto/self.total, animated: true)
            self.utilitiesChart.setProgress(self.utilities/self.total, animated: true)
            self.clothingChart.setProgress(self.clothing/self.total, animated: true)
            self.leisureChart.setProgress(self.leisure/self.total, animated: true)
            self.miscChart.setProgress(self.utilities/self.total, animated: true)
        }
    }
    
    func calculateExpenses(){
        var foodExpenses = 0.0
        var autoExpenses = 0.0
        var utilitiesExpenses = 0.0
        var clothingExpenses = 0.0
        var leisureExpenses = 0.0
        var miscExpenses = 0.0
        
        for expense in expenses {
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
        print("Total:", total)
        print("Food: \(food) Auto: \(auto) Utilities: \(utilities) Clothing: \(clothing) Leisure: \(leisure) Misc: \(misc)")
    }
    
    /** Create This Week's Days **/
    func dateExpenses(){
        var nextDay = Date().startOfWeek
        print("IN DATE EXPENSES")
        for _ in 0..<7{
            print("String:",nextDay!)
            dateToExpense.updateValue(0.0, forKey: String(describing: nextDay!) )
            nextDay = Calendar.current.date(byAdding: .day, value: 1, to: nextDay!)!
        }
    }
    
    // MARK: - Line Chart
    func weeklyData(){
        var nextDay = Date().startOfWeek
        print("Start Day:", nextDay!)
        for _ in 0..<7 {
            let separatedDate = String(describing: nextDay!).components(separatedBy: " ")
            let yearMonthDay = separatedDate[0].components(separatedBy: "-") // ["2018", "03", "01"]
            let keyYear = separatedDate
            let keyDate = "\(yearMonthDay[2]) \(yearMonthDay[1]), \(yearMonthDay[0])"
            orderedDates.append(keyDate)
            print(orderedDates)
            nextDay = Calendar.current.date(byAdding: .day, value: 1, to: nextDay!)! // Go to next day
        }
        computeDayTotals()
    }
    
    
    func computeDayTotals(){
        for specificDay in orderedDates{
            weekExpense.updateValue(0.0, forKey: specificDay) // Initialize all days to $0 for each day
        }
        
        for (key,value) in weekExpense{
            print("Key:", key)
        }
        
        for expense in expenses {
            print("Expense Date:", expense.date!)
            if orderedDates.contains(expense.date!) {
                print("YUP IT HAS THE KEY")
                print("Old Price:", weekExpense[expense.date!]!)
                weekExpense[expense.date!] = weekExpense[expense.date!]! + expense.price // update price
                print("New Price:", weekExpense[expense.date!]!)
            }
        }
        setChartData(days)
    }
    
    // MARK: - Toggle Day,Week,Year Chart
    @IBAction func controlTriggered(_ sender: UISegmentedControl) {
        food = 0.0
        auto = 0.0
        utilities = 0.0
        clothing = 0.0
        leisure = 0.0
        misc = 0.0
        switch chartControl.selectedSegmentIndex{
        case 0: // Day
            let currentDayNumber = Calendar.current.component(.weekday, from: Date()) - 1
            let date = orderedDates[currentDayNumber]
            let dayPredicate = NSPredicate(format: "date == %@", date)
            
            loadExpenses(dayPredicate)
            loadCharts()
        case 1: // Week
            print(orderedDates)
            let weekPredicate = NSPredicate(format: "date == %@ OR date == %@ OR date == %@ OR date == %@ OR date == %@  OR date == %@ OR date == %@", orderedDates[0], orderedDates[1], orderedDates[2], orderedDates[3], orderedDates[4], orderedDates[5], orderedDates[6])
            loadExpenses(weekPredicate)
            loadCharts()
        case 2: // Year
            let yearPredicate = NSPredicate(format: "year = %@", "2018")
            loadExpenses(yearPredicate)
            loadCharts()
        default:
            break;
        }
    }
    
    
    // Line Chart Data
    func setChartData(_ days : [String]){
        // 1 - creating an array of data entries
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0..<days.count{
            print("ENTERED")
            print(weekExpense)
            if weekExpense[orderedDates[i]] != nil{
                print(weekExpense[orderedDates[i]]!)
                yVals1.append(ChartDataEntry(x: Double(i), y: weekExpense[orderedDates[i]]!))
            }
        }
        
        // 2 - create a data set with our array
        let set1 : LineChartDataSet = LineChartDataSet(values: yVals1, label: "First Set")
        set1.axisDependency = .left // line will correlate with left axis values
        set1.setColor(UIColor.blue	.withAlphaComponent(0.5))
        set1.setCircleColor(UIColor.red)
        set1.lineWidth = 2.0
        set1.circleRadius = 6.0 // the radius of the node circle
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor.red
        set1.highlightColor = UIColor.white
        set1.drawCircleHoleEnabled = true
        
        // 3 - create an array to store our LineChartDataSet
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        
        // 4 - pass our months in for our x-axis label value along with our datasets
        let data : LineChartData = LineChartData(dataSets: dataSets)
        data.setValueTextColor(UIColor.white)
        
        // 5 - finally set our data
        self.lineChartView.data = data
    }
}

extension Calendar {
    static let gregorian = Calendar(identifier: .gregorian)
}
extension Date {
    var startOfWeek: Date? {
        return Calendar.gregorian.date(from: Calendar.gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
    }
}
