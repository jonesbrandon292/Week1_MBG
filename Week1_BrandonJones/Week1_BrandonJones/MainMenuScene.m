//
//  MainMenuScene.m
//  Week1_BrandonJones
//
//  Created by Brandon Scott Jones on 11/2/13.
//  Copyright (c) 2013 Brandon Scott Jones. All rights reserved.
//

#import "MainMenuScene.h"
#import "MyScene.h"

@implementation MainMenuScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Super Game";
        myLabel.fontSize = 30;
        
        // Set Title to the top 3/4 of the screen and add it to the scene.
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) * 0.75f);
        [self addChild:myLabel];
        
        // Set background color and add a play button to the scene
        self.backgroundColor = [SKColor blueColor];
        [self addChild: [self newPlayButton]];
    }
    return self;
}

- (SKLabelNode *)newPlayButton
{
    SKLabelNode *playButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    playButton.text = @"Play";
    playButton.fontSize = 42;
    playButton.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    playButton.name = @"playButton";
    return playButton;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Finds the playbutton child node
    SKNode *playButton = [self childNodeWithName:@"playButton"];
    if (playButton != nil)
    {
        for (UITouch *touch in touches)
        {
                CGPoint touchLocation = [touch locationInNode:self];
            
                // if the playbutton is within the location touched.
                if([playButton containsPoint:touchLocation])
                {
                    SKAction *zoom = [SKAction scaleTo: 1.5 duration: 0.2];
                    SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.2];
                    SKAction *moveSequence = [SKAction sequence:@[zoom,fadeAway]];
                    [playButton runAction: moveSequence];
    
                    [playButton runAction: moveSequence completion:^{
                        SKScene *mainScene  = [[MyScene alloc] initWithSize:self.size];
                        [self.view presentScene:mainScene];
                    }];
                }
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
