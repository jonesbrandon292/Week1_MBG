//
//  MyScene.m
//  Week1_BrandonJones
//
//  Created by Brandon Scott Jones on 11/2/13.
//  Copyright (c) 2013 Brandon Scott Jones. All rights reserved.
//

#import "MyScene.h"
#import "MainMenuScene.h"

@implementation MyScene
{
    bool m_game_over;
    bool m_processing_action;
    
    NSTimeInterval m_animation_speed;
    SKLabelNode* m_player_choice;
    SKLabelNode* m_enemy_choice;
    SKLabelNode* m_player_health_node;
    SKLabelNode* m_enemy_health_node;
    SKLabelNode* m_outcome;
    SKLabelNode* m_game_over_message;
    
    SKLabelNode* m_rock_button;
    SKLabelNode* m_paper_button;
    SKLabelNode* m_scissors_button;
    SKLabelNode* m_retry_button;
    
    SKAction* m_enemy_attack_action;
    SKAction* m_player_attack_action;
    SKAction* m_enemy_damaged_action;
    SKAction* m_player_damaged_action;
    SKAction* m_enemy_death_action;
    SKAction* m_player_death_action;
    
    int m_enemy_health;
    SKSpriteNode* m_enemy;
    NSArray* m_enemy_attack;
    NSArray* m_enemy_idle;
    NSArray* m_enemy_walk;
    NSArray* m_enemy_damaged;
    NSArray* m_enemy_death;
    
    int m_player_health;
    SKSpriteNode* m_player;
    NSArray* m_player_attack;
    NSArray* m_player_idle;
    NSArray* m_player_walk;
    NSArray* m_player_damaged;
    NSArray* m_player_death;
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        m_game_over = false;
        m_processing_action = false;
        m_animation_speed = 1/25.0f;
        m_player_health = 5;
        m_enemy_health = 5;
        
        
        int enemyXPos = CGRectGetMidX(self.frame);
        enemyXPos = enemyXPos + enemyXPos * 0.5f;
        int enemyYPos = CGRectGetMidY(self.frame);
        
        [self addEnemy:128 withRotation:M_PI_2 atPos:CGPointMake(enemyXPos, enemyYPos)];
        
        int playerXPos = CGRectGetMidX(self.frame);
        playerXPos = playerXPos - playerXPos * 0.5f;
        int playerYPos = CGRectGetMidY(self.frame);
        [self addPlayer:128 withRotation:-M_PI_2 atPos:CGPointMake(playerXPos, playerYPos)];
        
        float xPos = CGRectGetMaxX(self.frame)/4;
        float yPos = CGRectGetMaxY(self.frame) - CGRectGetMaxY(self.frame)/8;
        
        CGPoint position = CGPointMake(xPos, yPos);
        m_rock_button = [self newButton:@"Rock" withName:@"rock" atPos:position];
        [self addChild: m_rock_button];
        
        position = CGPointMake(xPos * 2, yPos);
        m_paper_button = [self newButton:@"Paper" withName:@"paper" atPos:position];
        [self addChild: m_paper_button];
        
        position = CGPointMake(xPos * 3, yPos);
        m_scissors_button = [self newButton:@"Scissors" withName:@"scissors" atPos:position];
        [self addChild: m_scissors_button];
        
        yPos = CGRectGetMaxY(self.frame) - CGRectGetMaxY(self.frame)/4;
        position = CGPointMake(xPos, yPos);
        m_player_choice = [self newButton:@"None" withName:@"playerChoice" atPos:position];
        m_player_choice.hidden = true;
        [self addChild: m_player_choice];
        
        yPos = CGRectGetMaxY(self.frame) - CGRectGetMaxY(self.frame)/4;
        position = CGPointMake(xPos * 3, yPos);
        m_enemy_choice = [self newButton:@"None" withName:@"enemyChoice" atPos:position];
        m_enemy_choice.hidden = true;
        [self addChild: m_enemy_choice];
        
        yPos = CGRectGetMaxY(self.frame) - CGRectGetMaxY(self.frame)/4;
        position = CGPointMake(xPos * 2, yPos);
        m_outcome = [self newButton:@"None" withName:@"outcome" atPos:position];
        m_outcome.hidden = true;
        [self addChild: m_outcome];
        
        yPos = CGRectGetMaxY(self.frame)/4;
        position = CGPointMake(xPos, yPos);
        m_player_health_node = [self newButton:[NSString stringWithFormat:@"Player Health: %d", m_player_health * 20] withName:@"playerHealthNode" atPos:position];
        [self addChild: m_player_health_node];
        
        yPos = CGRectGetMaxY(self.frame)/4;
        position = CGPointMake(xPos * 3, yPos);
        m_enemy_health_node = [self newButton:[NSString stringWithFormat:@"Enemy Health: %d", m_enemy_health * 20] withName:@"enemyHealthNode" atPos:position];
        [self addChild: m_enemy_health_node];
        
        yPos = CGRectGetMaxY(self.frame) - CGRectGetMaxY(self.frame)/8;
        position = CGPointMake(xPos * 2, yPos);
        m_game_over_message = [self newButton:@"None" withName:@"gameOver" atPos:position];
        m_game_over_message.hidden = true;
        [self addChild: m_game_over_message];
        
        yPos = CGRectGetMaxY(self.frame) - CGRectGetMaxY(self.frame)/4;
        position = CGPointMake(xPos * 2, yPos);
        m_retry_button = [self newButton:@"Retry?" withName:@"retryButton" atPos:position];
        m_retry_button.hidden = true;
        [self addChild: m_retry_button];
    }
    return self;
}

