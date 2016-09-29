//
//  CreateMonatVC.swift
//  Ausgabenliste
//
//  Created by Christoph Blattgerste on 11.09.16.
//  Copyright © 2016 Christoph Blattgerste. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CreateMonatViewController: UIViewController {
    
    var month : Monat!
    
    var context: NSManagedObjectContext!
    
    @IBOutlet var monatTxtField: UITextField!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "saveMonat" {
            let monat = NSEntityDescription.insertNewObjectForEntityForName("Monat", inManagedObjectContext: context) as! Monat
            monat.month = monatTxtField.text ?? "Unnamed Month"
            
            do {
                try context.save()
            } catch {
                print("Failed saving context: \(error)")
            }
        }
    }
}
