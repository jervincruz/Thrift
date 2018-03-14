//
//  TestVC.swift
//  Thrift
//
//  Created by Jervin Cruz on 3/14/18.
//  Copyright © 2018 Jervin Cruz. All rights reserved.
//

import UIKit

class TestVC : UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
//    stackView.setNeedsUpdateConstraints()
//    stackView.updateConstraintsIfNeeded()
//    stackView.setNeedsLayout()
//    stackView.layoutIfNeeded()
        
        self.stackView.convert(stackView.frame, from: stackView.superview)
        

    }
}
