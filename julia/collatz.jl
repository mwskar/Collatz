#!/usr/bin/julia

struct Item
    num::Int64
    sequencelen::Int64
end

function collatz(inNum)
    local number = inNum
    local counter = 0
    while (number != 1)
        if (number % 2 == 0)
            number = fld(number,2)
        else
            number = (number * 3) + 1
        end
        counter = counter + 1
    end
    return counter
end

function prepList()
    local blankItem = Item(-1,-1)
    local blankArr = Vector{Item}(undef, 10)

    for i in 1:10
        blankArr[i] = blankItem
    end

    return blankArr
end


function updateSequence(vec::Vector{Item}, insert::Item)
    local difference
    local magnitude
    local itemHold
    for i in 10:-1:1
        itemHold = vec[i]
        difference = insert.sequencelen - itemHold.sequencelen
        magnitide = insert.num - itemHold.num

        if (difference > 0)
            for j in 1:i-1
                vec[j] = vec[j+1]
            end

                vec[i] = insert
            
            break
        elseif (difference == 0 && magnitude < 0)
            vec[i] = insert
            break
        elseif (difference == 0 && magnitide > 0)
            break
        end
        
    end # End of for loop
    
    return vec
end


function updateMag(vec::Vector{Item})
    local tempArr = prepList()
    local seqItem
    local magItem


    for i in 10:-1:1
        seqItem = vec[i]

        for k in 10:-1:1
            magItem = tempArr[k]


            if (seqItem.num > magItem.num)
            
                for l in 1:k-1
                    tempArr[l] = tempArr[l + 1]
                end
                tempArr[k] = seqItem
                break
            end # End adding

        end #End inner loop


    end # End outer for loop
    
    return tempArr

end # End func update Magnitude



#######################
######   Main  ########
#######################




begin

local number = 1
local last = 10
local seqholder = 0
local seqArr = Vector{Item}(undef, 10)
local magArr

seqArr = prepList()

while (number <= last)
    seqholder = collatz(number)

    if (seqholder > seqArr[1].sequencelen)
        seqArr = updateSequence(seqArr, Item(number,seqholder))
    end # End of if add
    
    number += 1
end # End while loop for number bounds


magArr = updateMag(seqArr)


println(seqArr[1:end])
println(magArr[1:end])

end # End of main