//
//  FormRecognizer.swift
//  compdfkit-api-swift
//

#if os(iOS)
import Foundation
#else
import Cocoa
#endif

private let public_key = "x"
private let secret_key = "x"
class FormRecognizer: NSObject {
    private static var client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)
    
    class func entrance() {
        // Create a task
        self.client.createTask(url: CPDFDocumentAI.TABLEREC) { taskModel in
            guard let taskId = taskModel?.taskId else {
                Swift.debugPrint(taskModel?.errorDesc ?? "")
                return
            }
            
            // upload File
            let group = DispatchGroup()
            group.enter()
            let path = Bundle.main.path(forResource: "IMG_00001(2)", ofType: "jpg")
            self.client.uploadFile(filepath: path!, params: [CPDFFileUploadParameterKey.lang.string():"auto"], taskId: taskId) { uploadFileModel in
                if let errorInfo = uploadFileModel?.errorDesc {
                    Swift.debugPrint(errorInfo)
                }
                group.leave()
            }
            
            group.notify(queue: .main) {
                // execute Task
                self.client.processFiles(taskId: taskId) { processFileModel in
                    if let errorInfo = processFileModel?.errorDesc {
                        Swift.debugPrint(errorInfo)
                    }
                    // get task processing information
                    self.client.getTaskInfo(taskId: taskId) { taskInfoModel in
                        guard let _model = taskInfoModel else {
                            Swift.debugPrint("error:....")
                            return
                        }
                        if (_model.isFinish()) {
                            _model.printInfo()
                        } else if (_model.isRuning()) {
                            Swift.debugPrint("Task incomplete processing")
//                            self.client.getTaskInfoComplete(taskId: taskId) { isFinish, params in
//                                Swift.debugPrint(params)
//                            }
                        } else {
                            Swift.debugPrint("error: \(_model.errorDesc ?? "")")
                        }
                    }
                }
//                self.client.resumeTask(taskId: _taskId) { isFinish, params in
////                    Swift.debugPrint(params)
//                    var success = true
//                    var downloadUrl: String?
//                    if let datas = params.first as? [[String : Any]] {
//                        for data in datas {
//                            let result = CPDFResultFileInfo(dict: data)
//                            if (result.status == "failed") {
//                                success = false
//                                Swift.debugPrint("failure：fileName: \(result.fileName ?? ""), reason: \(result.failureReason ?? "")")
//                            }
//                            downloadUrl = result.downloadUrl
//                        }
//                    }
//                    if (success && downloadUrl != nil) {
//                        Swift.debugPrint("complete. downloadUrl: \(downloadUrl!)")
//                    }
//                }
            }
        }
    }
    
    @available(macOS 10.15.0, iOS 13.0, *)
    class func asyncEntrance() {
        let client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)
        
        Task { @MainActor in
            // Create a task
            let taskModel = await client.createTask(url: CPDFDocumentAI.TABLEREC, language: .english)
            let taskId = taskModel?.taskId ?? ""

            // upload File
            let path = Bundle.main.path(forResource: "IMG_00001(2)", ofType: "jpg")
            let uploadFileModel = await client.uploadFile(filepath: path ?? "", language: .english, params: [:], taskId: taskId)
            
            // execute Task
            let _ = await client.processFiles(taskId: taskId, language: .english)
            // get task processing information
            let taskInfoModel = await client.getTaskInfo(taskId: taskId, language: .english)
            guard let _model = taskInfoModel else {
                Swift.debugPrint("error:....")
                return
            }
            if (_model.isFinish()) {
                _model.printInfo()
            } else if (_model.isRuning()) {
                Swift.debugPrint("Task incomplete processing")
                client.getTaskInfoComplete(taskId: taskId) { isFinish, params in
                    Swift.debugPrint(params)
                }
            } else {
                Swift.debugPrint("error: \(taskInfoModel?.errorDesc ?? "")")
            }
        }
    }
}
