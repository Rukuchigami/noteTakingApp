//
//  MasterViewController.swift
//  noteTakingApp
//
//  Created by Anna Parker on 10/18/16.
//  Copyright © 2016 Anna Parker. All rights reserved.
//

import UIKit

var objects: [String] = [String]()
var currentIndex: Int = 0
var masterView:MasterViewController?
var detailViewController:DetailViewController?

let kNotes:String = "notes"
let BLANK_NOTE:String = "(New Note)"

class MasterViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        masterView = self
        load()
        self.navigationItem.leftBarButtonItem = self.editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MasterViewController.insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
    }//end of viewDidLoad

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        save()
        super.viewWillAppear(animated)
    }//end of view WillAppear
    
    override func viewDidAppear(_ animated: Bool) {
        if objects.count == 0 {
            insertNewObject(self)
        }
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }//end of didReviceMemoryWarning

    func insertNewObject(_ sender: AnyObject) {
        if detailViewController?.detailDescriptionLabel.isEditable == false {
            return
        }
        if objects.count == 0 || objects[0] != BLANK_NOTE {
            objects.insert(BLANK_NOTE, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }//end of objects.count if statement
        currentIndex = 0
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }//end of insert new object

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        detailViewController?.detailDescriptionLabel.isEditable = true
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                currentIndex = (indexPath as NSIndexPath).row
                }
            let object = objects [currentIndex]
            detailViewController?.detailItem = object as AnyObject?
            detailViewController?.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            detailViewController?.navigationItem.leftItemsSupplementBackButton = true
            
        }
    }//end of UIStoryboardSeque

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = objects[(indexPath as NSIndexPath).row]
        cell.textLabel!.text = object
        return cell
    }//end of table cellForRowAt

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }//end of can edit row

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }//end of func table view
    
    override func setEditing(_ editing: Bool, animated: Bool) {
         super.setEditing(editing, animated: animated)
        if editing{
            detailViewController?.detailDescriptionLabel.isEditable = false
            detailViewController?.detailDescriptionLabel.text = " "
            return
        }
        save()
    }//end of set editing function
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        detailViewController?.detailDescriptionLabel.isEditable = false
        detailViewController?.detailDescriptionLabel.text = " "
        save()
    }

    func save(){
        UserDefaults.standard.set(objects, forKey: kNotes)
        UserDefaults.standard.synchronize()
    }//end of save function
    
    func load(){
        if let loadedData = UserDefaults.standard.array(forKey: kNotes) as? [String] {
             objects = loadedData
        }
    }//end of load function

}//end of master view controller

