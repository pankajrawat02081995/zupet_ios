//
//  FilePickerManager.swift
//  Broker Portal
//
//  Created by Pankaj on 17/06/25.
//

//MARK: How to use

//UniversalFilePicker.shared.presentPicker(
//    from: self,
//    allowsMultiple: false,
//    returnAsData: true,
//    onCompleteURLs: { images, urls in
//        Log.debug("Images: \(images.count), Urls: \(urls.count)")
//    }
//)
//
//UniversalFilePicker.shared.presentPicker(
//    from: self,
//    allowsMultiple: false,
//    returnAsData: true,
//    onCompleteData: { images, datas in
//        Log.debug("Images: \(images.count), Data: \(datas.count)")
//    }
//)

import UIKit
import UniformTypeIdentifiers
import PhotosUI
import MobileCoreServices

final class UniversalFilePicker: NSObject {
    
    typealias CompletionWithURLs = (_ images: [UIImage], _ urls: [URL]) -> Void
    typealias CompletionWithData = (_ images: [UIImage], _ datas: [Data]) -> Void

    private var onCompleteURLs: CompletionWithURLs?
    private var onCompleteData: CompletionWithData?

    private var allowsMultiple: Bool = false
    private weak var presentingController: UIViewController?

    static let shared = UniversalFilePicker()

    private override init() {}

    func presentPicker(
        from controller: UIViewController,
        allowsMultiple: Bool = false,
        returnAsData: Bool = false,
        onCompleteURLs: CompletionWithURLs? = nil,
        onCompleteData: CompletionWithData? = nil
    ) {
        self.presentingController = controller
        self.allowsMultiple = allowsMultiple
        self.onCompleteURLs = onCompleteURLs
        self.onCompleteData = onCompleteData

        let alert = UIAlertController(title: "Choose File", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
            self?.presentPhotoLibrary()
        })

        alert.addAction(UIAlertAction(title: "Documents", style: .default) { [weak self] _ in
            self?.presentDocuments()
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        controller.present(alert, animated: true)
    }

    private func presentPhotoLibrary() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = allowsMultiple ? 0 : 1
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        presentingController?.present(picker, animated: true)
    }

    private func presentDocuments() {
        let types: [UTType] = [.jpeg, .png, .pdf, UTType(filenameExtension: "docx")!]
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types)
        picker.delegate = self
        picker.allowsMultipleSelection = allowsMultiple
        picker.modalPresentationStyle = .formSheet
        presentingController?.present(picker, animated: true)
    }

    private func cleanUp() {
        presentingController = nil
        onCompleteData = nil
        onCompleteURLs = nil
    }

    private func isValidFileSize(_ url: URL) -> Bool {
        guard let data = try? Data(contentsOf: url) else { return false }
        return Double(data.count) / (1024 * 1024) <= 5.0
    }
}

// MARK: - PHPickerViewControllerDelegate

extension UniversalFilePicker: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard !results.isEmpty else {
            self.cleanUp()
            return
        }

        var images: [UIImage] = []
        var datas: [Data] = []
        var pending = results.count

        for result in results {
            let provider = result.itemProvider
            guard provider.canLoadObject(ofClass: UIImage.self) else {
                pending -= 1
                if pending == 0 { self.finishImage(images: images, datas: datas) }
                continue
            }

            provider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
                guard let self, let image = object as? UIImage else {
                    pending -= 1
                    if pending == 0 { self?.finishImage(images: images, datas: datas) }
                    return
                }

                if let data = image.jpegData(compressionQuality: 0.8),
                   Double(data.count) / (1024 * 1024) <= 5.0 {
                    images.append(image)
                    datas.append(data)
                }

                pending -= 1
                if pending == 0 {
                    self.finishImage(images: images, datas: datas)
                }
            }
        }
    }

    private func finishImage(images: [UIImage], datas: [Data]) {
        DispatchQueue.main.async {
            self.onCompleteURLs?(images, []) // no URL for gallery
            self.onCompleteData?(images, datas)
            self.cleanUp()
        }
    }
}

// MARK: - UIDocumentPickerDelegate

extension UniversalFilePicker: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let validURLs = urls.filter { isValidFileSize($0) }
        var images: [UIImage] = []
        var datas: [Data] = []

        for url in validURLs {
            if url.startAccessingSecurityScopedResource() {
                defer { url.stopAccessingSecurityScopedResource() }
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    images.append(image)
                    datas.append(data)
                }
            }
        }

        DispatchQueue.main.async {
            self.onCompleteURLs?(images, validURLs)
            self.onCompleteData?(images, datas)
            self.cleanUp()
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        cleanUp()
    }
}
