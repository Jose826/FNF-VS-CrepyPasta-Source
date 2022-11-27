local dirrChangeFound = false
local floatshitY = 0
local floatshitX = 0
local shouldBop = false
local angleshit = 1;
local anglevar = 1;

function onCreate()
    print(songName)

    if songName == 'unhealing' then
        setProperty('camHUD.y', getProperty('camHUD.y') - 20)
    end

    if songName == 'only-me' then
        addVcrCamEffect('game');
        addVcrCamEffect('hud');
        addVcrCamEffect('vfx');
    end

    if songName == 'test' then
        -- here i test the vcr effect lmaooooooo
        addVcrCamEffect('game');
        addVcrCamEffect('hud');
        addVcrCamEffect('vfx');
    end
end

function onUpdate(elapsed)
    floatshitY = floatshitY + 0.1
    floatshitX = floatshitX + 0.1
    knucklesX = getProperty('knucklesMouse.x');
    knucklesY = getProperty('knucklesMouse.y');
    songPos = getSongPosition()
    local currentBeat = (songPos / 1000) * (bpm / 60)
    if songName == 'Perish-old' then
        setProperty('camHUD.x', getProperty('camHUD.x') + math.sin(floatshitX))
    end

    if songName == 'unhealing' then
        setProperty('camHUD.y', getProperty('camHUD.y') + math.sin(floatshitY))
    end

    if songName == 'Found-you' then
        noteTweenY('defaultPlayerStrumY0', 4, defaultPlayerStrumY0 - 40*math.sin((currentBeat+4*0.25)*math.pi), 0.5)
        noteTweenY('defaultPlayerStrumY1', 5, defaultPlayerStrumY1 - 40*math.sin((currentBeat+5*0.25)*math.pi), 0.5)
        noteTweenY('defaultPlayerStrumY2', 6, defaultPlayerStrumY2 - 40*math.sin((currentBeat+6*0.25)*math.pi), 0.5)
        noteTweenY('defaultPlayerStrumY3', 7, defaultPlayerStrumY3 - 40*math.sin((currentBeat+7*0.25)*math.pi), 0.5)
        
        noteTweenY('defaultOpponentStrumY0', 0, defaultOpponentStrumY0 + 40*math.sin((currentBeat+0*0.25)*math.pi), 0.5)
        noteTweenY('defaultOpponentStrumY1', 1, defaultOpponentStrumY1 + 40*math.sin((currentBeat+1*0.25)*math.pi), 0.5)
        noteTweenY('defaultOpponentStrumY2', 2, defaultOpponentStrumY2 + 40*math.sin((currentBeat+2*0.25)*math.pi), 0.5)
        noteTweenY('defaultOpponentStrumY3', 3, defaultOpponentStrumY3 + 40*math.sin((currentBeat+3*0.25)*math.pi), 0.5)

        setProperty('camHUD.x', getProperty('camHUD.x') + math.sin(floatshitX))
    end
end

function onBeatHit()
    if curBeat % 4 == 0 then
        if dirrChangeFound == true then
            dirrChangeFound = false
        end

        if dirrChangeFound == false then
            dirrChangeFound = true
        end
    end

    if curBeat % 2 == 0 then
        angleshit = anglevar;
    else
        angleshit = -anglevar;
    end
end