- (SKLabelNode *)newButton:(NSString*)text withName:(NSString*)name atPos:(CGPoint)pos
{
    SKLabelNode *button = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    button.text = text;
    button.color = [SKColor redColor];
    button.fontSize = 12;
    button.position = pos;
    button.name = name;
    return button;
}

-(void)addPlayer: (float)scale withRotation:(float)rotation atPos:(CGPoint) pos
{
    NSMutableArray* playerAttackAnim = [NSMutableArray array];
    SKTextureAtlas* playerAttackAnimAtlas = [SKTextureAtlas atlasNamed:@"Warrior_Attack"];
    for(int i = 1; i < playerAttackAnimAtlas.textureNames.count; ++i)
    {
        NSString* texture = [NSString stringWithFormat:@"warrior_attack_%04d", i];
        [playerAttackAnim addObject:[playerAttackAnimAtlas textureNamed:texture]];
        
    }
    
    m_player_attack = playerAttackAnim;
    
    NSMutableArray* playerDeathAnim = [NSMutableArray array];
    SKTextureAtlas* playerDeathAnimAtlas = [SKTextureAtlas atlasNamed:@"Warrior_Death"];
    for(int i = 1; i < playerDeathAnimAtlas.textureNames.count; ++i)
    {
        NSString* texture = [NSString stringWithFormat:@"warrior_death_%04d", i];
        [playerDeathAnim addObject:[playerDeathAnimAtlas textureNamed:texture]];
        
    }
    
    m_player_death = playerDeathAnim;
    
    NSMutableArray* playerDamagedAnim = [NSMutableArray array];
    SKTextureAtlas* playerDamagedAnimAtlas = [SKTextureAtlas atlasNamed:@"Warrior_GetHit"];
    for(int i = 1; i < playerDamagedAnimAtlas.textureNames.count; ++i)
    {
        NSString* texture = [NSString stringWithFormat:@"warrior_gethit_%04d", i];
        [playerDamagedAnim addObject:[playerDamagedAnimAtlas textureNamed:texture]];
        
    }
    
    m_player_damaged = playerDamagedAnim;
    
    NSMutableArray* playerIdleAnim = [NSMutableArray array];
    SKTextureAtlas* playerIdleAnimAtlas = [SKTextureAtlas atlasNamed:@"Warrior_Idle"];
    for(int i = 1; i < playerIdleAnimAtlas.textureNames.count; ++i)
    {
        NSString* texture = [NSString stringWithFormat:@"warrior_idle_%04d", i];
        [playerIdleAnim addObject:[playerIdleAnimAtlas textureNamed:texture]];
        
    }
    
    m_player_idle = playerIdleAnim;
    
    m_player = [SKSpriteNode spriteNodeWithTexture:[m_player_idle firstObject]];// size:CGSizeMake(scale, scale)];
    m_player.position = pos;
    m_player.zRotation = rotation;
    
    SKAction* playerIdle = [SKAction animateWithTextures:m_player_idle
                                            timePerFrame:m_animation_speed
                                                  resize:YES
                                                 restore: YES];
    
    [m_player runAction:[SKAction repeatActionForever:playerIdle]];
    
    m_player_attack_action = [SKAction animateWithTextures:m_player_attack
                                              timePerFrame:m_animation_speed
                                                    resize:YES
                                                   restore: YES];
    
    m_player_damaged_action = [SKAction animateWithTextures:m_player_damaged
                                              timePerFrame:m_animation_speed
                                                    resize:YES
                                                   restore: YES];
    
    m_player_death_action = [SKAction animateWithTextures:m_player_death
                                              timePerFrame:m_animation_speed
                                                    resize:YES
                                                   restore: YES];
    
    [self addChild:m_player];
}

