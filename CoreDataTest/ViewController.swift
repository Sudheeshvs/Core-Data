//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Sudheesh on 1/8/16.
//  Copyright © 2016 DevelopScripts. All rights reserved.
//

import UIKit
import CoreData
//For Doubts

//http://www.raywenderlich.com/115695/getting-started-with-core-data-tutorial
class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    var people = [NSManagedObject]()
    var name : String = "Checking in Git Only"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"The List\""
        tableview.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        //2
        let fetchRequest = NSFetchRequest(entityName: "Person")
        //3
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            people = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return people.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            let cell =
            tableView.dequeueReusableCellWithIdentifier("Cell")
            let person = people[indexPath.row]
            cell!.textLabel!.text = person.valueForKey("name") as? String
            return cell!
    }
    
    @IBAction func addName(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Name",
            message: "Add a new name",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default,
            handler: { (action:UIAlertAction) -> Void in
                let textField = alert.textFields!.first
                self.saveName(textField!.text!)
                self.tableview.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction) -> Void in
        }
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
    }
    
    func saveName(name: String) {
     
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Person",
            inManagedObjectContext:managedContext)
        let person = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        person.setValue(name, forKey: "name")
        //4
        do {
            try managedContext.save()
            //5
            people.append(person)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

