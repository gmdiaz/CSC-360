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
        
        // drawing a line between each of the two points
//        var point1 : SCNVector3
//        var point2 : SCNVector3
//        var vertices : [SCNVector3]
//        var geoSrc : SCNGeometrySource
//        var idx : [Int32] = [0,1]
//        var data : NSData
//        var geoElements: SCNGeometryElement
//        for index in 0...self.points.count-2 {
//            point1 = points[index].position
//            point2 = points[index+1].position
//            vertices = [point1, point2]
//            geoSrc = SCNGeometrySource(vertices: UnsafePointer<SCNVector3>(vertices), count: vertices.count)
//            
//            //index buffer
//            data = NSData(bytes: idx, length: (sizeof(Int32) * idx.count))
//            geoElements = SCNGeometryElement(data: data, primitiveType: SCNGeometryPrimitiveType.Line, primitiveCount: idx.count, bytesPerIndex: sizeof(Int32))
//            
//            // line node
//            let geo = SCNGeometry(sources: [geoSrc], elements: [geoElements])
//            let line = SCNNode(geometry: geo)
//            geo.firstMaterial?.diffuse.contents = UIColor.orangeColor()
//            self.rootNode.addChildNode(line)
//        }
        
        
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
    
    func removeNodes() {
        println("The number of children nodes in scene pre removal: ",self.rootNode.childNodes.count)
        let childrenNodes : [SCNNode] = self.rootNode.childNodes as [SCNNode]
        for child in childrenNodes {
            child.removeFromParentNode()
        }
        
        self.points = nil
        println("The number of children nodes in scene post removal: ",self.rootNode.childNodes.count)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}