-(void)addEnemy: (float)scale withRotation:(float)rotation atPos:(CGPoint) pos
{
    NSMutableArray* enemyAttackAnim = [NSMutableArray array];
    SKTextureAtlas* enemyAttackAnimAtlas = [SKTextureAtlas atlasNamed:@"Boss_Attack"];
    for(int i = 1; i < enemyAttackAnimAtlas.textureNames.count; ++i)
    {
        NSString* texture = [NSString stringWithFormat:@"boss_attack_%04d", i];
        [enemyAttackAnim addObject:[enemyAttackAnimAtlas textureNamed:texture]];
        
    }
    
    m_enemy_attack = enemyAttackAnim;
    
    NSMutableArray* enemyDeathAnim = [NSMutableArray array];
    SKTextureAtlas* enemyDeathAnimAtlas = [SKTextureAtlas atlasNamed:@"Boss_Death"];
    for(int i = 1; i < enemyDeathAnimAtlas.textureNames.count; ++i)
    {
        NSString* texture = [NSString stringWithFormat:@"boss_death_%04d", i];
        [enemyDeathAnim addObject:[enemyDeathAnimAtlas textureNamed:texture]];
        
    }
    
    m_enemy_death = enemyDeathAnim;
    
    NSMutableArray* enemyDamagedAnim = [NSMutableArray array];
    SKTextureAtlas* enemyDamagedAnimAtlas = [SKTextureAtlas atlasNamed:@"Boss_GetHit"];
    for(int i = 1; i < enemyDamagedAnimAtlas.textureNames.count; ++i)
    {
        NSString* texture = [NSString stringWithFormat:@"boss_gethit_%04d", i];
        [enemyDamagedAnim addObject:[enemyDamagedAnimAtlas textureNamed:texture]];
        
    }
    
    m_enemy_damaged = enemyDamagedAnim;
    
    NSMutableArray* enemyIdleAnim = [NSMutableArray array];
    SKTextureAtlas* enemyIdleAnimAtlas = [SKTextureAtlas atlasNamed:@"Boss_Idle"];
    for(int i = 1; i < enemyIdleAnimAtlas.textureNames.count; ++i)
    {
        NSString* texture = [NSString stringWithFormat:@"boss_idle_%04d", i];
        [enemyIdleAnim addObject:[enemyIdleAnimAtlas textureNamed:texture]];
        
    }
    
    m_enemy_idle = enemyIdleAnim;
    
    m_enemy = [SKSpriteNode spriteNodeWithTexture:[m_enemy_idle firstObject]];// size:CGSizeMake(scale, scale)];
    m_enemy.position = pos;
    m_enemy.zRotation = rotation;
    
    SKAction* enemyIdle = [SKAction animateWithTextures:m_enemy_idle
                                           timePerFrame:m_animation_speed
                                                 resize:YES
                                                restore: YES];
    
    [m_enemy runAction:[SKAction repeatActionForever:enemyIdle]];
    
    m_enemy_attack_action = [SKAction animateWithTextures:m_enemy_attack
                                              timePerFrame:m_animation_speed
                                                    resize:YES
                                                   restore: YES];
    
    m_enemy_damaged_action = [SKAction animateWithTextures:m_enemy_damaged
                                               timePerFrame:m_animation_speed
                                                     resize:YES
                                                    restore: YES];
    
    m_enemy_death_action = [SKAction animateWithTextures:m_enemy_death
                                             timePerFrame:m_animation_speed
                                                   resize:YES
                                                  restore: YES];
    
    [self addChild:m_enemy];
}

-(int)whoWon:(int)playerChoice enemy:(int)enemyChoice
{
    if(playerChoice == enemyChoice)
        return 0;
    
    if(playerChoice == 0 && enemyChoice == 2)
        return 1;
    
    if(playerChoice == 1 && enemyChoice == 0)
        return 1;
    
    if(playerChoice == 2 && enemyChoice == 1)
        return 1;
    
    return -1;
}

-(void)makeChoice:(SKLabelNode*)node withChoice:(int)choice
{
    if(choice == 0)
    {
        node.hidden = false;
        node.text = @"Rock";
    }
    if(choice == 1)
    {
        node.hidden = false;
        node.text = @"Paper";
    }
    if(choice == 2)
    {
        node.hidden = false;
        node.text = @"Scissors";
    }
}

