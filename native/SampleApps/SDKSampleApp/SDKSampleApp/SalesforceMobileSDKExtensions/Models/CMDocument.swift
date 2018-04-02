//
//  CMDocument.swift
//  SFSDKTest2
//
//  Created by Asif Junaid on 3/29/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import Foundation
class CMDocumentRecords: Codable {
    var records: [CMDocument]
}

class CMDocument : Codable {
    var Id : String
    var VersionData : String
}
