program collatz

type item
    integer*8 :: number, sequenceLen
end type


type(item) :: magnitudeArr(1:10), lengthArr(1:10), itemHold

integer*8 :: userInput, sequenceLen, arraySize, i

!! Get user input
!write(*,'(A)', advance = 'NO') "Please enter a positive number: "
!read(*,*) userInput


arraySize = 10

call prepList

do i = 1, 1000000
    sequenceLen = calcCollatz(i)
    !print*, i, sequenceLen
    !print*, ""

    itemHold%number = i
    itemHold%sequenceLen = sequenceLen
    !print*, itemHold
    !print*, ""
    call updateSequence
    !print*, "Checking : ", i
end do

call updateMagnitude

do i = 1, arraySize
    print *, lengthArr(i), "    |   ", magnitudeArr(i)
end do

!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!    subroutines  !!!!
!!!!!!!!!!!!!!!!!!!!!!!!!

contains

subroutine prepList
integer :: i

    do i = 1, arraySize
        lengthArr(i)%number = -1
        lengthArr(i)%sequenceLen = -1
        magnitudeArr(i)%number = -1
        magnitudeArr(i)%sequenceLen = -1
    end do
end subroutine prepList

subroutine updateSequence

integer*8 :: difference, magnitude, i, l

    !print *, "IN updateSequence"

    do i = arraySize, 1, -1
        
        difference = itemHold%sequenceLen - lengthArr(i)%sequenceLen
        magnitude = itemHold%number - lengthArr(i)%number
        !print *, "Chekcking :", itemHold%number, "|   diff: ", difference, "|   mag: ", magnitude
        if ( difference > 0) then
            do l = 1, i - 1, 1
                lengthArr(l) = lengthArr(l+1)
            end do
            lengthArr(i) = itemHold
            return
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

subroutine updateMagnitude

integer :: i, l, k
type (item) :: seqItem, magItem

do i = arraySize, 1, -1
    seqItem = lengthArr(i)
    
    do l = arraySize, 1, -1
        magItem = magnitudeArr(l)
        
        if (seqItem%number > magItem%number) then
            do k = 1, l - 1, 1
                magnitudeArr(k) = magnitudeArr(k+1)
            end do
            magnitudeArr(l) = seqItem
            exit
        
        end if
    end do
end do

end subroutine updateMagnitude



end program collatz


!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!      Functions      !!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!


function calcCollatz(input)
integer*8, intent (in) :: input
integer*8 :: number, counter

counter = 0
number = input
do while (number /= 1)
    if (mod(number,2) == 0) then
        number = number / 2
    else 
        number = (number * 3) + 1
    end if
    counter = counter + 1
end do

calcCollatz = counter
end function calcCollatz
