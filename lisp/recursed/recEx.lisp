#!/usr/bin/sbcl --script


(defun fact (num)
    (if (= num 1)
        (return-from fact 1)
        (return-from fact (* num (fact (- num 1))) )
    )
)



(loop for i from 1 to 17 do
    (format t "~D" i)
    (format t "  ")
    (format t "~D" (fact i))
    (terpri)
)