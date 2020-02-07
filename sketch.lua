
-- params
top = 220 -- top bpm
bottom = 30 -- bottom bpm
rate = 0.05 -- scan rate

hysteresis = 10 -- loops 
threshold = 4.2 --volts

-- vars
bpm = 120
loops = 0 -- scans since last beat detected
lastValue = 0

input[1].stream = function(state)
    computeBpm(state)
    output[1].volts = currentCV()
end

function computeBpm(value)
    -- if value then unwrapedValue = value end
    loops = loops + 1
    if loops < hysteresis then lastValue = value return end
    if value > threshold then -- detect 
        if value > lastValue then --and rise
            -- print(loops)
            bpm = loops * rate * 60 
            print(bpm)
            loops = 0
        end
    end
    lastValue = value
end

function currentCV()
    max = 5
    min = 0

    -- normalize

    normBPM = bpm
    if normBPM > top then normBPM = top end
    if normBPM < bottom then normBPM = bottom end

    -- compute
    cv =  max * normBPM / top
    return cv
end 

function init()
    input[1]{ mode = 'stream', time = rate }
    output[1].slew = 0.1
end