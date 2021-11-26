package main

import "fmt"

type item struct{
	number int64
	sequenceLength int64
}


func main(){
	//var sequenceLen int64 = 0
	var i int64 = 1
	var end int64 = 28
	var seqArray [10]item = prepList()

	for i < end {
		//sequenceLen := collatz(i)
		itemHold := item{
					number: i,
					sequenceLength: collatz(i)}
		//fmt.Print(itemHold)
		seqArray = updateSequence(seqArray, itemHold)
		i++
	}

	magArray := updateMagnitude(seqArray)
	fmt.Println(seqArray)
	fmt.Println(magArray)

} // end of main


/*
//////////////////////////////////
			Functions
//////////////////////////////////
*/


func collatz(numberInput int64) int64 {
	if (numberInput == 1){
		return 0
	} else if (numberInput % 2 == 0){
		return 1 + collatz(numberInput / 2)
	} else{
		return 1 + collatz( (numberInput * 3) + 1 )
	}
}

func prepList() [10]item{
	blankItem := item {-1 , -1}
	var blankArr [10]item
	for i:= 0; i < 10; i++ {
		blankArr[i] = blankItem
	}
	return blankArr
}


func updateSequence(seqArray [10]item, newItem item) [10]item{
	var difference int64
	var magnitude int64
	var holdArr [10]item = seqArray
	for i:=9; i >= 0; i--{
		magnitude = newItem.number - seqArray[i].number
		difference = newItem.sequenceLength - seqArray[i].sequenceLength

		if (difference > 0){
			for k:=0; k < i; k++{
				holdArr[k] = holdArr[k+1]
			}
			holdArr[i] = newItem
			return holdArr
		} else if (difference == 0 && magnitude > 0){
			return holdArr
		}else if (difference == 0 && magnitude < 0){
			holdArr[i] = newItem
			return holdArr
		}
	}

	return holdArr
}



func updateMagnitude(seqArray [10]item) [10]item{
	var holdArr [10]item = prepList()
	var seqItem item
	var magItem item
	
	for i:=9; i >= 0; i--{
		seqItem = seqArray[i]

		for k:=9; k >= 0; k--{
			magItem = holdArr[k]

			if (seqItem.number > magItem.number){
				for l:=0;l<k;l++{
					holdArr[l] = holdArr[l+1]
				}
				holdArr[k] = seqItem
				break
			}

		}
	} 

	return holdArr
}
