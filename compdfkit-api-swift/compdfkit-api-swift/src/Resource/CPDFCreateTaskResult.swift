//
//  CPDFCreateTaskResult.swift
//  compdfkit-api-swift
//

#if os(iOS)
import Foundation
#else
import Cocoa
#endif

public class CPDFCreateTaskResult: NSObject {
    public var taskId: String?
    public var errorDesc: String?
    
    convenience init(dict: [String : Any]) {
        self.init()
        
        self.taskId = dict["taskId"] as? String
    }
}
