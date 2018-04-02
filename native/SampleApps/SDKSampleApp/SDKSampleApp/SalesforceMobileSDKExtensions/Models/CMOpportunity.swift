//
//  CMOpportunity.swift
//  SFSDKTest2
//
//  Created by Asif Junaid on 3/27/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import Foundation

class CMOpportunityRecords: Codable {
    var records: [CMOpportunity]
    var nextRecordsUrl : String?
    var done : Bool?
}

class CMOpportunity : Codable {
    var Name : String?
    var cm_Agency_Name__r : CMAccount?
    var LeadSource :  String?
    var cm_Campaign_Type__c : String?
}
