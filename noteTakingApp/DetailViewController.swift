//
//  DetailViewController.swift
//  noteTakingApp
//
//  Created by Anna Parker on 10/18/16.
//  Copyright © 2016 Anna Parker. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var detailDescriptionLabel: UITextView!

    var detailItem: AnyObject? {
        didSet{
            //Update the View
            self.configureView()
        }
    }//end of detailItem

    func configureView() {
        // Update the user interface for the detail item.
        if objects.count == 0 {
            return
        }
        
        if let label = self.detailDescriptionLabel {
            label.text = objects [currentIndex]
            if label.text == BLANK_NOTE {
                label.text = ""
            }
        }
    }//end of configureView

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        detailViewController = self
        detailDescriptionLabel.becomeFirstResponder()
        detailDescriptionLabel.delegate = self
        self.configureView()
    }//end of ViewDidLoad

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }// end of didRevieceMemoryWarning
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if objects.count == 0{
            return
        }
        objects[currentIndex] = detailDescriptionLabel.text
        if detailDescriptionLabel.text == ""{
         objects[currentIndex] = BLANK_NOTE
        }
        saveAndUpdte()
    }
    
    func saveAndUpdte(){
        masterView?.save()
        masterView?.tableView.reloadData()
    }//end of saveAndUpdate
    
    func textViewDidChange(_ textView: UITextView) {
        objects[currentIndex] = detailDescriptionLabel.text
        saveAndUpdte()
    }//end of text view did change


}//end of UIView Controller

