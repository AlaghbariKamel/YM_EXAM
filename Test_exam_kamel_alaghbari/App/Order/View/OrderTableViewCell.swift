//
//  OrderTableViewCell.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 05/02/2025.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    @IBOutlet weak var lbOrderId: UILabel!
    
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbTotalPrice: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    
    
    @IBOutlet weak var imgNav: UIImageView!
    
    var varlbOrderId: String?
    {
        didSet {
            lbOrderId.text = varlbOrderId
        }
    }
    
    var varlbDate: String?
    {
        didSet {
            lbDate.text = varlbDate
        }
    }
    
    
    func flipLogoImage()
    
    {
        if SharedDefault.languageKey == LocalizationManager.LanguageApp.Arabic.rawValue {
            imgNav.image = imgNav.image?.imageFlippedForRightToLeftLayoutDirection()
        }
          
    }
    
    
    var varlbTotalPrice: String?
    {
        didSet {
            
            if let totalPrice = varlbTotalPrice, let doubleTotalPrice = totalPrice.double
            {
                lbTotalPrice.text = totalPrice.roundedDouble(value: doubleTotalPrice)
            }
            else{
                lbTotalPrice.text = varlbTotalPrice
            }
           
        }
    }
    
    var varlbStatus: String?
    {
        didSet {
           
                lbStatus.text = varlbStatus
            
            if(lbStatus.text == DeliveryStatusType.new.rawValue)
            {
                lbStatus.text = DeliveryStatusType.new.description
                lbStatus.textColor = UIColor.init(hexaString: "#29D40F")
                statusView.backgroundColor = UIColor.init(hexaString: "#29D40F")
            }
           else if(lbStatus.text == DeliveryStatusType.delivered.rawValue)
            {
                lbStatus.text = DeliveryStatusType.delivered.description
                lbStatus.textColor = UIColor.init(hexaString: "#707070")
                statusView.backgroundColor = UIColor.init(hexaString: "#707070")
            }
            else if(lbStatus.text == DeliveryStatusType.fullReturn.rawValue)
            {
                
                lbStatus.text = DeliveryStatusType.fullReturn.description
                
                lbStatus.textColor = UIColor.init(hexaString: "#D42A0F")
                statusView.backgroundColor = UIColor.init(hexaString: "#D42A0F")
            }
            else{
                
                lbStatus.textColor = UIColor.init(hexaString: "#004F62")
                statusView.backgroundColor = UIColor.init(hexaString: "#004F62")
            }
        }
    }
    
    @IBOutlet weak var statusView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if imgNav.image != nil
        {
            flipLogoImage()
        }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        if SharedDefault.languageKey == LocalizationManager.LanguageApp.Arabic.rawValue {
           
            self.statusView.roundCorners(corners: [.topLeft,.bottomLeft], radius: 16.0)
        }
        else {
            self.statusView.roundCorners(corners: [.topRight,.bottomRight], radius: 16.0)
        }
     
            
       
         
    }
    
    
    
}
