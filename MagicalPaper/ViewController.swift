//
//  ViewController.swift
//  MagicalPaper
//
//  Created by Krishna sai Patel on 26/05/19.
//  Copyright © 2019 Krishna sai Patel. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import SpriteKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()

        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "NewsPaper", bundle: Bundle.main) {
        
        configuration.trackingImages = trackedImages
            
        configuration.maximumNumberOfTrackedImages = 10

        }
        sceneView.session.run(configuration)
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }


    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        //1. Check We Have Detected An ARImageAnchor
        guard let validAnchor = anchor as? ARImageAnchor else { return }
        //2. Create A Video Player Node For Each Detected Target
            node.addChildNode(createdVideoPlayerNodeFor(validAnchor.referenceImage))
    }
  
    /// Creates An SCNNode With An AVPlayer Rendered Onto An SCNPlane
    ///
    /// - Parameter target: ARReferenceImage
    /// - Returns: SCNNode
    //1. Create An SCNNode To Hold Our VideoPlayer
    let videoPlayerNode = SCNNode()
    //2. Create An SCNPlane & An AVPlayer
    var videoPlayer = AVPlayer()
    
    func createdVideoPlayerNodeFor(_ target: ARReferenceImage) -> SCNNode{
        
        // To pause the video: videoPlayer.pause()
        
        let videoPlayerGeometry = SCNPlane(width: target.physicalSize.width, height: target.physicalSize.height)
        
        //3. If We Have A Valid Name & A Valid Video URL
        if let targetName = target.name,
            let validURL = Bundle.main.url(forResource: targetName, withExtension: "mp4", subdirectory: "art.scnassets") {
            
            //  Instanciate The AVPlayer
            videoPlayer = AVPlayer(url: validURL)
            // start playing the video.
            videoPlayer.play()
            //set the volume
            videoPlayer.volume = 1
            //4. Assign The AVPlayer & The Geometry To The Video Player
            videoPlayerGeometry.firstMaterial?.diffuse.contents = videoPlayer
            videoPlayerNode.geometry = videoPlayerGeometry
            
            //5. Rotate It
            videoPlayerNode.eulerAngles.x = -.pi / 2

            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:videoPlayer.currentItem, queue: nil) { notification in
                self.videoPlayer.seek(to: CMTime.zero)
                self.videoPlayer.play()
            }

        }
        return videoPlayerNode
    }


    // STATIC ONE VIDEO RENDERING
    
//    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//
//    }

    
    // MARK: - ARSCNViewDelegate
    //
    //    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
    //
    //        let node = SCNNode()
    //
    //        if let imageAnchor = anchor as? ARImageAnchor {
    //
    //            let videoNode = SKVideoNode(fileNamed: "kcr-jagan.mp4")
    //
    //            videoNode.play()
    //
    //            let videoScene = SKScene(size: CGSize(width: 480, height: 360))
    //
    //            videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
    //
    //            videoNode.yScale = -1.0
    //
    //            videoScene.addChild(videoNode)
    //
    //
    //            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
    //
    //            plane.firstMaterial?.diffuse.contents = videoScene
    //
    //            let planeNode = SCNNode(geometry: plane)
    //
    //            planeNode.eulerAngles.x = -.pi / 2
    //
    //            node.addChildNode(planeNode)
    //
    //        }
    //
    //        return node
    //
    //    }

}
