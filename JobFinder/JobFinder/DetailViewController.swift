//
//  DetailViewController.swift
//  JobFinder
//
//  Created by Jamie Choi on 4/17/17.
//  Copyright © 2017 Jamie Choi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    //@IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBAction func btnCompanySite(_ sender: Any) {
        let link = detailItem?.company_url
        let app = UIApplication.shared
        let urlAddress = link
        let urlw = URL(string:urlAddress!)
        targetSound.play()
        app.openURL(urlw!)
    }
    
    @IBAction func btnApply(_ sender: Any) {
        let link = detailItem?.url
        let app = UIApplication.shared
        let urlAddress = link
        let urlw = URL(string:urlAddress!)
        targetSound.play()
        app.openURL(urlw!)
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        lblTitle.text = (detailItem?.title)!
        lblLocation.text = (detailItem?.location)!
        lblCompany.text = (detailItem?.company)!
        lblDescription.text = (detailItem?.description)!
        
        let imageName = (detailItem?.company_logo)!
        let imageUrl = URL(string: imageName)
        let bytes = try? Data(contentsOf: imageUrl!)
        
        let image = UIImage(data: bytes!)
        
        imgView.image = image
        imgView.contentMode = .scaleAspectFit
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Job?


}

