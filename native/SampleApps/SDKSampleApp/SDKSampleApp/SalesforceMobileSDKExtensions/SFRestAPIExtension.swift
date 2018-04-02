//
//  CMRestAPIPromisesExtension.swift
//  SFSDKTest2
//
//  Created by Asif Junaid on 3/26/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//
import SalesforceSwiftSDK
import SalesforceSDKCore
import PromiseKit



extension SFRestAPI.SFRestAPIPromises {
    
    /**
     A factory method for create object request.
     ```
     restApi.Promises.create(objectType: objectType, fieldList: ["Name": "salesforce.com", "TickerSymbol": "CRM"])
     .then { (request) in
     restApi.send(request)
     }
     ```
     - parameters:
     - objectType: Type of object
     - fields: Field list as Dictionary.
     - Returns: SFRestRequest wrapped in a promise.
     */
    func create(objectType: CMObjectType, fields: [String : Any]) -> Promise<SFRestRequest> {
        
        let SFObjectType = getSFObjectType(type: objectType)
        
        return create(objectType: SFObjectType, fields: fields)
    }
    
    /**
     A factory method for upsert object request.
     ```
     restApi.Promises.upsert(objectType: objectType,externalIdField:"",externalId: "1000", fieldList: {Name: "salesforce.com", TickerSymbol: "CRM"})
     .then { (request) in
     restApi.send(request)
     }
     ```
     - parameters:
     - objectType: Type of object.
     - externalIdField: Identifier for field.
     - fields: Field list as Dictionary.
     - Returns: SFRestRequest wrapped in a promise.
     */
    func upsert(objectType: CMObjectType,externalIdField: String, externalId: String, fieldList: Dictionary<String,Any>?) -> Promise<SFRestRequest> {
        
        let SFObjectType = getSFObjectType(type: objectType)
        
        return upsert(objectType: SFObjectType, externalIdField: externalIdField, externalId: externalId, fieldList: fieldList)
        
    }
    /**
     A factory method for update object request.
     ```
     restApi.Promises.update(objectType: objectId: "1000", fieldList: fieldList,ifUnmodifiedSince:sinceDate)
     .then { (request) in
     restApi.send(request)
     }
     
     ```
     - parameters:
     - objectType: Type of object.
     - objectId: Identifier of the field.
     - fields: Field list as Dictionary.
     - ifUnmodifiedSince: update if unmodified since date.
     - Returns: SFRestRequest wrapped in a promise.
     */
    func update(objectType: CMObjectType,objectId: String,fieldList: [String: Any]?) -> Promise<SFRestRequest> {
        let SFObjectType = getSFObjectType(type: objectType)
        
        return update(objectType: SFObjectType, objectId: objectId, fieldList: fieldList)
    }
    /**
     A factory method for update object request.
     
     - parameters:
     - objectType: Type of object.
     - objectId: Identifier of the field.
     - fields: Field list as Dictionary.
     - Returns: SFRestRequest.
     */
    func updateRequest(objectType: CMObjectType,objectId: String,fieldList: [String: Any]?)->SFRestRequest{
        let SFObjectType = getSFObjectType(type: objectType)
        return update(objectType: SFObjectType, objectId: objectId, fieldList: fieldList)
    }
    
    /// A factory method for querying object request, returns parsed data.
    ///
    /// - Parameters:
    ///   - type: Object Type
    ///   - fields: array of fields
    ///   - conditions: where conditions
    /// - Returns: AnyObject wrapped in a promise.
    func query(type : CMObjectType , fields: [String] = [], conditions : [CMCondition] = [],path : String? = nil) -> Promise<[AnyObject]?>{
        
        return  Promise(.pending) {  resolver in
            self.query(type: type, fields: fields, conditions: conditions).then { request  in
                self.send(request: request)
                }.done({ (response) in
                    if let parsedResponse = self.parseResponseFor(type: type, response: response) {
                        resolver.fulfill(parsedResponse)
                    }else {
                        let error = NSError(domain: "Could not parse fetched response", code: 0, userInfo: nil)
                        resolver.reject(error)
                    }
                }).catch({ (error) in
                    resolver.reject(error)
                    
                })
        }
    }
    /// A private method for querying object request.
    ///
    /// - Parameters:
    ///   - type: Object Type
    ///   - fields: array of fields
    ///   - conditions: where conditions
    /// - Returns: SFRestRequest wrapped in a promise.
    private func query(type : CMObjectType , fields: [String] = [], conditions : [CMCondition] = []) -> Promise<SFRestRequest> {
        
        let SFObjectType = getSFObjectType(type: type)
        
        //join fields with comma separator
        var  queryForFields = ""
        if fields.count > 0 {
            queryForFields = fields.joined(separator: ",")
        }else {
            //get default fields from presets
            let defaulFields = getFieldsForCMObjectType(type: type)
            queryForFields = defaulFields.joined(separator: ",")
        }
        
        //get where conditions
        var whereConditions = ""
        if conditions.count > 0 {
            whereConditions = CMCondition.getQuery(conditions: conditions)
        }
        
        let selectQuery = "select \(queryForFields)"
        let whereQuery = whereConditions != "" ? "where \(whereConditions)" : ""
        let fromQuery = "from \(SFObjectType)"
        
        let soqlQuery = "\(selectQuery) \(fromQuery) \(whereQuery)"
        return query(soql:soqlQuery)
    }
    
    
    /// Query More function , to fetch more than 2000 records with Promises
    ///
    /// - Parameters:
    ///   - type:  object type
    ///   - fields: fields to be fetched
    ///   - conditions: conditions: where conditions
    ///   - path: in case of query more, we get a path to fetch more data
    /// - Returns: Promise to be resolved to fetched data
    func queryMore(type : CMObjectType , fields: [String] = [], conditions : [CMCondition] = [],path : String? = nil) -> Promise<[AnyObject]?>{
        
        self.queryMoreData = [AnyObject]()
        
        return  Promise(.pending) {  resolver in
            self.queryMore(type: type, path: nil, successblock: { (responses) in
                resolver.fulfill(responses)
            }, failBlock: { (error) in
                resolver.reject(error)
            })
        }
    }
    
    /// A private to query more than 2000 records
    ///
    /// - Parameters:
    ///   - type: object type
    ///   - fields: fields to be fetched
    ///   - conditions: where conditions
    ///   - path: in case of query more, we get a path to fetch more data
    ///   - successblock: succes block
    ///   - failBlock: fail block
    private func queryMore(type : CMObjectType , fields: [String] = [], conditions : [CMCondition] = [],path : String?,successblock : @escaping (([AnyObject])->()) ,failBlock : @escaping ((Error)->())){
        
        //select request based on if path is available
        let request = path == nil  ? query(type: type, fields: fields, conditions: conditions) : self.queryMoreRequest(forQuery: [:], path: path ?? "")
        
        request.then { request  in
            self.send(request: request)
            }.done { (response) in
                
                //Parse response and add it to already fetched data
                if let parsedResponse =  self.parseResponseFor(type: type, response: response){
                    self.queryMoreData = self.queryMoreData + parsedResponse
                }
                
                let arrays = response.asJsonDictionary()
                
                //parse data to check if more data should be queried
                guard let done = arrays["done"] as? Bool else { return }
                guard done == true else {
                    if let path = arrays["nextRecordsUrl"] as? String{
                        //query again
                        self.queryMore(type: type, path: path, successblock: successblock, failBlock: failBlock)
                        
                    }
                    return
                }
                
                successblock(self.queryMoreData)
                
            }.catch { (error) in
                failBlock(error)
        }
    }
}


