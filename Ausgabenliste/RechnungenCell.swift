//
//  Table .swift
//  Ausgabenliste
//
//  Created by Christoph Blattgerste on 17.09.16.
//  Copyright © 2016 Christoph Blattgerste. All rights reserved.
//

import Foundation
import UIKit

class RechnungenCell : UITableViewCell {
    
    @IBOutlet weak var verwendungTxt: UILabel!
    @IBOutlet weak var datumTxt: UILabel!
    @IBOutlet weak var betragTxt: UILabel!
    
    
//    override init?(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//        super.init(coder: aDecoder)!
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
