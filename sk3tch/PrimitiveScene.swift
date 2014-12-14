//
//  PrimitiveScene.swift
//  SceneKitTutorial
//
//  Created by Jessica Mann on 12/1/14.
//  Copyright (c) 2014 Jessica Mann. All rights reserved.
//  
//  reference:
//  http://www.weheartswift.com/introduction-scenekit-part-1/
//


import Foundation
import SceneKit

class PrimitiveScene: SCNScene {
    
    var points : [SCNNode]!
    
    override init() {
        super.init()
        
    }
    
    func addPoints(points : [SCNNode]){
        self.points = points
        
        var sphereGeometry : SCNSphere
        var sphereNode : SCNNode
        
        var counter : Int = 0
        for point in self.points {
            sphereGeometry = SCNSphere(radius: 0.01)
            
            if counter%2==0 {
                sphereGeometry.firstMaterial?.diffuse.contents = UIColor.orangeColor()
            } else {
                sphereGeometry.firstMaterial?.diffuse.contents = UIColor.blueColor()
            }
            
            sphereNode = SCNNode(geometry: sphereGeometry)
            sphereNode.position =  SCNVector3(x: point.position.x, y: point.position.y, z: point.position.z)
            self.rootNode.addChildNode(sphereNode)
            counter++
        }
    }
    
    func removePoints() {
        let childrenNodes : [SCNNode] = self.rootNode.childNodes as [SCNNode]
        for child in childrenNodes {
            child.removeFromParentNode()
        }
        
        self.points = nil
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}