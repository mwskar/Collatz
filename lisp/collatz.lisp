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

;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; Main ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;


(defvar magnitudeArr (make-array '(10) ) )
(defvar lengthArr (make-array '(10) ) )


(defvar itemHold
    (make-item
        :itemNumber 0
        :itemSequenceLen 0
    )
)

(defvar seqLen 0)

;(setf magnitudeArr (prepArr) )
(setf lengthArr (prepArr) )


(dotimes (i 12)
    (setq seqLen (calcCollatz i))
    (setq itemHold (make-item :itemNumber i :itemSequenceLen seqLen))
    
    ;(print itemHold)
    ;(print lengthArr)
    ;(terpri)
    
    (setq lengthArr (updateSequence lengthArr itemHold))
    ;(print lengthArr)
    ;(terpri)
)

;(dotimes (i 10)
;    (print (item-itemNumber (aref lengthArr i)))
;)

(print lengthArr)
(terpri)