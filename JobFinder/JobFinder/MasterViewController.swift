//
//  MasterViewController.swift
//  JobFinder
//
//  Created by Jamie Choi on 4/17/17.
//  Copyright © 2017 Jamie Choi. All rights reserved.
//

import UIKit
import AVFoundation

var targetSound: AVAudioPlayer! 

class MasterViewController: UITableViewController {
    var objects = [Any]()
    var jobArray = [Job]()
    
    func PopulateJobData() {
        let restURL:URL = URL(string: "https://jobs.github.com/positions.json?description=technology&location=New%20York%20City&full_time=true")!
        
        //Get data from endpoint
        let jsonUrlData = try? Data (contentsOf:restURL)
        
        //debug info: printing the contents in the console window
        print(jsonUrlData ?? "ERROR: No Data To Print. JSONURLData is Nil")
        
        //Serialize data to a dictionary - name value collection
        //Serizlization is converting from one format to another
        if (jsonUrlData != nil){
            
            // Serialize JSON data into array
            let jsonArr = try!JSONSerialization.jsonObject(with: jsonUrlData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
            
            for json in jsonArr as! [[String:AnyObject]] {
                let j = Job()
                j.id = json["id"] as! String
                j.title = json["title"] as! String
                j.location = json["location"] as! String
                j.type = json["type"] as! String
                j.description = json["description"] as! String
                
                let aString = j.description
                
                // Remove HTML tags from description
                let newString = aString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range:nil)
                
                j.description = newString
                
                j.how_to_apply = json["how_to_apply"] as! String
                j.company = json["company"] as! String
                
                if json["company_url"] is NSNull {
                    j.company_url = "none"
                } else {
                    j.company_url = json["company_url"] as! String
                }
                
                if json["company_logo"] != nil && !(json["company_logo"] is NSNull) {
                    j.company_logo = json["company_logo"] as! String
                } else {
                    j.company_logo = "https://simplehq.co/wp-content/uploads/2017/02/image-placeholder-blue.png"
                }
                
                j.url = json["url"] as! String
                
                jobArray.append(j)
            }//end for
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        PopulateJobData()
        
        let selectedSound = "click_04"
        
        targetSound = try? AVAudioPlayer (contentsOf:URL(fileURLWithPath:Bundle.main.path(forResource: selectedSound, ofType: "wav")! ))
        
    }

    /*override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*func insertNewObject(_ sender: Any) {
        objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }*/

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let j = jobArray[indexPath.row]
                
                //destination controller and set value so that the selected object goes into the detailcontroller on that variable
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                
                controller.detailItem = j
                
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let j = jobArray[indexPath.row]
        
        cell.textLabel!.text = j.title
        cell.detailTextLabel!.text = j.company
        
        let imageName = j.company_logo
        let imageUrl = URL(string: imageName)
        let bytes = try? Data(contentsOf: imageUrl!)
        
        var image = UIImage(data: bytes!)
        
        image = self.resizeImage(image: image!, targetSize: CGSize(width:44.0, height:90.0))
        
        cell.imageView?.image = image
        cell.imageView?.contentMode = .scaleAspectFit
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    //Resizes image to set size
    func resizeImage(image: UIImage, targetSize:CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio = targetSize.width / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize : CGSize
        if (widthRatio > heightRatio) {
            newSize = CGSize(width : size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(x:0, y:0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in:rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

    /*override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }*/


}

