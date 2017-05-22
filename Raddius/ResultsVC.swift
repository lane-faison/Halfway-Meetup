//
//  ResultsVC.swift
//  Raddius
//
//  Created by Lane Faison on 5/21/17.
//  Copyright © 2017 Lane Faison. All rights reserved.
//

import UIKit
import MapKit

class ResultsVC: UIViewController {
    
    var positions: Positions!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("######")
        print(positions.thisUsersLocation)
        print(positions.otherUsersLocation)
        print("######")

        // Do any additional setup after loading the view.
    }

}
