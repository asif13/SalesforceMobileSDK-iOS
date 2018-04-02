//
//  CMAccount.swift
//  SFSDKTest2
//
//  Created by Asif Junaid on 3/27/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import Foundation
class CMAccountRecords : Codable {
    var records : [CMAccount]
}
class CMAccount : Codable {
    var Name : String?
}
