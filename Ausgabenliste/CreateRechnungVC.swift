//
//  CreateRechnungVC.swift
//  Ausgabenliste
//
//  Created by Christoph Blattgerste on 11.09.16.
//  Copyright © 2016 Christoph Blattgerste. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CreateRechnungViewController: UIViewController {
    
    var context : NSManagedObjectContext!
    
    var month : Monat!
    
    @IBOutlet weak var datumLabel: UILabel!
   
    @IBOutlet weak var verwendungTxtField: UITextField!
    @IBAction func verwendungTxtAction(sender: AnyObject) {
        self.resignFirstResponder()
    }
    
    @IBOutlet weak var betragTxtField: UITextField!
    @IBAction func betragTxtAction(sender: AnyObject) {
        self.resignFirstResponder()
    }
    @IBAction func saveBtn(sender: AnyObject) {
        if verwendungTxtField.text == nil {
            let alertController = UIAlertController(title: "Angaben fehlen", message: "Bitte einen Verwendungszweck angeben", preferredStyle: .Alert)
            let oKButton = UIAlertAction(title: "OK", style: .Cancel, handler: {_ in })
            alertController.addAction(oKButton)
        } else if betragTxtField.text == "" {
            let alertController = UIAlertController(title: "Angaben fehlen", message: "Bitte eine Ausgabe angeben", preferredStyle: .Alert)
            let oKButton = UIAlertAction(title: "OK", style: .Cancel, handler: {_ in })
            alertController.addAction(oKButton)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "saveRechnung" {
            print("segue fired: saveRechnung")
            let rechnung = NSEntityDescription.insertNewObjectForEntityForName("Rechnungen", inManagedObjectContext: context) as! Rechnungen

//            Save the actual NSDate of today
            
            let currentDate = NSDate()
            let dateFormatter = NSDateFormatter()
            
            dateFormatter.dateFormat = "d.MM.yy"
            let convertedDate = dateFormatter.stringFromDate(currentDate)
            datumLabel.text = convertedDate
            
            rechnung.datum = currentDate
            
//            Write to "verwendung" from textField entry
            
            if verwendungTxtField.text != nil && betragTxtField.text != nil {
                
                rechnung.verwendung = verwendungTxtField.text
                
//            Enter the bills sum from textField entry
                
                rechnung.betrag = Float(betragTxtField.text ?? "0.00")
                
                print(rechnung.verwendung)
                print(rechnung.betrag)
            }
            
            // Save context
            do {
                try context.save()
                print("child context saved")
            } catch {
                print("Failed saving context: \(error)")
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.showDate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func showDate() {
//        let date = NSDate()
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "d.MM.yy"
//        let convertedDate = dateFormatter.stringFromDate(date)
//        datumLabel.text = convertedDate
//    }
    
}
