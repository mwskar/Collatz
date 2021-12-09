package main

import "fmt"
import "os"
import "strconv"

// 'Item' struct to hold onto paired data
type item struct{
	number int64
	sequenceLength int64
}


func main(){
	var counter int64 = 1
	var endNum int64
	
	// Set all 'items' in the array to -1 -1
	var seqArray [10]item = prepList()

	endNum, _ = strconv.ParseInt(os.Args[1], 10, 64)

	// Runs for the user input range
	for counter <= endNum {
		itemHold := item{
					number: counter,
					sequenceLength: collatz(counter)} //Get collatz sequence length
		
		// Update the sequence array with a new item
		seqArray = updateSequence(seqArray, itemHold)
		counter++
	}

	// Update the magnitude array
	magArray := updateMagnitude(seqArray)
	
	
	// Format print the arrays

	fmt.Println("Sorted by sequence length")
	for i := 9; i>-1; i--{
		itemHold := seqArray[i]
		fmt.Print(itemHold.number, itemHold.sequenceLength)
		fmt.Println("")
	}

	fmt.Println("")
	fmt.Println("Sorted by integer size")
	for i := 9; i>-1; i--{
		itemHold := magArray[i]
		fmt.Print(itemHold.number, itemHold.sequenceLength)
		fmt.Println("")
	}

} // end of main


/*
//////////////////////////////////
			Functions
//////////////////////////////////
*/

// Calculates the collatz sequence length for a number
func collatz(numberInput int64) int64 {
	if (numberInput == 1){
		return 0
	} else if (numberInput % 2 == 0){
		return 1 + collatz(numberInput / 2)
	} else{
		return 1 + collatz( (numberInput * 3) + 1 )
	}
}

// Returns an array of ten 'Items' with -1 for both values
func prepList() [10]item{
	blankItem := item {-1 , -1}
	var blankArr [10]item
	for i:= 0; i < 10; i++ {
		blankArr[i] = blankItem
	}
	return blankArr
}


// Updates the sequence array using an insertion sort
// 'Items' are ranked based upon the length of their collatz sequence length
// Array is organized lowest -> highest
func updateSequence(seqArray [10]item, newItem item) [10]item{
	var difference int64
	var magnitude int64
	var holdArr [10]item = seqArray
	
	
	// Iterate backwards through sequence array
	for i:=9; i >= 0; i--{
		
		//Calculate variables for easy checking
		magnitude = newItem.number - seqArray[i].number
		difference = newItem.sequenceLength - seqArray[i].sequenceLength

		//  When the input sequence is greater,
        // shift all items down and place the new item at
        // the location
        // insert the new item
		if (difference > 0){
			for k:=0; k < i; k++{
				holdArr[k] = holdArr[k+1]
			}
			holdArr[i] = newItem
			return holdArr

		// The next two statemnts keep the item with the
		// lowest integer when they have the same sequence length
		} else if (difference == 0 && magnitude > 0){
			return holdArr
		}else if (difference == 0 && magnitude < 0){
			holdArr[i] = newItem
			return holdArr
		}
	}

	return holdArr
}


//Update the magArray with the contents of seqArray
func updateMagnitude(seqArray [10]item) [10]item{
	var holdArr [10]item = prepList()
	var seqItem item
	var magItem item
	
	
    // For every item in the sequence array
    // starting from the end
	for i:=9; i >= 0; i--{
		seqItem = seqArray[i] // save the item from the seqArray

		// Search through the magArray for the correct spot
		for k:=9; k >= 0; k--{
			magItem = holdArr[k] //save the item from the magArray

			// If the sequence item is greater than the current magItem
			if (seqItem.number > magItem.number){
				
				// Move all items down
				for l:=0;l<k;l++{
					holdArr[l] = holdArr[l+1]
				}
				holdArr[k] = seqItem // Insert the item
				break
			}
		}
	} 
	return holdArr
}
