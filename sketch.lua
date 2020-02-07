
-- params
top = 1000 -- top bpm
bottom = 50 -- bottom bpm
rate = 0.005 -- scan rate

-- hysteresis = 10 -- loops 
threshold = 4.5 --volts

-- vars
bpm = 120
loops = 0 -- scans since last beat detected

input[1].stream = function(state)
    computeBpm(state)
    output[1].volts = currentCV()
end

function computeBpm(value)
    -- if value then unwrapedValue = value end
    -- if loops < hysteresis then lastValue = value return end

    loops = loops + 1
    if value > threshold then -- detect 
        if value > lastValue then --and rise
            if lastValue < threshold then --pass
                -- print(loops)
                -- loopsPerSec = loops / rate
                period = rate * loops
                -- print(period)
                bpm = 60 / period
                -- print(bpm)
                loops = 1
            end
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