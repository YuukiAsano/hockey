//
//  InterfaceLayer.m
//  Hockey
//
//  Created by 浅野 友希 on 2013/06/05.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "InterfaceLayer.h"
#import "GameScene.h"

@implementation InterfaceLayer
-(id) init{
    self = [super init];
    if(self){
    }
    return self;
}

//本クラスがアクティブなレイヤーに登録されたタイミングで、
//タッチイベントの受信を開始します。
//非アクティブになったら受信しないようCCTouchDispatcherから取り除きます。
-(void)onEnter{
    //タッチイベントを感知するようにする
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                     priority:0
                                              swallowsTouches:YES];
}

-(void)onExit{
    //タッチイベントを感知しないようにする
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
}

#pragma mark タッチイベントの取り扱い
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    //タッチされたポイントの座標系をcocos2dの座標系(原点:左下)に変換します。
    CGPoint locationInView = [touch locationInView:[touch view]];
    CGPoint location = [[CCDirector sharedDirector] convertToGL:locationInView];
    
	CGSize size = [[CCDirector sharedDirector] winSize];
    //player1の左
    if(location.x < size.width/4 && location.y < 73 ){
        GameScene *scene = [GameScene sharedInstance];
        [scene.player1 moveLeft];
    //player1の右
    }else if(location.x < size.width/2 && location.x > size.width/4 && location.y < 73){
        GameScene *scene = [GameScene sharedInstance];
        [scene.player1 moveRight];
    //player2の左
    }else if(location.x > size.width/4 * 3 && location.y > size.height - 73){
        GameScene *scene = [GameScene sharedInstance];
        [scene.player2 moveRight];
    //player2の右
    }else if(location.x > size.width/2 && location.x < size.width/4 * 3 && location.y > size.height - 73){
        GameScene *scene = [GameScene sharedInstance];
        [scene.player2 moveLeft];
    //player1のビーム
    }else if(location.x > size.width/4 * 3 && location.y < 73){
        GameScene *scene = [GameScene sharedInstance];
        [scene.player1 fire:1];
    //player1の敵
    }else if(location.x > size.width/2 && location.x < size.width/4 * 3  && location.y < 73){
        GameScene *scene = [GameScene sharedInstance];
        [scene.player1 stageEnemy:1];
    //player2のビーム
    }else if(location.x < size.width/4 && location.y > size.height - 73){
        GameScene *scene = [GameScene sharedInstance];
        [scene.player2 fire:2];
    //player2の敵
    }else if(location.x > size.width/4 && location.x < size.width/2 && location.y > size.height - 73){
        GameScene *scene = [GameScene sharedInstance];
        [scene.player2 stageEnemy:2];
    }
    return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {

}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    GameScene *scene = [GameScene sharedInstance];
    [scene.player1 stopMoving];
    [scene.player2 stopMoving];
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    GameScene *scene = [GameScene sharedInstance];
    [scene.player1 stopMoving];
    [scene.player2 stopMoving];
}

@end
