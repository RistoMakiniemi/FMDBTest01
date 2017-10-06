//
//  ViewController.swift
//  FMDBTest01
//
//  Created by Koulutus on 04/10/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//


/*
 tee
 save query update delete*/

import UIKit

class ViewController: UIViewController {

    var dbpath : String = ""
    
    @IBOutlet weak var firstname: UITextField!
    
    @IBOutlet weak var familyname: UITextField!
    
    @IBOutlet weak var phone: UITextField!
    
    @IBOutlet weak var status: UILabel!
    
    @IBAction func SAVEaction(_ sender: UIButton) {
        
        if FileManager.default.fileExists(atPath: dbpath) {
            
            //No Db connection to file found so it must be created now
            let connectionFMDB = FMDatabase(path: dbpath)
            
            // connection to DB must ber opened
            if( connectionFMDB.open()) {
                let sqlstatement = "insert or ignore into person (firstname, familyname, phone) values ('\(self.firstname.text!)','\(self.familyname.text!)','\(self.phone.text!)');"
                
                NSLog(sqlstatement)
                
                let result = connectionFMDB.executeUpdate(sqlstatement, withArgumentsIn: [])
                
                if !result {
                    self.status.text = "SAVE FAILURE!"
                    //connectionFMDB.lastError()
                    //connectionFMDB.lastErrorCode
                    //self.status.text = connectionFMDB.lastErrorMessage()
                }
                
                NSLog(connectionFMDB.debugDescription)
            }
            
            connectionFMDB.close()
        }
    }
    
    @IBAction func LOADaction(_ sender: UIButton) {
        
        if FileManager.default.fileExists(atPath: dbpath) {
            
            //No Db connection to file found so it must be created now
            let connectiontoFMDB = FMDatabase(path: dbpath)
            
            // connection to DB must ber opened
            if( connectiontoFMDB.open()) {
                let sqlstatement = "select firstname, familyname, phone from person where firstname = ('\(self.firstname.text!)');"
                
                NSLog(sqlstatement)
                
                let resultSet : FMResultSet = connectiontoFMDB.executeQuery(sqlstatement, withArgumentsIn: [])!
                
                if resultSet.next() == true {
                    self.familyname.text = resultSet.string(forColumn: "familyname")
                    self.phone.text = resultSet.string(forColumn: "phone")
                }
                else {
                    self.status.text = "LOAD FAILURE!"
                }
                
                NSLog(connectiontoFMDB.debugDescription)
            }
            
            connectiontoFMDB.close()
        }
    }
    
    @IBAction func DELETEaction(_ sender: UIButton) {
        
        if FileManager.default.fileExists(atPath: dbpath) {
            
            //No Db connection to file found so it must be created now
            let connectionFMDB = FMDatabase(path: dbpath)
            
            // connection to DB must ber opened
            if( connectionFMDB.open()) {
                let sqlstatement = "delete from person where firstname = ('\(self.firstname.text!)');"
                
                NSLog(sqlstatement)
                
                let result = connectionFMDB.executeUpdate(sqlstatement, withArgumentsIn: [])
                
                if !result {
                    self.status.text = "SAVE FAILURE!"
                }
                
                NSLog(connectionFMDB.debugDescription)
            }
            
            connectionFMDB.close()
        }
        
    }
    
    @IBAction func UPDATEaction(_ sender: UIButton) {

        if FileManager.default.fileExists(atPath: dbpath) {
            
            //No Db connection to file found so it must be created now
            let connectionFMDB = FMDatabase(path: dbpath)
            
            // connection to DB must ber opened
            if( connectionFMDB.open()) {
                let sqlstatement = "update person set familyname = ('\(self.familyname.text!)'), phone = ('\(self.phone.text!)') where firstname = ('\(self.firstname.text!)');"
                
                NSLog(sqlstatement)
                
                let result = connectionFMDB.executeUpdate(sqlstatement, withArgumentsIn: [])
                
                if !result {
                    self.status.text = "SAVE FAILURE!"
                }
                
                NSLog(connectionFMDB.debugDescription)
            }
            
            connectionFMDB.close()
        }
        
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // We use default filemanager in this exercise
        
        // Find path to database by finding the dokument first
        let pathdummy = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // this path to DB location is set into dokument direcctory root
        // and name ofDB is set as mydatabase.db
        dbpath = pathdummy[0].appendingPathComponent("mydatabase.db").path
        
        NSLog(dbpath)
        
        if !FileManager.default.fileExists(atPath: dbpath) {
            
            //No Db connection to file found so it must be created now
            let connectionFMDB = FMDatabase(path: dbpath)
            
            // connection to DB must ber opened
            if( connectionFMDB.open()) {
                let sqlstatement = "create table if not exists person(id integer primary key autoincrement, firstname text, familyname text, phone integer, unique(firstname,familyname));"
                connectionFMDB.executeStatements(sqlstatement)
                
            }
            NSLog(connectionFMDB.debugDescription)
            
            connectionFMDB.close()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

