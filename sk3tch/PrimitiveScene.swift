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
    
    // boolean for determining which presentation of data is shown
    var isLine = false
    var isSphere = false
    
    override init() {
        super.init()
        
    }
    
    func addLines(nodes: [SCNNode]){
        var vertices : [SCNVector3]
        var line : SCNNode
        for index in 0...nodes.count-2 {
            vertices = [nodes[index].position, nodes[index+1].position]
            line = makeLine(vertices)
            self.rootNode.addChildNode(line)
        }
        self.isLine = true
        self.isSphere = false
    }
    
    // takes in an array of 2 vertices & make a line between them
    // should be a way to do an entire vector, but haven't gotten there yet
    func makeLine(vertices : [SCNVector3]) -> SCNNode{

        // using the vertices, create a custom geometry source
        var geoSrc : SCNGeometrySource = SCNGeometrySource(vertices: UnsafePointer<SCNVector3>(vertices), count: vertices.count)
        
        // index buffer
        var idx : [Int32] = [0,1]
        var data = NSData(bytes: idx, length: (sizeof(Int32) * idx.count))
        var geoElements : SCNGeometryElement = SCNGeometryElement(data: data, primitiveType: SCNGeometryPrimitiveType.Line, primitiveCount: idx.count, bytesPerIndex: sizeof(Int32))
        
        // line code
        let geo = SCNGeometry(sources: [geoSrc], elements: [geoElements])
        let line = SCNNode(geometry: geo)
        //geo.firstMaterial?.diffuse.contents = UIColor.greenColor() // doesn't work
        return line

    }
    
    func addSpheres(points : [SCNNode]){
        
        var sphereGeometry : SCNSphere
        var sphereNode : SCNNode
        
        var counter : Int = 0
        for point in points {
            sphereGeometry = SCNSphere(radius: 0.01)
            
            if counter%2==0 {
                sphereGeometry.firstMaterial?.diffuse.contents = UIColor.greenColor()
            } else {
                sphereGeometry.firstMaterial?.diffuse.contents = UIColor.blueColor()
            }
            
            sphereNode = SCNNode(geometry: sphereGeometry)
            sphereNode.position =  SCNVector3(x: point.position.x, y: point.position.y, z: point.position.z)
            self.rootNode.addChildNode(sphereNode)
            counter++
        }
        self.isSphere = true
        self.isLine = false
    }
    
    // this also clears the points array
    func removeNodes() {
        let childrenNodes : [SCNNode] = self.rootNode.childNodes as [SCNNode]
        for child in childrenNodes {
            child.removeFromParentNode()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}