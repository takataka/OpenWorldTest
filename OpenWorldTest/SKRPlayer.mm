//
//  PlayerNode.m
//  SceneKraft
//
//  Created by Tom Irving on 09/09/2012.
//  Copyright (c) 2012 Tom Irving. All rights reserved.
//

#import "SKRPlayer.h"
#import "SKRMath.h"

@interface SKRPlayer ()
- (void)buildPlayer;
@end

@implementation SKRPlayer

+ (SKRPlayer *)nodeWithHMDInfo:(OVR::HMDInfo)hmdInfo
{
	SKRPlayer * node = (SKRPlayer *)[super node];
	[node setMass:70];
    [node createCamerasWithHMDInfo:hmdInfo];
	[node buildPlayer];
//    [node createArms];
	[node buildPlayer];
	return node;
}

- (void)createCamerasWithHMDInfo:(OVR::HMDInfo)hmdInfo {
    float halfScreenAspectRatio = (hmdInfo.HResolution * 0.5) / hmdInfo.VResolution;
    float halfScreenDistance = hmdInfo.VScreenSize * 0.5;
    float yFov = 2.0 * atanf(halfScreenDistance / hmdInfo.EyeToScreenDistance);
    float xFov = 2.0 * atanf(halfScreenAspectRatio * tanf(yFov / 2.0));
    float yFovDegrees = GLKMathRadiansToDegrees(yFov);
    float xFovDegrees = GLKMathRadiansToDegrees(xFov);
    float interpupillaryDistance = hmdInfo.InterpupillaryDistance;

    if (hmdInfo.HResolution == 0)
    {
        xFovDegrees = 90;
        yFovDegrees = 64.01;
    }

    NSLog(@"yFov: %f, xFov: %f", yFovDegrees, xFovDegrees);
    
    for (NSUInteger i = 0; i < 2; i++) {
        SCNCamera *camera = [SCNCamera camera];
        camera.zNear = 0.1;
        camera.zFar = 200;
        camera.xFov = xFovDegrees;
        camera.yFov = yFovDegrees;
        
        SCNNode *eyeNode = [SCNNode node];
        [eyeNode setCamera:camera];
        
        [self addChildNode:eyeNode];
        if (i == 0) {
            eyeNode.position = SCNVector3Make(0.0, 0.0, 0.0);
            self.leftEye = eyeNode;
        } else if (i == 1) {
            eyeNode.position = SCNVector3Make(0.0, 0.0, 0.0);
            self.rightEye = eyeNode;
        }
    }
    
    self.interpupillaryDistance = interpupillaryDistance;
}
- (void)setInterpupillaryDistance:(float)interpupillaryDistance
{
    _interpupillaryDistance = interpupillaryDistance;
    self.leftEye.position = SCNVector3Make(-self.interpupillaryDistance * 0.5, 0.0, 0.0);
    self.rightEye.position = SCNVector3Make(self.interpupillaryDistance * 0.5, 0.0, 0.0);
}

- (void)buildPlayer {
	[self setGeometry:[SCNBox boxWithWidth:1 height:1 length:1 chamferRadius:0]];
}

- (void)createArms {
    SCNCapsule *capsule = [SCNCapsule capsuleWithCapRadius:0.2 height:1];
    SCNMaterial *material = [SCNMaterial material];
    material.diffuse.contents = [NSColor colorWithCalibratedWhite:0.1 alpha:1.0];
    capsule.materials = @[material];
    for (NSUInteger i = 0; i < 2; i++) {
        
        SCNNode *handCenterNode = [SCNNode node];
        [self addChildNode:handCenterNode];
        
        SCNNode *handNode = [SCNNode nodeWithGeometry:capsule];
        [handCenterNode addChildNode:handNode];
        
        CGFloat x = 0.5;
        CGFloat y = 0;
        CGFloat z = -2; // negative=forwards from eyes
        if (i == 0) {
            handCenterNode.position = SCNVector3Make(-x, y, z);
            self.leftHand = handNode;
        } else if (i == 1) {
            handCenterNode.position = SCNVector3Make(x, y, z);
            self.rightHand = handNode;
        }
    }
}

- (void)updateArm:(SKRSide)side
         position:(SCNVector3)position
      rotation:(SCNVector4)rotation {
    SCNNode *hand;
    if (side == SKRLeft) {
        hand = self.leftHand;
    } else if (side == SKRRight) {
        hand = self.rightHand;
    }
    hand.position = position;
    hand.rotation = rotation;
}

@end