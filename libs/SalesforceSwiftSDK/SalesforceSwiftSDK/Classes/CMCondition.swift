//
//  CMCondition.swift
//  SFSDKTest2
//
//  Created by Asif Junaid on 3/28/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import Foundation

public enum CMOperator : Int {
    case none = 0
    case In
    case notIn
    case equals
    case notEquals
    case like
    case wildcardLike
    case equalBoolean
    case greaterThan
    case greaterThanOrEqual
    case lessThan
    case lessThanOrEqual
}

public class CMCondition {
    var apiName = ""
    var value = ""
    var customCondition = ""
    var cmOperator : CMOperator = .none
    
    public init(apiName: String,cmOperator : CMOperator,value : String) {
        self.apiName = apiName
        self.value = value
        self.cmOperator = cmOperator
    }
    public static func getQuery(conditions : [CMCondition])->String{
        var query = [String]()
        
        for condtion in conditions {
            //create a subquery based on operator and value
            let subquery = "\(condtion.apiName) \(getValueForOperator(cmOperator: condtion.cmOperator, value: condtion.value))"
            
            query.append(subquery)
            
        }
        return query.joined(separator: " AND ")
    }
    static func getValueForOperator(cmOperator : CMOperator,value : String)->String{
        switch cmOperator {
        case .none:
            return ""
        case .In:
            return "IN \(value)"
        case .notIn:
            return "NOT IN \(value)"
        case .equals:
            return "= '\(value)'"
        case .notEquals:
            return "!= '\(value)'"
        case .like:
            return "LIKE '\(value)'"
        case .wildcardLike:
            return "LIKE '%\(value)%'"
        case .equalBoolean:
            return "= \(value)"
        case .greaterThan:
            return "> \(value)"
        case .greaterThanOrEqual:
            return ">= \(value)"
        case .lessThan:
            return "< \(value)"
        case .lessThanOrEqual:
            return "<= \(value)"
        }
    }
}

