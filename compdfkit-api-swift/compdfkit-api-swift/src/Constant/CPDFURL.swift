//
//  CPDFURL.swift
//  compdfkit-api-swift
//

#if os(iOS)
import Foundation
#else
import Cocoa
#endif

public class CPDFURL: NSObject {
    public static let API_V1_OAUTH_TOKEN       = "v1/oauth/token"
    public static let API_V1_CREATE_TASK       = "v1/task/"
    public static let API_V1_TOOL_SUPPORT      = "v1/tool/support"
    public static let API_V1_FILE_INFO         = "v1/file/fileInfo"
    public static let API_V1_ASSET_INFO        = "v1/asset/info"
    public static let API_V1_TASK_LIST         = "v1/task/list"
    public static let API_V1_UPLOAD_FILE       = "v1/file/upload"
    public static let API_V1_EXECUTE_TASK      = "v1/execute/start"
    public static let API_V1_TASK_INFO         = "v1/task/taskInfo"
}
