// Playground for experimenting with 3D points using SCNNode

import UIKit
import SceneKit

// create a node
var nodeAtCurrentPosition : SCNNode = SCNNode()
nodeAtCurrentPosition.position // initiatial position assumed to be (0,0,0)

// manipulate the node's position 
var translationToBeAppliedToNode : SCNVector3 = SCNVector3(x: 1.00, y: 2.00, z: 1.00)

// actually translate the node by the amount above
nodeAtCurrentPosition.pivot = SCNMatrix4MakeTranslation(1.00, 2.00, 3.00)

// has it been translated? 
nodeAtCurrentPosition.position

// ^ so line 19 didn't work, as indicated on line 22
// try setting the value of the position directly

var dx : Float = 1.00
var dy : Float = 2.00
var dz : Float = 3.00

var newX : Float = nodeAtCurrentPosition.position.x + dx
var newY : Float = nodeAtCurrentPosition.position.y + dy
var newZ : Float = nodeAtCurrentPosition.position.z + dz

nodeAtCurrentPosition.position = SCNVector3(x: newX, y: newY, z: newZ)
nodeAtCurrentPosition.position

// ^ alright, that seemed to have worked. Try translating again
dx = 1.00
dy = 1.00
dz = -3.00

newX = nodeAtCurrentPosition.position.x + dx
newY = nodeAtCurrentPosition.position.y + dy
newZ = nodeAtCurrentPosition.position.z + dz

nodeAtCurrentPosition.position = SCNVector3(x: newX, y: newY, z: newZ)
nodeAtCurrentPosition.position



// Yayyy! Worked. So, gotta set the position directly
// Problem: If don't use pivot, might run into problems in animating the drawing.

// NEXT: TRY ROTATION
// NEXT:


