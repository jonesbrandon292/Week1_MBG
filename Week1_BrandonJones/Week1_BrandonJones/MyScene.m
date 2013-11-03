//
//  MyScene.m
//  Week1_BrandonJones
//
//  Created by Brandon Scott Jones on 11/2/13.
//  Copyright (c) 2013 Brandon Scott Jones. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene
{
    NSTimeInterval m_animation_speed;
    
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
        m_animation_speed = 1/25.0f;
        
        int enemyXPos = CGRectGetMidX(self.frame);
        enemyXPos = enemyXPos + enemyXPos * 0.5f;
        int enemyYPos = CGRectGetMidY(self.frame);
        [self addEnemy:128 atPos:CGPointMake(enemyXPos, enemyYPos)];
        
        int playerXPos = CGRectGetMidX(self.frame);
        playerXPos = playerXPos - playerXPos * 0.5f;
        int playerYPos = CGRectGetMidY(self.frame);
        [self addPlayer:128 atPos:CGPointMake(playerXPos, playerYPos)];
        
    }
    return self;
}

-(void)addPlayer: (float)scale atPos:(CGPoint) pos
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
    
    m_player_health = 3;
    m_player = [SKSpriteNode spriteNodeWithTexture:[m_player_idle firstObject]];// size:CGSizeMake(scale, scale)];
    m_player.position = pos;
    
    SKAction* playerIdle = [SKAction animateWithTextures:m_player_idle timePerFrame:m_animation_speed];
    [m_player runAction:[SKAction repeatActionForever:playerIdle]];
    
    [self addChild:m_player];
}

-(void)addEnemy: (float)scale atPos:(CGPoint) pos
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
    
    m_enemy_health = 3;
    m_enemy = [SKSpriteNode spriteNodeWithTexture:[m_enemy_idle firstObject]];// size:CGSizeMake(scale, scale)];
    m_enemy.position = pos;
    
    SKAction* enemyIdle = [SKAction animateWithTextures:m_enemy_idle timePerFrame:m_animation_speed];
    [m_enemy runAction:[SKAction repeatActionForever:enemyIdle]];
    
    [self addChild:m_enemy];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    
    for (UITouch *touch in touches)
    {
        [m_enemy runAction:[SKAction animateWithTextures:m_enemy_attack
                                                timePerFrame:m_animation_speed
                                                resize:NO
                                                restore: YES]];
        
        [m_player runAction:[SKAction animateWithTextures:m_player_attack
                                            timePerFrame:m_animation_speed
                                                  resize:NO
                                                 restore: YES]];
        //CGPoint location = [touch locationInNode:self];
        
        //SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        //sprite.position = location;
        
        //SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        //[sprite runAction:[SKAction repeatActionForever:action]];
        
        //[self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
