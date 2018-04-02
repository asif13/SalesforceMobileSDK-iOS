//
//  AccountsViewController.swift
//  SFSDKTest2
//
//  Created by Asif Junaid on 3/22/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import UIKit
import PromiseKit
import SalesforceSwiftSDK
import SalesforceSDKCore

class OpportunitiesViewController: UIViewController {
    var dataRows = [CMOpportunity]()

    @IBOutlet weak var opportunitiesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchOpportunities()
//        fetchOpportunitiesWithQueryMore()
        opportunitiesTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Batch update multiple request
    func batchUpdateRecords(){
        ProgressHUD.hud(withMessage: "Updating")
       
        let restApi = SFRestAPI.sharedInstance()

        let request1 =
            restApi.Promises.updateRequest(objectType: .account, objectId: "0013E00000mTiSCQA0", fieldList: ["PersonMobilePhone":"7921799"])
        
        let request2 = restApi.Promises.updateRequest(objectType: .account, objectId: "0013E00000lpYh0QAE", fieldList: ["PersonMobilePhone":"7921799"])

        //send all the request
        restApi.Promises.batch(requests: [request1,request2], haltOnError: false).then {  request  in
            restApi.Promises.send(request: request)
            }.done { [unowned self] response in
                let data = response.asJsonDictionary()

                print(data)

                SalesforceSwiftLogger.log(type(of:self), level:.debug, message:"request:didLoadResponse: #records: \(data.count)")

            }.catch { error in
                SalesforceSwiftLogger.log(type(of:self), level:.debug, message:"Error: \(error)")
            }.finally {
                ProgressHUD.dismiss()
        }
    }
    
    /// Calls describe method to fetch inter field dependencies
    func describeLeads(){
        ProgressHUD.hud(withMessage: "Loading")

        let restApi = SFRestAPI.sharedInstance()
        restApi.Promises.describe(objectType: "Lead").then { request in
            restApi.Promises.send(request: request)
            }.done { (response) in
                print(response.asJsonDictionary())
                
            }.catch { (error) in
                SalesforceSwiftLogger.log(type(of:self), level:.debug, message:"Error: \(error)")
            }.finally {
                ProgressHUD.dismiss()
        }
    }
    /// Fetch opportunites with given conditions
    func fetchOpportunities(){
        ProgressHUD.hud(withMessage: "Loading")

        let restApi = SFRestAPI.sharedInstance()
        //Create a search condition
        let searchWithNameCondition = CMCondition(apiName: "Name", cmOperator: CMOperator.notIn, value: "Mohammed")
        
        restApi.Promises
            .query(type: .opportunity,conditions:[searchWithNameCondition]).done { [unowned self] response in
                if let opportunities = response as? [CMOpportunity] {
                    self.dataRows = opportunities
                }
                
                print(self.dataRows)
                SalesforceSwiftLogger.log(type(of:self), level:.debug, message:"request:didLoadResponse: #records: \(self.dataRows.count)")
                DispatchQueue.main.async(execute: {
                    self.opportunitiesTableView.reloadData()
                })
            }.catch { error in
                SalesforceSwiftLogger.log(type(of:self), level:.debug, message:"Error: \(error)")
            }.finally {
                ProgressHUD.dismiss()
        }
    }
    func fetchOpportunitiesWithQueryMore(){
        ProgressHUD.hud(withMessage: "Loading")
        let restApi = SFRestAPI.sharedInstance()
        
        restApi.Promises.queryMore(type: .opportunity).done { (results) in
            if let opportunites = results as? [CMOpportunity] {
                self.dataRows = opportunites
            }
            print(self.dataRows.count)
            
            DispatchQueue.main.async(execute: {
                self.opportunitiesTableView.reloadData()
            })
            ProgressHUD.dismiss()
            }.catch { (error) in
                print(error)
                ProgressHUD.dismiss()
        }
    }
    
    /// Download content given contentDocument id and version number
    func downladFile(){
        ProgressHUD.hud(withMessage: "Downloading File")
        let restApi = SFRestAPI.sharedInstance()
        restApi.Promises.downloadContentVersion(contentDocumentId: "0693E000000DQn1QAG", versionNumber: "1").then { (request) in
            restApi.Promises.send(request: request)
            }.done { (response) in
                if let data = response.data{
                    let image = UIImage(data: data)
                    let imageView = UIImageView(image: image)
                    imageView.frame = self.view.frame
                    self.view.addSubview(imageView)
                }
            }.catch { (error) in
                SalesforceSwiftLogger.log(type(of:self), level:.debug, message:"Error: \(error)")
            }.finally {
                ProgressHUD.dismiss()
        }
    }
    @IBAction func logOut(_ sender: UIButton) {
        SFUserAccountManager.sharedInstance().logout()
    }
    
    @IBAction func updateAction(_ sender: UIButton) {
        batchUpdateRecords()
    }
    @IBAction func describeAction(_ sender: UIButton) {
        describeLeads()
    }
    @IBAction func downloadAction(_ sender: UIButton) {
        downladFile()
    }
    
   
}
extension OpportunitiesViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier:"cell") else {
            return UITableViewCell()
        }
        
        // Configure the cell to show the data.
        let obj = dataRows[indexPath.row]
        cell.textLabel!.text = obj.Name
    
        return cell
    }
}
