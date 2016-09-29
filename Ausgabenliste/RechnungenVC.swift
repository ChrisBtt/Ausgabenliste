//
//  RechnungenVC.swift
//  Ausgabenliste
//
//  Created by Christoph Blattgerste on 11.09.16.
//  Copyright © 2016 Christoph Blattgerste. All rights reserved.
//

import UIKit
import CoreData

class RechnungenViewController: UITableViewController {
    
    var month : Monat!
    
    private var context: NSManagedObjectContext {
        return month.managedObjectContext!
    }
    
    lazy var rechnungen: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Rechnungen")
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "datum", ascending: false) ]
        // We can also restrict the set of observed objects with a predicate:
        fetchRequest.predicate = NSPredicate(format: "ubersicht == %@", self.month)
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.month.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = self
        return resultsController
    }()
        
    @IBAction func unwindToRechnungen(segue: UIStoryboardSegue) {
            do {
                try context.save()
                print("parent context saved")
            } catch {
                print("Failed saving context: \(error)")
            }
        do {
            try rechnungen.performFetch()
            print(context)
        } catch {
            print("Failed fetching objects: \(error)")
        }
        tableView.updateConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetch the current content of this month to display it
        do {
            try rechnungen.performFetch()
            print(context)
        } catch {
            print("Failed fetching objects: \(error)")
        }
//        tableView.delegate = self
//        tableView.dataSource = self
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
            case "neueRechnung":
                
                let editContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
                editContext.parentContext = self.context
                
                let editMonat = editContext.objectWithID(month.objectID) as! Monat
                
                let createRechnungVC = (segue.destinationViewController as! UINavigationController).topViewController as! CreateRechnungViewController
                createRechnungVC.context = editContext
                createRechnungVC.month = editMonat
  
        default:
            break
        }
    }
}

extension RechnungenViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return rechnungen.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = rechnungen.sections![section]
        return section.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("cellForRowAtIndexPath method executed")
        let cell = tableView.dequeueReusableCellWithIdentifier("RechnungenCell", forIndexPath: indexPath) as! RechnungenCell
        let rechnung = rechnungen.sections![indexPath.row].objects![indexPath.row] as! Rechnungen
        
//        NSDateFormatter is needed to print out the NSDate Object
        
        cell.verwendungTxt.text = rechnung.verwendung
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "d.MM.yy"
        cell.datumTxt.text = dateFormatter.stringFromDate(rechnung.datum!)
        
        cell.betragTxt.text = String(rechnung.betrag) + " €"
        return cell
    }
}

extension RechnungenViewController {
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let rechnung = rechnungen.sections![indexPath.section].objects![indexPath.row] as! Rechnungen
        context.deleteObject(rechnung)
        do {
            try context.save()
        } catch {
            print("Failed saving context: \(error)")
        }
    }
    
}

extension RechnungenViewController: NSFetchedResultsControllerDelegate {
    
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

