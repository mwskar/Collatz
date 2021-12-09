program collatz

!! 'Item' struct to hold onto paired data
type item
    integer*8 :: number, sequenceLen
end type


type(item) :: magnitudeArr(1:10), lengthArr(1:10), itemHold
character(1000) :: arg
integer*8 :: userInput, sequenceLen, counter

call get_command_argument (1 , arg)
read (arg, *) userInput

call prepList

do counter = 1, userInput
    sequenceLen = calcCollatz(counter)

    itemHold%number = counter
    itemHold%sequenceLen = sequenceLen
    call updateSequence
end do

call updateMagnitude

print*, "Sorted by sequence length"
do i = 10, 1, -1
    print *, lengthArr(i)
end do


print*, "Sorted by integer size"
do i = 10, 1, -1
    print*, magnitudeArr(i)
end do

!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!    subroutines  !!!!
!!!!!!!!!!!!!!!!!!!!!!!!!

contains

!! Returns an array of ten 'Items' with -1 for both values

subroutine prepList
integer :: i

    do i = 1, 10
        lengthArr(i)%number = -1
        lengthArr(i)%sequenceLen = -1
        magnitudeArr(i)%number = -1
        magnitudeArr(i)%sequenceLen = -1
    end do
end subroutine prepList




!! Updates the sequence array using an insertion sort
!! 'Items' are ranked based upon the length of their collatz sequence length
!! Array is organized lowest -> highest
subroutine updateSequence

integer*8 :: difference, magnitude, i, l

    !! Iterate backwards through sequence array
    do i = 10, 1, -1
        
        !! Calculate variables for easy checking
        difference = itemHold%sequenceLen - lengthArr(i)%sequenceLen
        magnitude = itemHold%number - lengthArr(i)%number

        !!  When the input sequence is greater,
        !! shift all items down and place the new item at
        !! the location
        !! insert the new item
        if ( difference > 0) then
            do l = 1, i - 1, 1
                lengthArr(l) = lengthArr(l+1)
            end do
            lengthArr(i) = itemHold
            return
        
        !! The next two statemnts keep the item with the
        !! lowest integer when they have the same sequence length
        elseif (difference == 0 .and. magnitude > 0) then
            !print *, "IN elif"
            !lengthArr(i) = itemHold
            return
        elseif (difference == 0 .and. magnitude < 0) then
            lengthArr(i) = itemHold
            return
        end if
    
    end do
end subroutine updateSequence


!! Update the magArray with the contents of seqArray
subroutine updateMagnitude

integer :: i, l, k
type (item) :: seqItem, magItem


!! For every item in the sequence array
!! Starting from the end
do i = 10, 1, -1
    seqItem = lengthArr(i) ! save the item from the seqArray
    
    !! Search through the magArray for the correct spot
    do l = 10, 1, -1
        magItem = magnitudeArr(l) ! save the item from the magArray
        
        !! If the sequence item is greater than the current magItem
        if (seqItem%number > magItem%number) then
            
            !! Move all items down
            do k = 1, l - 1, 1
                magnitudeArr(k) = magnitudeArr(k+1) 
            end do
            magnitudeArr(l) = seqItem ! Insert the item
            exit
        
        end if
    end do
end do

end subroutine updateMagnitude



end program collatz


!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!      Functions      !!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!

!! Calculates the collatz sequence length for a number
recursive function calcCollatz(input) result(ans)
integer*8, intent (in) :: input

    if (input == 1) then
        ans = 0
    elseif (mod(input,2) == 0) then
        ans = 1 + calcCollatz(input / 2)
    else
        ans = 1 + calcCollatz((3 * input) + 1)
    end if


end function calcCollatz
