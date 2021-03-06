--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

GameOverScene = class("GameOverScene", function()
    return cc.Scene:create()
end)

function GameOverScene:ctor()
    
end

function GameOverScene:create()
    local scene = GameOverScene.new()
    scene:addChild(scene:createLayer())

    return scene
end

function GameOverScene:loadingMusic()
    if Global:getInstance():getAudioState() == true then
        cc.SimpleAudioEngine:getInstance():stopMusic()
        cc.SimpleAudioEngine:getInstance():playMusic("Music/mainMainMusic.mp3", true)
    else
        cc.SimpleAudioEngine:getInstance():stopMusic()
    end
end

function GameOverScene:addBG()
    -- 背景图片
    local bg = cc.Sprite:create("loading.png")
    bg:setPosition(cc.p(WIN_SIZE.width / 2, WIN_SIZE.height / 2))
    self:addChild(bg, -1)

    -- logo
    local logo = cc.Sprite:create("gameOver.png")
    logo:setPosition(cc.p(WIN_SIZE.width/2, WIN_SIZE.height/2 + 150))
    self:addChild(logo, 10)

    -- 分数
    local highScore = Global:getInstance():getHighScore()
    local score = Global:getInstance():getScore()
    local showNewMark = false

    -- 新纪录
    if score > highScore then
        Global:getInstance():setHighScore(score)
        highScore = score
        showNewMark = true
    end

    local lbHighScore = cc.Label:createWithBMFont("res/Font/bitmapFontTest.fnt", ("HighScore : " .. highScore))
    local lbScore = cc.Label:createWithBMFont("res/Font/bitmapFontTest.fnt",     ("Score        : " .. score))
    lbHighScore:setAnchorPoint(cc.p(0, 0))
    lbScore:setAnchorPoint(cc.p(0, 0))
    lbHighScore:setPosition(cc.p(WIN_SIZE.width/2 - 100, WIN_SIZE.height/2 + 50))
    lbScore:setPosition(cc.p(WIN_SIZE.width/2 - 100, WIN_SIZE.height/2))
    lbHighScore:setScale(0.5)
    lbScore:setScale(0.5)
    self:addChild(lbHighScore)
    self:addChild(lbScore)

    if showNewMark == true then
        local newMark = cc.Label:createWithSystemFont("新纪录!", "Arial", 20)
        newMark:setColor(cc.c3b(255, 0, 255))
        newMark:setRotation(-45)
        newMark:setPosition(lbHighScore:getPositionX() - 10, lbHighScore:getPositionY() + 30)
        self:addChild(newMark)
        local fadeIn = cc.FadeTo:create(1.0, 100)
        local delay = cc.DelayTime:create(0.5)
        local fadeOut = cc.FadeTo:create(1.0, 255)
        local seq = cc.Sequence:create(fadeIn, fadeOut, delay)
        local act = cc.RepeatForever:create(seq)
        newMark:runAction(act)
    end
end

-- 添加按钮
function GameOverScene:addBtn()
    local function callback(tag, sender)
        if sender:getTag() == 101 then
            self:turnToGameScene()
        else
            self:turnToLoadingScene()
        end
    end

    -- 重新游戏 tag = 101
    local playAgainNormal = cc.Sprite:create("menu.png", cc.rect(378, 0, 126, 33))
    local playAgainSelected = cc.Sprite:create("menu.png", cc.rect(378, 33, 126, 33))
    local playAgainDisabled = cc.Sprite:create("menu.png", cc.rect(378, 2 * 33, 126, 33))
    local playAgain = cc.MenuItemSprite:create(playAgainNormal, playAgainSelected, playAgainDisabled)
    playAgain:setTag(101)
    playAgain:registerScriptTapHandler(callback)

    -- 返回菜单
    local backNormal = cc.Sprite:create("menu.png", cc.rect(505, 1, 126, 31))
    local backSelected = cc.Sprite:create("menu.png", cc.rect(505, 34, 126, 31))
    local backDesabled = cc.Sprite:create("menu.png", cc.rect(505, 34*2, 126, 31))
    local back = cc.MenuItemSprite:create(backNormal, backSelected, backDesabled)
    back:setTag(102)
    back:registerScriptTapHandler(callback)

    -- 创建菜单
    local pmenu = cc.Menu:create(playAgain, back)
    pmenu:setPosition(cc.p(WIN_SIZE.width / 2, WIN_SIZE.height / 2 - 100))
    self:addChild(pmenu, 1, 3)
    pmenu:alignItemsVerticallyWithPadding(40)
end

-- 重新游戏
function GameOverScene:turnToGameScene()
    local scene = GameScene:create()
    local trans = cc.TransitionFade:create(1.0, scene)
    cc.Director:getInstance():replaceScene(trans)
end

-- 返回主界面
function GameOverScene:turnToLoadingScene()
    local scene = LoadingScene:create()
    local trans = cc.TransitionFade:create(1.0, scene)
    cc.Director:getInstance():replaceScene(trans)
end

function GameOverScene:createLayer()
    local layer = cc.Layer:create()

    self:loadingMusic()
    self:addBG()
    self:addBtn()

    return layer
end

return GameOverScene

--endregion
