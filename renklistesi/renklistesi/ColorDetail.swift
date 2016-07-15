//
//  ColorDetail.swift
//  renklistesi
//
//  Created by Erhan BARIŞ on 10/06/15.
//  Copyright (c) 2015 Erhan Baris. All rights reserved.
//

import Foundation
import UIKit

public class ColorDetail : UITableViewCell
{

    @IBOutlet weak var colorName: UILabel!
    
    @IBOutlet weak var red: UILabel!
    @IBOutlet weak var green: UILabel!
    @IBOutlet weak var blue: UILabel!

    @IBOutlet weak var rgb: UILabel!
    
    @IBOutlet weak var detailView: UIView!
}