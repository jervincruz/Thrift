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
    
    
    private var selectedDay : DayView!
    var recordsContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var expenses = [Expense]()
    var selectedDate = ""

    override func viewDidLoad(){
        super.viewDidLoad()
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
        loadExpenses()
        
        selectedDate = selectedDay.date.commonDescription
        print(selectedDate)
        print(expenses)
    }
    
    func loadExpenses(with request : NSFetchRequest<Expense> = Expense.fetchRequest()){
        
        let predicate = NSPredicate(format: "date == %@", selectedDate)
        request.predicate = predicate
        do {
            expenses = try recordsContext.fetch(request)
            for expense in expenses {
                name = expense.name!
                price = expense.price
                category = expense.category!
                print("Name: ", expense.name!)
                print("Price: ", expense.price)
                print("Category: ", expense.category!)
            }
        } catch {
            print("Error fetching data from context \(error)")
        }
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
}

//MARK: - CVCalendar
extension CVCalendarViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
        selectedDay = dayView
        selectedDate = selectedDay.date.commonDescription
        print(selectedDate)
        loadExpenses()
        
        DispatchQueue.main.async{
            self.recordsTableView.reloadData()
        }
    
    }
    
    func presentationMode() -> CalendarMode {
        return CalendarMode.monthView
    }
    
    func firstWeekday() -> Weekday {
        return Weekday.monday
    }
    
}
