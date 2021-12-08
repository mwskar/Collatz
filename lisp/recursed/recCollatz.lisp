#!/usr/bin/sbcl --script

;; Defines the struct for an item to be placed in an array
(defstruct item
    itemNumber
    itemSequenceLen
)


;; Returns an array of ten 'Items' with -1 for both values
(defun prepArr()
    (let
        (
            (blankItem
                (make-item
                    :itemNumber -1
                    :itemSequenceLen -1
                )
            )

            (tempArr (make-array '(10)))

        ); end of vars

        (dotimes (i 10)
            (setf (aref tempArr i) blankItem )
        ); end do

        (return-from prepArr tempArr)

    ) ; end of let space
)

;; Calcualtes the sequence length of the input number
(defun calcCollatz(inNum)
    (let
        (

        ); end vars

        (when (< inNum 2)
            (return-from calcCollatz 0)
        )
        
        (if (= 0 (mod inNum 2) )
            (return-from calcCollatz (+ 1 (calcCollatz (floor inNum 2) ) ) )
            (return-from calcCollatz (+ 1 (calcCollatz (+ 1 (* 3 inNum ) ) ) ) )
        )
    ) ; end let
)

;; Updates the sequence array using an insertion sort
;; 'Items' are ranked based upon the length of their collatz sequence length
;; Array is organized lowest -> highest
(defun updateSequence(lengthArr inItem)
    (let
        (
            (run 1)
            (difference 0)
            (magnitude 0)
            (arrItem)
        ); end vars

        ;; iterates through the array backwards
        (dotimes (i 10)
            (setf arrItem (aref lengthArr (- 9 i) ) )
            (setf difference (- (item-itemSequenceLen inItem) (item-itemSequenceLen arrItem)))
            (setf magnitude (- (item-itemNumber inItem) (item-itemNumber arrItem)))


            ;; When the input sequence is greater,
            ;; shift all items down and place the new item at
            ;; the location
            ;; insert the new item
            (when (> difference 0)
                (dotimes (j (- 9 i))
                        (setf (aref lengthArr j) (aref lengthArr (+ j 1)))
                ); end do loop
                (setf (aref lengthArr (- 9 i)) inItem)
                (return-from updateSequence lengthArr)
            ) ; end when


            ;; The next two statemnts keep the item with the
            ;; lowest integer when they have the same sequence lenght

            (when (and (= difference 0) (> magnitude 0))
                (return-from updateSequence lengthArr)
            ); end when

            (when (or (= difference 0) (< magnitude 0))
                (setf (aref lengthArr i) inItem)
                (return-from updateSequence lengthArr)
            ); end when

        ); end do times


    ;; Return the updated array
    (return-from updateSequence lengthArr)

    ); end let
) ; End function updateSequence


;; Uses an insertion sort to arrange the magArray
;; based on the values of the integers
;; takes the sequence array as input

(defun updateMagnitude(seqArr)
    (let
        (
            (magArr (prepArr))
            (seqItem)
            (magItem)
        ); end vars

        ;; Go through the sequence array backwards
        (dotimes (x 10)

            (setf seqItem (aref seqArr (- 9 x)))


            ;; Using a block allows for easy exiting of the next loop
            (block magLoop

            ;; Find approporiate spot in the magArray going backwards
            (dotimes (i 10)
                (setf magItem (aref magArr (- 9 i) ) )
                
                ;; Shift all items down and place the held
                ;; sequence item at the location
                (when (> (item-itemNumber seqItem) (item-itemNumber magItem) )
                    (dotimes (j (- 9 i))
                            (setf (aref magArr j) (aref magArr (+ j 1)))
                    ); end do loop
                    (setf (aref magArr (- 9 i)) seqItem)
                    (return-from magLoop magArr)
                ) ; end when
            ); end do times

            ); end of magLoop block

        ); end outer do times

        (return-from updateMagnitude magArr)

    ); end let
)

;; Allows for taking cpommand line arguments
(defun argv ()

    ( or
        #+clisp (ext:argv)
        #+sbcl sb-ext:*posix-argv*
    )

) ; end command line args


;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; Main ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;

(defvar args)
(defvar endNum)
( setq args ( argv ) )
(setq endNum (parse-integer (nth 1 args)))


(defvar magnitudeArr (make-array '(10) ) )
(defvar lengthArr (make-array '(10) ) )

;; A variable for holding a tempory 'Item'
(defvar itemHold
    (make-item
        :itemNumber 0
        :itemSequenceLen 0
    )
)

(defvar seqLen 0)
(defvar counter)
(setf counter 1)


; Set all items in the legnth array to -1 -1
(setf lengthArr (prepArr) )

;; Run for the entirety of the range input 
(loop 
    (setq seqLen (calcCollatz counter)) ; get the collatz sequence length and store it
    (setq itemHold (make-item :itemNumber counter :itemSequenceLen seqLen)) ; make an item object
    
    ;Update the sequence array
    (setq lengthArr (updateSequence lengthArr itemHold))


    (when (= counter endNum) (return nil) ) ; Exit when the end has been reached
    (incf counter)                          ; Else increment and contininue
)

; Update the magnitude array
(setf magnitudeArr (updateMagnitude lengthArr))


;;Format print the arrays

(format t  "Sorted by sequence length ~%")
(dotimes (i 10)
    (format t "~D ~D" (item-itemNumber (aref lengthArr (- 9 i) )) (item-itemSequenceLen(aref lengthArr (- 9 i))) )
    (terpri)
) ; end loop

(format t "~%")
(format t  "Sorted by integer size ~%")
(dotimes (i 10)
    (format t "~D ~D" (item-itemNumber (aref magnitudeArr (- 9 i) )) (item-itemSequenceLen(aref magnitudeArr (- 9 i))) )
    (terpri)
) ; end loop
