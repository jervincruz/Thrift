//
//  CVCalendarViewController.swift
//  Thrift
//
//  Created by Jervin Cruz on 2/26/18.
//  Copyright © 2018 Jervin Cruz. All rights reserved.
//

import UIKit
import CVCalendar
import CoreData

class CVCalendarViewController : UIViewController {

    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    
    @IBOutlet weak var recordsTableView: UITableView!
    
    var name = ""
    var price = 0.0
    var category = ""
    
    var selectedDay = ""
    var selectedMonth = ""
    var selectedYear = ""
    var selectedDate = ""
    
    private var selectedDayView : DayView!
    var recordsContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var expenses = [Expense]()

    override func viewDidLoad(){
        super.viewDidLoad()
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
        selectedDateConverter()
        loadExpenses()
        
        //print(expenses)
    }
    
    func saveExpense(){
        do {
            try recordsContext.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadExpenses(with request : NSFetchRequest<Expense> = Expense.fetchRequest()){
        let selectedDayPredicate = NSPredicate(format: "date == %@", selectedDate)
        request.predicate = selectedDayPredicate
        do {
            expenses = try recordsContext.fetch(request)
            for expense in expenses {
                print("Day:", expense.day!, "Month:", expense.month!, "Year:", expense.year!)
                name = expense.name!
                price = expense.price
                category = expense.category!
                    print("Name:", name, "$:", price, "Category:", category)
                    print("\(expense.month!)-\(expense.day!)-\(expense.year!)")
            }
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    func selectedDateConverter(){
        selectedDate = selectedDayView.date.commonDescription
        print(selectedDate)
        let dateSeparatedBySpace = selectedDate.replacingOccurrences(of: ",", with: "")
        let selectedDateArray = dateSeparatedBySpace.components(separatedBy: " ")
        
        var selectedDay = selectedDateArray[0].count == 1 ? ("0" + selectedDateArray[0]) : selectedDateArray[0]
        selectedYear = selectedDateArray[2]
        switch selectedDateArray[1] {
            case "January":
                selectedMonth = "01"
            case "February":
                selectedMonth = "02"
            case "March":
                selectedMonth = "03"
            case "April":
                selectedMonth = "04"
            case "May":
                selectedMonth = "05"
            case "June":
                selectedMonth = "06"
            case "July":
                selectedMonth = "07"
            case "August":
                selectedMonth = "08"
            case "September":
                selectedMonth = "09"
            case "October":
                selectedMonth = "10"
            case "November":
                selectedMonth = "11"
            case "December":
                selectedMonth = "12"
            default:
                selectedMonth = "01"
        }
        selectedDate = "\(selectedDay) \(selectedMonth), \(selectedYear)"
    }
    
}

//MARK: - Records TableView

extension CVCalendarViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordsCell", for: indexPath)
        cell.textLabel?.text = expenses[indexPath.row].name!
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.recordsContext.delete(self.expenses[indexPath.row])
            self.expenses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.saveExpense()
            tableView.reloadData()
        }
        return [delete]
    }
}

//MARK: - CVCalendar
extension CVCalendarViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
        selectedDayView = dayView
        selectedDate = selectedDayView.date.commonDescription
        selectedDateConverter()
        loadExpenses()
        
        DispatchQueue.main.async{
            self.recordsTableView.reloadData()
        }
    
    }
    
    func presentationMode() -> CalendarMode {
        return CalendarMode.monthView
    }
    
    func firstWeekday() -> Weekday {
        return Weekday.sunday
    }
    
}
