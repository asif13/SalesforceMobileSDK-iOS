//
//  ViewController.swift
//  SFSDKTest2
//
//  Created by Asif Junaid on 3/22/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import UIKit
import SalesforceSwiftSDK
import SalesforceSDKCore

class LoginViewController: UIViewController {
    let RemoteAccessConsumerKey = "3MVG92H4TjwUcLlK5IhJFd1yGcoIlfNA4RPrC630_HTXPze7mapsarimznWsjo9tJlCjdJY.wTbjsl0gTP0Wt"
    let OAuthRedirectURI        = "testsfdc:///mobilesdk/detect/oauth/done";
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let accounts = SFUserAccountManager.sharedInstance().allUserAccounts()
        
        // Do any additional setup after loading the view, typically from a nib.
        initializeSDK()
        
        //If a user is already logged in.
        if accounts?.count == 1 {
            self.performSegue(withIdentifier: "accountsSegue", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginAction(_ sender: UIButton) {
        ProgressHUD.hud(withMessage: "Logging In")
        SalesforceSwiftSDKManager.shared().launch(withUsername: "aelshafei@emaar.ae.partialDev", password: "salesforce1")
        
    }
    func initializeSDK(){
        
        SalesforceSwiftSDKManager.initSDK()
            .Builder.configure { (appconfig: SFSDKAppConfig) -> Void in
            
                appconfig.oauthScopes = ["api"]
                appconfig.remoteAccessConsumerKey = self.RemoteAccessConsumerKey
                appconfig.oauthRedirectURI = self.OAuthRedirectURI
                
            }.postInit {
         
                SalesforceSwiftSDKManager.shared().appConfig?.url = "https://emaarsales--partialdev.cs82.my.salesforce.com/services/oauth2/token"
                SalesforceSwiftSDKManager.shared().appConfig?.clientSecret = "2287240212404938983"
                SalesforceSwiftSDKManager.shared().appConfig?.sslPiningCertificate = "salesforce_certifcate"
                
            }
            .postLaunch {  [unowned self] (launchActionList: SFSDKLaunchAction) in
              
                let launchActionString = SalesforceSDKManager.launchActionsStringRepresentation(launchActionList)
                SalesforceSwiftLogger.log(type(of:self), level:.info, message:"Post-launch: launch actions taken: \(launchActionString)")
              
                print("LOGGED IN")
                ProgressHUD.dismiss()
                self.performSegue(withIdentifier: "accountsSegue", sender: nil)
                
            }.postLogout {  [unowned self] in
                
                print("Logged out")
                self.navigationController?.popToRootViewController(animated: true)
                
            }.launchError {  [unowned self] (error: Error, launchActionList: SFSDKLaunchAction) in
              
                SFSDKLogger.log(type(of:self), level:.error, message:"Error during SDK launch: \(error.localizedDescription)")
                
            }
            .done()
    }
 
}

