#!/usr/bin/sbcl --script


(defstruct item
    itemNumber
    itemSequenceLen
)


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


(defun calcCollatz(inNum)
    (let
        (
            (counter 0)
            (numHold inNum)
        ); end vars

        (when (< numHold 2)
            (return-from calcCollatz 0)
        )

        (loop
            (if (= 0 (mod numHold 2) )
                (setf numHold (floor numHold 2) )
                (setf numHold (+ 1 (* 3 numHold ) ) )
            )
            (setf counter (+ counter 1))
            (when (= numHold 1) (return counter)  )
        )
        (return-from calcCollatz counter)
    ) ; end let
)


(defun updateSequence(lengthArr inItem)
    (let
        (
            (run 1)
            (difference 0)
            (magnitude 0)
            (arrItem)
        ); end vars

        (dotimes (i 10)
            (setf arrItem (aref lengthArr (- 9 i) ) )
            ;(print arrItem)
            ;(print inItem)
            (setf difference (- (item-itemSequenceLen inItem) (item-itemSequenceLen arrItem)))
            (setf magnitude (- (item-itemNumber inItem) (item-itemNumber arrItem)))


            (when (> difference 0)
                (dotimes (j (- 9 i))
                        (setf (aref lengthArr j) (aref lengthArr (+ j 1)))
                ); end do loop
                (setf (aref lengthArr (- 9 i)) inItem)
                (return-from updateSequence lengthArr)
            ) ; end when
            (when (and (= difference 0) (> magnitude 0))
                (return-from updateSequence lengthArr)
            ); end when
            (when (or (= difference 0) (< magnitude 0))
                (setf (aref lengthArr i) inItem)
                (return-from updateSequence lengthArr)
            ); end when


        ); end do times


    (return-from updateSequence lengthArr)

    ); end let
) ; End function updateSequence


(defun updateMagnitude(seqArr)
    (let
        (
            (magArr (prepArr))
            (seqItem)
            (magItem)
        ); end vars

        (dotimes (x 10)

            (setf seqItem (aref seqArr (- 9 x)))

            (block magLoop

            (dotimes (i 10)
                (setf magItem (aref magArr (- 9 i) ) )
                
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


(defvar itemHold
    (make-item
        :itemNumber 0
        :itemSequenceLen 0
    )
)

(defvar seqLen 0)
(defvar counter)
(setf counter 1)

(setf lengthArr (prepArr) )


(loop 
    (setq seqLen (calcCollatz counter))
    (setq itemHold (make-item :itemNumber counter :itemSequenceLen seqLen))
    
    
    (setq lengthArr (updateSequence lengthArr itemHold))
    (when (= counter endNum) (return nil) )
    (incf counter)
)

(setf magnitudeArr (updateMagnitude lengthArr))

(print lengthArr)
(terpri)
(print magnitudeArr)
(terpri)