//
//  TitleLayer.m
//  Hockey
//
//  Created by 浅野 友希 on 2013/06/05.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "TitleLayer.h"
#import "GameScene.h"

@interface TitleLayer ()
//タイトル画面でPlayボタンがタップされた時に呼ばれるメソッド
-(void)pushedPlayButton:(id)sender;
@end

@implementation TitleLayer
+(CCScene *)scene {
    //タイトル画像はTitleLayerだけを含むシーンにするため、TitleLayerとして
    //CCSceneを提供するようsceneメソッドを作成します
    CCScene *scene = [CCScene node];
    
    TitleLayer *layer = [TitleLayer node];
    
    [scene addChild:layer];
    return scene;
}

-(id)init{
    self = [super init];
    if(self){
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        //タイトル画像を画面中央に描画します
        //アプリ起動時の画像と同じファイルを使用するため、横向きに回転表示します
        CCSprite *background = [CCSprite spriteWithFile:@"Title.png"];
        background.rotation = 0;
        background.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:background z:-1];
        
        // create and initialize a Label
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Click Here(´・∀・｀)" fontName:@"Helvetica" fontSize:20];
        label.color = ccc3(255,255,255);
        CCMenuItemLabel *item = [CCMenuItemLabel itemWithLabel:label
                                                        target:self selector:@selector(pushed:)];
        CCMenu *menu = [CCMenu menuWithItems:item, nil];
        menu.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:menu];
    
    }
    return self;
}

-(void)pushed:(id)sender {
    GameScene *gameScene = [GameScene sharedInstance];
    CCScene *transition = [CCTransitionFade transitionWithDuration:1.0 scene:gameScene withColor:ccc3(255, 255, 255)];
    [[CCDirector sharedDirector] replaceScene:transition];
}
@end
