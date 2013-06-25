//
//  Player.h
//  Hockey
//
//  Created by 浅野 友希 on 2013/06/05.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define PLAYER_DEFAULT_RADIUS 30
//現在の自機の状態を表す列挙子
typedef enum {
    kPlayerIsStopped = 0,
    kPlayerIsMovingToLeft,
    kPlayerIsMovingToRight,
}MovingState;

@interface Player : CCNode {
    CCSprite *sprite; //自機のテクスチャ
    MovingState state; //自機の動作状態
    NSInteger life;  //残りライフ
    NSMutableArray *cartridge; //弾倉(弾を保持)
    NSInteger cartridgePos; //弾倉内の、次に発射する弾の位置
    BOOL started;
    NSMutableArray *enemies; //敵をストックしておく配列
    NSInteger enemyPos; //配列内の、次に登場させる敵の位置
}
@property (nonatomic, retain)CCSprite *sprite;
@property (nonatomic, retain)NSMutableArray *cartridge;
@property NSInteger life;
@property (nonatomic, readonly)float radius;
@property (nonatomic, retain)NSMutableArray *enemies;
// 動作開始
-(void) start:(int)player_num;
//動作停止
-(void) stop;

//自機に対する移動命令を扱うメソッド
-(void)moveLeft;
-(void)moveRight;
-(void)stopMoving;

//指定された座標に対して衝突しているかどうか判定
-(BOOL)hitIfCollided:(CGPoint)position player_num: (int)player_num item_num: (int)item_num;
-(void)fire:(int)player_num;

-(void)stageEnemy:(int)player_num;
-(BOOL)checkCollision:(CGPoint)position;
@end




