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
        /* Setup your scene here */
        
        //self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Super Game";
        myLabel.fontSize = 30;
        
        // Set Title to the top 3/4 of the screen.
        int yPos = CGRectGetMidY(self.frame);
        yPos = yPos + yPos * 0.5f;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame), yPos);
        
        [self addChild:myLabel];
        
        self.backgroundColor = [SKColor blueColor];
        self.scaleMode = SKSceneScaleModeAspectFit;
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
    SKNode *playButton = [self childNodeWithName:@"playButton"];
    if (playButton != nil)
    {
        for (UITouch *touch in touches)
        {
            if ([touch view] == self.view)
            {
                CGPoint touchLocation = [touch locationInView:self.view];
            
                if(touchLocation.x < playButton.position.x + 20 && touchLocation.x > playButton.position.x - 20
                   && touchLocation.y < playButton.position.y + 20 && touchLocation.y > playButton.position.y - 20)
                {
            
                    playButton.name = nil;
                    SKAction *moveUp = [SKAction moveByX: 0 y: 100.0 duration: 0.5];
                    SKAction *zoom = [SKAction scaleTo: 2.0 duration: 0.25];
                    SKAction *pause = [SKAction waitForDuration: 0.5];
                    SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.25];
                    SKAction *remove = [SKAction removeFromParent];
                    SKAction *moveSequence = [SKAction sequence:@[moveUp, zoom, pause, fadeAway, remove]];
                    [playButton runAction: moveSequence];
    
    
                    [playButton runAction: moveSequence completion:^{
                        SKScene *mainScene  = [[MyScene alloc] initWithSize:self.size];
                        SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
                        [self.view presentScene:mainScene transition:doors];
                    }];
                }
            }
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
