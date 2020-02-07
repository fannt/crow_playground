
-- params
top = 170 -- top bpm
bottom = 60 -- bottom bpm
rate = 0.1 -- scan rate

hysteresis = 5 -- loops 
threshold = 4.5 --volts

-- vars
bpm = 120
loops = 0 -- scans since last beat detected

function init()
    input[1]{ mode = 'stream', time = rate }
end

input[1].stream = computeBpm(state)
    output[1].level = currentCV()
end

function computeBpm(value)
    if loops < hysteresis then loops = loops + 1 return end
    if value > threshold then 
        bpm = loops * rate * 60 
        loops = 0
    end 
    loops = loops + 1
end

function currentCV()
    max = 5
    min = 0

    -- normalize

    normBPM = bpm
    if normBPM > top then normBPM = top end
    if normBPM < bottom then normBPM = bottom end

    -- compute

    cv =  max * normBPM / (top - bottom)
    return cv
end 