//
//  AddImageWatermark.swift
//  compdfkit-api-swift
//

import Foundation

#if os(iOS)
import Foundation
#else
import Cocoa
#endif

private let public_key = "x"
private let secret_key = "x"
class AddImageWatermark: NSObject {
    private static var client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)
    
    class func entrance() {
        // Create a task
        self.client.createTask(url: CPDFDocumentEditor.ADD_WATERMARK) { taskModel in
            guard let taskId = taskModel?.taskId else {
                Swift.debugPrint(taskModel?.errorDesc ?? "")
                return
            }
            
            // upload File
            let group = DispatchGroup()
            group.enter()
            let path = Bundle.main.path(forResource: "test", ofType: "pdf")
            self.client.uploadFile(filepath: path!, password: "", params: [
                CPDFFileUploadParameterKey.textColor.string():"#59c5bb",
                CPDFFileUploadParameterKey.type.string():"text",
                CPDFFileUploadParameterKey.content.string():"text",
                CPDFFileUploadParameterKey.scale.string():"1",
                CPDFFileUploadParameterKey.opacity.string():"0.5",
                CPDFFileUploadParameterKey.rotation.string():"0.785",
                CPDFFileUploadParameterKey.targetPages.string():"1-2",
                CPDFFileUploadParameterKey.vertalign.string():"center",
                CPDFFileUploadParameterKey.horizalign.string():"left",
                CPDFFileUploadParameterKey.xoffset.string():"100",
                CPDFFileUploadParameterKey.yoffset.string():"100",
                CPDFFileUploadParameterKey.fullScreen.string():"1",
                CPDFFileUploadParameterKey.horizontalSpace.string():"10",
                CPDFFileUploadParameterKey.verticalSpace.string():"10"
            ], taskId: taskId) { uploadFileModel in
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
            }
        }
    }
    
    @available(macOS 10.15.0, iOS 13.0, *)
    class func asyncEntrance() {
        let client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)
        
        Task { @MainActor in
            // Create a task
            let taskModel = await client.createTask(url: CPDFDocumentEditor.ADD_WATERMARK)
            let taskId = taskModel?.taskId ?? ""

            // upload File
            let path = Bundle.main.path(forResource: "test", ofType: "pdf")
            let uploadFileModel = await client.uploadFile(filepath: path ?? "", password: "", params: [
                CPDFFileUploadParameterKey.type.string():"image",
                CPDFFileUploadParameterKey.filepath.string() : Bundle.main.path(forResource: "test", ofType: "jpg")!,
                CPDFFileUploadParameterKey.scale.string():"0.5",
                CPDFFileUploadParameterKey.opacity.string():"0.5",
                CPDFFileUploadParameterKey.rotation.string():"45",
                CPDFFileUploadParameterKey.targetPages.string():"1-2",
                CPDFFileUploadParameterKey.vertalign.string():"center",
                CPDFFileUploadParameterKey.horizalign.string():"left",
                CPDFFileUploadParameterKey.xoffset.string():"50",
                CPDFFileUploadParameterKey.yoffset.string():"50",
                CPDFFileUploadParameterKey.fullScreen.string():"1",
                CPDFFileUploadParameterKey.horizontalSpace.string():"100",
                CPDFFileUploadParameterKey.verticalSpace.string():"100"
            ], taskId: taskId)
            
            // execute Task
            let _ = await client.processFiles(taskId: taskId)
            // get task processing information
            let taskInfoModel = await client.getTaskInfo(taskId: taskId)
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
