//
//  MXSErrorController.swift
//  MXSErrorControl
//
//  Created by Maciej Necki on 14/6/18.
//  Copyright © 2018 MYX Systems. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

public class MXSErrorController {
    
    
    //////////////////////////////
    //MARK: Basic Error Info
    private let systemInformation: String = UIDevice.current.systemName +
                                            UIDevice.current.systemVersion +
                                            UIDevice.current.localizedModel +
                                            UIDevice.current.model +
                                            String(describing: UIDevice.current.orientation)
    private let applicationName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
    
    
    //////////////////////////////
    //MARK: Custom Error Info
    public var userVisibleTitle: String
    public var userVisibleInformation: String
    public var reportEmail: String
    public var customErrorInformation: String = ""
    
    //Initialisers
    public init(userVisibleTitle: String, userVisibleInformation: String, reportEmail: String) {
        self.userVisibleTitle = userVisibleTitle
        self.userVisibleInformation = userVisibleInformation
        self.reportEmail = reportEmail
    }
    
    //////////////////////////////
    //MARK: Error Package
    private let newLine = "\n"
    private var fullErrorDescription: String {
        return systemInformation + newLine + customErrorInformation
    }
    
    
    //////////////////////////////
    //MARK: Error Presentation
    
    
    private let currentView = UIApplication.shared.keyWindow?.rootViewController
    
    public func presentAlert() {
        let alertController = UIAlertController(title: userVisibleTitle, message: userVisibleInformation, preferredStyle: .alert)
        
        //Check if mail services are available
        if MFMailComposeViewController.canSendMail() {
            
            //If user wants to report the bug, give an option to send it via email
            alertController.addAction(UIAlertAction(title: "Tell Us", style: .default, handler: { (_) in
                let emailTitle = "Bug Report for \(self.applicationName)"
                let messageBody = self.fullErrorDescription
                let toRecipents = [self.reportEmail]
                let mailComposerView: MFMailComposeViewController = MFMailComposeViewController()
                mailComposerView.mailComposeDelegate = self.currentView as? MFMailComposeViewControllerDelegate
                mailComposerView.setSubject(emailTitle)
                mailComposerView.setMessageBody(messageBody, isHTML: false)
                mailComposerView.setToRecipients(toRecipents)
                
                self.currentView?.present(mailComposerView, animated: true, completion: nil)
            }))
        }
        
        //Just dismiss the alert
        alertController.addAction(UIAlertAction(title: "Carry On", style: .default, handler: nil))
        
        
        currentView?.present(alertController, animated: true)
    }
}

