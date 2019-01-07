//
//  ViewController.swift
//  ARcourse_1
//
//  Created by TOTO on 6/1/19.
//  Copyright © 2019 TOTO. All rights reserved.
//

// red line is X axis, green is Y, blue is Z
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
//    @IBAction func add(_ sender: Any) {
//        // a node is purely a position, describe a coordinate system
//        let node = SCNNode()
//
//        node.geometry = SCNPyramid(width: 0.1, height: 0.1, length: 0.1)
////        node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
//        node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
//        node.position = SCNVector3(0,0,0) // 1 = 100 cm
//        node.eulerAngles = SCNVector3(90.degreeToRadians, 0, 0)
//
//        // scene is the camera view of the real world, its root Node is at the postion of world origin
//        sceneView.scene.rootNode.addChildNode(node) // the position of node is relative to the rootnode
//    }
    
    @IBAction func reset(_ sender: UIButton) {
        restartSession()
    }
    @IBOutlet weak var midButton: UIButton!
    
    func restartSession(){
//        sceneView.session.pause()
        sceneView.scene.rootNode.enumerateChildNodes{ (node, _) in
            node.removeFromParentNode()
        }
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.session.run(configuration)
        sceneView.showsStatistics = true
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        // Do any additional setup after loading the view, typically from a nib.
        sceneView.delegate = self
//        sceneView.autoenablesDefaultLighting = true //omni light
        midButton.setTitle("draw", for: .normal)
//        midButton.sizeToFit()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        // to get the transform of the phone
        guard let pointOfView = sceneView.pointOfView else {return}
        let transform = pointOfView.transform
        // orentiation is in the 3rd column of transform matrix, and the value is reversed
        let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33)
        // location is in the 4th column of transform matrix
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
//        print("orientation: \(orientation) \n location: \(location) \n phone: \(sceneView.scene.rootNode.transform)" )
        let frontOfCamera = orientation + location
        
        let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
        sphereNode.position = frontOfCamera
        sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        let pointer = SCNNode(geometry: SCNSphere(radius: 0.01))
        pointer.name = "pointer"
        pointer.position = frontOfCamera
//
        DispatchQueue.main.async {


            if self.midButton.isHighlighted{

                self.sceneView.scene.rootNode.addChildNode(sphereNode)

            }else{

                
                self.sceneView.scene.rootNode.enumerateChildNodes({ node,_ in
                    if node.name == "pointer" {
                        node.removeFromParentNode()
                    }
                })
                self.sceneView.scene.rootNode.addChildNode(pointer)

            }
        }

    }



}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3{
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

extension Int {
    var degreeToRadians: Double { return (Double(self) * .pi/180) }
}