-(void)damagePlayer
{
    [m_enemy runAction:m_enemy_attack_action];
    m_processing_action = true;
    
    if(m_player_health > 1)
    {
        [m_enemy runAction: m_enemy_attack_action completion:^{
            [m_player runAction:m_player_damaged_action];
            m_player_health -= 1;
            m_player_health_node.text = [NSString stringWithFormat:@"Player Health: %d", m_player_health * 20];
            [m_player runAction: m_player_damaged_action completion:^{
                m_player_choice.hidden = true;
                m_enemy_choice.hidden = true;
                m_outcome.hidden = true;
                m_processing_action = false;
            }];
        }];
    }
    else
    {
        [m_enemy runAction: m_enemy_attack_action completion:^{
            [m_player runAction:m_player_death_action];
            m_player_health -= 1;
            m_player_health_node.text = [NSString stringWithFormat:@"Player Health: %d", m_player_health * 20];
            m_game_over_message.text = @"You died...";
            m_game_over_message.hidden = false;
            m_retry_button.hidden = false;
            m_paper_button.hidden = true;
            m_rock_button.hidden = true;
            m_scissors_button.hidden = true;
            m_player_choice.hidden = true;
            m_enemy_choice.hidden = true;
            m_outcome.hidden = true;
            m_game_over = true;
        }];
    }
}

-(void)damageEnemy
{
    [m_player runAction:m_player_attack_action];
    m_processing_action = true;
    
    if(m_enemy_health > 1)
    {
        [m_player runAction: m_player_attack_action completion:^{
            [m_enemy runAction:m_enemy_damaged_action];
            m_enemy_health -= 1;
            m_enemy_health_node.text = [NSString stringWithFormat:@"Enemy Health: %d", m_enemy_health * 20];
            [m_enemy runAction: m_enemy_damaged_action completion:^{
                m_player_choice.hidden = true;
                m_enemy_choice.hidden = true;
                m_outcome.hidden = true;
                m_processing_action = false;
            }];
        }];
    }
    else
    {
        [m_player runAction: m_player_attack_action completion:^{
            [m_enemy runAction:m_enemy_death_action];
            m_enemy_health -= 1;
            m_enemy_health_node.text = [NSString stringWithFormat:@"Enemy Health: %d", m_enemy_health * 20];
            m_game_over_message.text = @"You Win!";
            m_game_over_message.hidden = false;
            m_retry_button.hidden = false;
            m_paper_button.hidden = true;
            m_rock_button.hidden = true;
            m_scissors_button.hidden = true;
            m_player_choice.hidden = true;
            m_enemy_choice.hidden = true;
            m_outcome.hidden = true;
            m_game_over = true;
        }];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    
    for (UITouch *touch in touches)
    {
            CGPoint touchLocation = [touch locationInNode:self];
        
        
            if(m_game_over)
            {
                if([m_retry_button containsPoint:touchLocation])
                {
                    SKAction *zoom = [SKAction scaleTo: 1.5 duration: 0.2];
                    SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.2];
                    SKAction *moveSequence = [SKAction sequence:@[zoom,fadeAway]];
                    [m_retry_button runAction: moveSequence];
                    
                    [m_retry_button runAction: moveSequence completion:^{
                        SKScene *menuScene  = [[MainMenuScene alloc] initWithSize:self.size];
                        [self.view presentScene:menuScene];
                    }];
                }
                return;
            }
        
            if(m_processing_action)
                return;
        
            int playerChoice = -1;
            if([m_rock_button containsPoint:touchLocation])
            {
                playerChoice = 0;
            }
            
            if([m_paper_button containsPoint:touchLocation])
            {
                playerChoice = 1;
            }
            
            if([m_scissors_button containsPoint:touchLocation])
            {
                playerChoice = 2;
            }
            
            if(playerChoice < 0)
                return;
            
            [self makeChoice: m_player_choice withChoice:playerChoice];
            
            int enemyChoice = rand() % 3;
            [self makeChoice: m_enemy_choice withChoice:enemyChoice];
            
            int winner = [self whoWon:playerChoice enemy:enemyChoice];
            if(winner > 0)
            {
                m_outcome.text = @"Win!";
                m_outcome.hidden = false;
                [self damageEnemy];
                
            }
            else if(winner < 0)
            {
                m_outcome.text = @"Loss...";
                m_outcome.hidden = false;
                [self damagePlayer];
            }
        else
        {
            m_processing_action = true;
            m_outcome.text = @"Draw.";
            m_outcome.hidden = false;
            SKAction* wait = [SKAction waitForDuration:1.0f];
            [self runAction: wait];
            [self runAction:wait completion:^{
                m_processing_action = false;
                m_outcome.hidden = true;
                m_player_choice.hidden = true;
                m_enemy_choice.hidden = true;
            }];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
