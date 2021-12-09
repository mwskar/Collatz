#!/usr/bin/julia

## 'Item' struct to hold onto paired data
struct Item
    num::Int64
    sequencelen::Int64
end

## Calculates the collatz sequence length for a number
function collatz(inNum)
    local number = inNum
    local counter = 0
    if (number < 2) return 0

    if (number % 2 == 0)
        return 1 + collatz( fld(number,2) )
    else
        return 1 + collatz( (number * 3) + 1)
    end
end

## Returns an array of ten 'Items' with -1 for both values
function prepList()
    local blankItem = Item(-1,-1)
    local blankArr = Vector{Item}(undef, 10)

    for i in 1:10
        blankArr[i] = blankItem
    end

    return blankArr
end


## Updates the sequence array using an insertion sort
## 'Items' are ranked based upon the length of their collatz sequence length
## Array is organized lowest -> highest
function updateSequence(vec::Vector{Item}, insert::Item)
    local difference
    local magnitude
    local itemHold

    # Iterate backwards through sequence array
    for i in 10:-1:1
        itemHold = vec[i] # Hold onto item at location

        #Calculate variables for easy checking
        difference = insert.sequencelen - itemHold.sequencelen
        magnitude = insert.num - itemHold.num


        ##  When the input sequence is greater,
        ## shift all items down and place the new item at
        ## the location
        ## insert the new item
        if (difference > 0)
            for j in 1:i-1
                vec[j] = vec[j+1]
            end

                vec[i] = insert
            
            break
        
        ## The next two statemnts keep the item with the
        ## lowest integer when they have the same sequence length
        elseif (difference == 0 && magnitude < 0)
            vec[i] = insert
            break
        elseif (difference == 0 && magnitude > 0)
            break
        end
        
    end # End of for loop
    
    return vec
end


#Update the magArray with the contents of seqArray
function updateMag(vec::Vector{Item})
    local tempArr = prepList()
    local seqItem
    local magItem

    # For every item in the sequence array
    # starting from the end
    for i in 10:-1:1
        seqItem = vec[i] #save the item from the seqArray

        # Search through the magArray for the correct spot
        for k in 10:-1:1
            magItem = tempArr[k] #save the item from the magArray

            # If the sequence item is greater than the current magItem
            if (seqItem.num > magItem.num)
                # Move all items down
                for l in 1:k-1
                    tempArr[l] = tempArr[l + 1]
                end
                tempArr[k] = seqItem # Insert the item
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
local seqholder = 0
local seqArr = Vector{Item}(undef, 10)
local magArr
local lastNum = parse(Int64, ARGS[1])

# Set all 'items' in the array to -1 -1
seqArr = prepList()

#Runs for the user input range
while (number <= lastNum)

    seqholder = collatz(number) # Get the collatz sequence
 
    #If the new seqence is greater than or equal to the least sequence
    if (seqholder >= seqArr[1].sequencelen)
        
        #Update the sequence array with a new item
        seqArr = updateSequence(seqArr, Item(number,seqholder))
    end # End of if add
    
    number += 1
end # End while loop for number bounds

# Update the magnitude array
magArr = updateMag(seqArr)


# Format print the arrays

println("Sorted by sequence length")
for i in 10:-1:1
    println(seqArr[i].num, " | ", seqArr[i].sequencelen)
end

println("")
println("Sorted by integer size")
for i in 10:-1:1
    println(magArr[i].num, " | ", magArr[i].sequencelen)
end


end # End of main