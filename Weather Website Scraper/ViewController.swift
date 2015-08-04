//
//  ViewController.swift
//  Weather Website Scraper
//
//  Created by Jorge Gallardo on 8/3/15.
//  Copyright © 2015 Jorge Gallardo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func findWeather(sender: AnyObject) {
        let attemptedUrl = NSURL(string: "http://www.weather-forecast.com/locations/" + cityTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        
        if let url = attemptedUrl {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                //check to see if data exists... if it does, set equal to urlContent
                if let urlContent = data {
                    let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                    
                    let websiteArray = webContent!.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                    
                    //check to make sure that the array was created and the html source hasn't been changed
                    if websiteArray.count > 1 {
                        let weatherArray = websiteArray[1].componentsSeparatedByString("</span>")
                        if weatherArray.count > 1 {
                            let weatherSummary = weatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.resultLabel.text = weatherSummary
                            })
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

////allow user to close the keyboard by tapping outside of the keyboard
//override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//    self.view.endEditing(true)
//}
//
////allow user to close the keyboard by pressing the return key
//func textFieldShouldReturn(textField: UITextField) -> Bool {
//    textField.resignFirstResponder() //close the keyboard
//    return true
//}