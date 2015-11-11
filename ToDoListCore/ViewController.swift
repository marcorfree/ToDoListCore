//
//  ViewController.swift
//  ToDoListCore
//
//  Created by Marco Rago on 10/11/15.
//  Copyright © 2015 marcorfree. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var TextField1: UITextField!
    
    @IBOutlet var TableView1: UITableView!
    
    var TDL = [String]()
    
    
    
    
   func loadCoreData() {
    
    let appDel1:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context1:NSManagedObjectContext = appDel1.managedObjectContext
    
    
    let request = NSFetchRequest(entityName: "Activities")
    do {
        let results = try context1.executeFetchRequest(request)

        if !results.isEmpty {
        
        for item in results as! [NSManagedObject] {
            let activity = item.valueForKey("activity") as! String
            TDL.append( activity )
            
        }
        TableView1.reloadData()

        }
    } catch {
        print("There was an error in loading data")
    }
    
    }

    
    func deleteAllCoreData() {
        
        let appDel1:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context1:NSManagedObjectContext = appDel1.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Activities")
        do {
            let fetchedEntities = try context1.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            
            for item in fetchedEntities  {
                context1.deleteObject(item)
            }
        } catch {
             print("There was an error in deleting data")
        }
        
        do {
            try context1.save()
        } catch {
            print("There was an error in deleting data")
        }

    }
    
    
    func addCoreData(newvalue: AnyObject) {

        let appDel1:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context1:NSManagedObjectContext = appDel1.managedObjectContext
        let newActivity = NSEntityDescription.insertNewObjectForEntityForName("Activities", inManagedObjectContext: context1)
        newActivity.setValue(newvalue, forKey: "activity")
        
        do{
        try context1.save()
        }
        catch{
        print("There was an error in adding data")
        }
        
    }
    
    
    func deleteCoreData(itemName: String) {
        
        let appDel1:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context1:NSManagedObjectContext = appDel1.managedObjectContext

        
/*        let predicate = NSPredicate(format: "objectID == %@", objectIDFromNSManagedObject)
        let fetchRequest = NSFetchRequest(entityName: "Activities")
        fetchRequest.predicate = predicate
*/
        let fetchRequest = NSFetchRequest(entityName: "Activities")
        fetchRequest.includesSubentities = false
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"activity == '\(itemName)'")

        do {
            let fetchedEntities = try context1.executeFetchRequest(fetchRequest) as! [NSManagedObject]
          if let entityToDelete = fetchedEntities.first {

            context1.deleteObject(entityToDelete)
        }
        } catch {
        print("There was an error in deleting data (1/2)")
        }
        
        do {
        try context1.save()
        } catch {
        print("There was an error in deleting data (2/2)")
    }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadCoreData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Button1(sender: UIButton) {
        if TextField1.text != "" {
            TDL.append(TextField1.text!)
            TableView1.reloadData()
            addCoreData(TextField1.text!)
            TextField1.text = ""
        
        }
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TDL.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cella = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cella.textLabel?.text = TDL[indexPath.row]
        
        return cella
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            deleteCoreData(TDL[indexPath.row])
            TDL.removeAtIndex(indexPath.row)
            TableView1.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}

