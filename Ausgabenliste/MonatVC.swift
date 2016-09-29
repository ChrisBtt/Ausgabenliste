//
//  ViewController.swift
//  Ausgabenliste
//
//  Created by Christoph Blattgerste on 11.09.16.
//  Copyright © 2016 Christoph Blattgerste. All rights reserved.
//

import UIKit
import CoreData

class MonatViewController: UITableViewController {

    var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    private lazy var monate: NSFetchedResultsController = {
        // The fetch request defines the subset of objects to fetch
        let fetchRequest = NSFetchRequest(entityName: "Monat")
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "month", ascending: true) ]
        // Create the fetched results controller with the fetch request
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        // The delegate can react to changes in the set of fetched objects
        resultsController.delegate = self
        return resultsController
    }()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
           
            case "Rechnungen":
        // Retrieve selected list
                let indexPath = tableView.indexPathForSelectedRow!
                let month = monate.sections![indexPath.row].objects![indexPath.row] as! Monat
            
                let billVC = segue.destinationViewController as! RechnungenViewController
                billVC.month = month
            
            
            case "neuerMonat":
                let editContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
                editContext.parentContext = self.context
            
                let createMonatVC = (segue.destinationViewController as! UINavigationController).topViewController as! CreateMonatViewController
//                let createMonatVC = segue.destinationViewController as! CreateMonatViewController
                createMonatVC.context = editContext
            
        default:
            break
        }
    }
    
    @IBAction func unwindToUbersicht (segue: UIStoryboardSegue) {
        if segue.identifier! == "saveMonat" {
            do {
                try context.save()
            } catch {
                print("Failed saving context: \(error)")
            }

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try monate.performFetch()
        } catch {
            print("Failed fetching objects: \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func calculateSum(bills: [Float]) -> Float {
//        if bills.count > 0 {
//            var sum : Float
//            for bill in bills {
//                sum = 0.0
//                sum += bill
//            }
//            return sum
//        } else {
//            return 0.0
//        }
//    }

}


extension MonatViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return monate.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = monate.sections![section]
        return section.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("details", forIndexPath: indexPath)
        let monat = monate.sections![indexPath.section].objects![indexPath.row] as! Monat
        cell.textLabel?.text = monat.month
        cell.detailTextLabel?.text = String(monat.details!.count)
        return cell
    }
    
}

// Extension for Fetched Results Controller Delegate

extension MonatViewController: NSFetchedResultsControllerDelegate {
        
        func controllerWillChangeContent(controller: NSFetchedResultsController) {
            tableView.beginUpdates()
        }
        
        func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
            switch(type) {
            case .Insert:
                if let newIndexPath = newIndexPath {
                    tableView.insertRowsAtIndexPaths([ newIndexPath ], withRowAnimation:.Automatic)
                }
            case .Delete:
                if let indexPath = indexPath {
                    tableView.deleteRowsAtIndexPaths([ indexPath ], withRowAnimation: .Automatic)
                }
            case .Update, .Move where newIndexPath == indexPath:
                if let indexPath = indexPath {
                    tableView.reloadRowsAtIndexPaths([ indexPath ], withRowAnimation: .Automatic)
                }
            case .Move:
                if let indexPath = indexPath, let newIndexPath = newIndexPath where newIndexPath != indexPath {
                    tableView.moveRowAtIndexPath(indexPath, toIndexPath: newIndexPath)
                }
            }
        }
        
        func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
            switch(type) {
            case .Insert:
                tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
            case .Delete:
                tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
            default:
                break
            }
        }
        
        func controllerDidChangeContent(controller: NSFetchedResultsController) {
            tableView.endUpdates()
        }
        
}

