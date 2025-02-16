//
//  AlertMessage.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 05/02/2025.
//

import MBProgressHUD
import SwiftMessages

extension UIViewController
{
    
    
    func showLoadingDialog(title:String = "",description:String = "") {
        let indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        indicator.label.text = title
        indicator.isUserInteractionEnabled = false
        indicator.detailsLabel.text = description
        indicator.animationType = .zoomIn
        indicator.areDefaultMotionEffectsEnabled = true
        indicator.show(animated: true)
        
    }
    func hideMyDialog() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}


enum MessageStatus:String {
    case MessageError
    case MessageSuccess
}


extension UIViewController
{
    func displayMessage(titleMsg:String = "" , message: String, messageStatus: MessageStatus) {
        
        let view = MessageView.viewFromNib(layout: MessageView.Layout.messageView)
        
        if messageStatus == MessageStatus.MessageError {
            view.configureTheme(.error)
            view.configureTheme(.error)
            view.configureContent(title: titleMsg, body: message)
            view.button?.isHidden = true
            view.semanticContentAttribute = .forceRightToLeft
            SwiftMessages.show(view: view)
            
        } else if messageStatus == MessageStatus.MessageSuccess{
            view.configureTheme(.success)
            view.configureDropShadow()
            view.configureContent(title: titleMsg, body: message)
            view.button?.isHidden = true
            view.semanticContentAttribute = .forceRightToLeft
            var successConfig = SwiftMessages.defaultConfig
            successConfig.presentationStyle = .top
            successConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
            SwiftMessages.show(config: successConfig, view: view)
        }
        
        
    }
}
