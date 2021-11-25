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

            (tempArr '())

        ); end of vars

        (dotimes (i 10)
            (setf tempArr (append tempArr ( list blankItem)))
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

        (when (= numHold 0)
            (return-from calcCollatz 0)
        )

        (loop
            (if (= 0 (mod numHold 2) )
                (setf numHold (/ numHold 2) )
                (setf numHold (+ 1 (* 3 numHold ) ) )
            )
            (setf counter (+ counter 1))
            (when (= numHold 1) (return counter)  )
        )
        (return-from calcCollatz counter)
    ) ; end let
)


(defvar updateSequence(lengthArr)
    (let
        (
            (run 1)
            (difference 0)
            (magnitude 0)
        ); end vars

        (dolist (i lengthArr)
            ;(setf difference (- (item-itemSequenceLen itemHold) 
            ;            ( item-itemSequenceLen i) ) )
            (print i)
        )

    ); end let
)

;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; Main ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;


(defvar magnitudeArr '() )
(defvar lengthArr '() )

(defvar itemHold
    (make-item
        :itemNumber 0
        :itemSequenceLen 0
    )
)

(defvar seqLen 0)
(defvar num 0)

(setf magnitudeArr (prepArr) )
(setf lengthArr (prepArr) )


(dotimes (i 12)
    (setq seqLen (calcCollatz i))
    (setq itemHold (make-item :itemNumber i :itemSequenceLen seqLen))
    ;(print itemHold)
    ;(setq lengthArr (updateSequence lengthArr itemHold))
    (updateSequence lengthArr)
)

;(dolist (i lengthArr)
;    (print (item-itemNumber i))
;)