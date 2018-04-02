//
//  SFRestResponsePresets.swift
//  SFSDKTest2
//
//  Created by Asif Junaid on 3/26/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import Foundation
import SalesforceSwiftSDK
import SalesforceSDKCore
import PromiseKit

/**
 Update all the Preset values for SalesForceMobileSDK
    1 - Add enum of CMObjectType for salesforce objects used in App
    2 - Update saleforce object api name in getSFObjectType
    3 - Update fields for CMObject
 */

//Update enum with Salesforce object beind used in App.
enum CMObjectType {
    case account
    case lead
    case opportunity
    case contentVersion
}

extension SFRestAPI.SFRestAPIPromises {
    
    /// Get object type of salesforce
    ///
    /// - Parameter type: CMObjectType
    /// - Returns: SFObject type in string
    func getSFObjectType(type : CMObjectType)->String{
        switch type {
            case .account: return "Account"
            case .lead : return "Lead"
            case .opportunity : return "Opportunity"
            case .contentVersion: return "ContentVersion"
        }
    }
    
    /// Returns fields for defined object types
    ///
    /// - Parameter type: CMObject type
    /// - Returns: Fields corresponing to Object type
    func getFieldsForCMObjectType(type : CMObjectType) -> [String]{
        switch type {
        case .account :
            return ["Name"]
        case .opportunity :
            return ["Name","cm_Agency_Name__r.Name","LeadSource","cm_Campaign_Type__c"]
        case .contentVersion:
            return ["Id","VersionData"]
        case .lead:
            return ["Id"]
        }
    }
    /// Used to parse response into a class object
    ///
    /// - Parameters:
    ///   - type: object type
    ///   - response: SFRestResponse fetch from salesforce
    /// - Returns: array of parsed response
    func parseResponseFor(type : CMObjectType , response : SFRestResponse) -> [AnyObject]?{
        switch type {
        case .account:
            let decodedResponse = response.asDecodable(type: CMAccountRecords.self)
            return decodedResponse?.records ?? nil
        case .opportunity :
            let decodedResponse = response.asDecodable(type: CMOpportunityRecords.self)
            return decodedResponse?.records ?? nil
        case .lead:
            break
        case .contentVersion:
            break
        }
        return nil
    }
}


