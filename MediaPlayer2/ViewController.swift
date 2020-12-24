//
//  ViewController.swift
//  MediaPlayer2
//
//  Created by gtk on 2020/12/21.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices
import PhotosUI

class ViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func selectVideo(){
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate=self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.allowsEditing=false
            present(imagePicker, animated: true, completion: nil)
        }else{
            print("error: read image error")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let videoUrl = info[UIImagePickerController.InfoKey.referenceURL] as! URL
        dismiss(animated: true, completion: nil)
        playVideoWithAssetUrl(assetUrl: videoUrl)
    }
    
    func playVideoWithAssetUrl(assetUrl:URL)  {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (PHAuthorizationStatus) in
                if(PHAuthorizationStatus == .authorized){
                    self.doPlay(assetUrl: assetUrl)
                }else{
                    print("can't play")
                }
            }
        }else if authStatus == .authorized {
           doPlay(assetUrl: assetUrl)
        }else {
            print("can't play")
        }
    }
    
    func doPlay(assetUrl:URL)  {
        DispatchQueue.main.async {
            let asset = AVAsset(url: assetUrl)
            let playItem = AVPlayerItem(asset: asset)
            let player = AVPlayer(playerItem: playItem)
            let playerController = AVPlayerViewController()
            playerController.player = player
            self.present(playerController, animated: true, completion: {
                playerController.player!.play()
            })
        }
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        selectVideo()
    }
}
