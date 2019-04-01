
;; Test printing in as-expression mode

(load-relative "loadtest.rktl")

(Section 'printing)

(require racket/flonum
         racket/fixnum)

(let ([ptest (lambda (s v)
               (define (to-string v)
                 (format "~v" v))
               (define (to-pretty-string v)
                 (pretty-format v))
               (test (regexp-replace* #rx"\n *" s " ") to-string v)
               (test s to-pretty-string v))])
  (define-struct a (x y))
  (define-struct b (x y) #:transparent)
  (define-struct c (x y) #:prefab)
  (define (custom-printer get-xy)
    (lambda (v port mode)
      (define-values (d-x d-y) (get-xy))
      (define (recur v)
        (case mode
          [(#f) (display v port)]
          [(#t) (write v port)]
          [else (print v port mode)]))
      (write-char #\< port)
      (write mode port)
      (write-char #\space port)
      (recur (d-x v))
      (write-char #\space port)
      (recur (d-y v))
      (write-char #\> port)))
  (define-struct d (x y) 
    #:property prop:custom-write (custom-printer (lambda () (values d-x d-y)))
    #:property prop:custom-print-quotable 'maybe)
  (define-struct e (x y) 
    #:property prop:custom-write (custom-printer (lambda () (values e-x e-y)))
    #:property prop:custom-print-quotable 'never)
  (define-struct f (x y) 
    #:property prop:custom-write (custom-printer (lambda () (values f-x f-y))))
  (define-struct f2 (x y) 
    #:property prop:custom-write (custom-printer (lambda () (values f2-x f2-y)))
    #:property prop:custom-print-quotable 'self)
  (define-struct g (x y) 
    #:property prop:custom-write (custom-printer (lambda () (values g-x g-y)))
    #:property prop:custom-print-quotable 'always)

  (ptest "1" 1)
  (parameterize ([print-boolean-long-form #f])
    (ptest "#t" #t)
    (ptest "#f" #f))
  (parameterize ([print-boolean-long-form #t])
    (ptest "#true" #t)
    (ptest "#false" #f))
  (ptest "1/2" 1/2)
  (ptest "#f" #f)
  (ptest "#\\x" #\x)
  (ptest "'apple" 'apple)
  (ptest "'|apple banana|" '|apple banana|)
  (ptest "'||" '||)
  (ptest "'#:apple" '#:apple)
  (ptest "'#%apple" '#%apple)
  (ptest "\"apple\"" "apple")
  (ptest "#\"apple\"" #"apple")
  (ptest "#rx\"apple\"" #rx"apple")
  (ptest "#rx#\"apple\"" #rx#"apple")
  (ptest "'()" '())
  (ptest "#<procedure:add1>" add1)
  (ptest "'<1 o t>" (d 'o 't))
  (ptest "<0 'o 't>" (e 'o 't))
  (ptest "<0 'o 't>" (f 'o 't))
  (ptest "<0 'o 't>" (f2 'o 't))
  (ptest "'<1 o t>" (g 'o 't))

  (ptest "'#&1" (box 1))
  (ptest "'(1 . 2)" (cons 1 2))
  (ptest "'(1 2)" (list 1 2))
  (ptest "'(1 2 . 3)" (list* 1 2 3))
  (ptest "'#(1 2 3)" (vector 1 2 3))

  (ptest "'#hash((1 . 2))" (hash 1 2))
  (ptest "'#hash((1 . 2))" (make-hash (list (cons 1 2))))
  (ptest "'#hasheq((1 . 2))" (hasheq 1 2))
  (ptest "'#hasheq((1 . 2))" (make-hasheq (list (cons 1 2))))
  (ptest "'#hasheqv((1 . 2))" (hasheqv 1 2))
  (ptest "'#hasheqv((1 . 2))" (make-hasheqv (list (cons 1 2))))

  (ptest "(mcons 1 2)" (mcons 1 2))
  (ptest "(mcons 1 '())" (mcons 1 null))

  (ptest "#<a>" (a 1 2))
  (ptest "(b 1 2)" (b 1 2))
  (ptest "'#s(c 1 2)" (c 1 2))

  (ptest "'<1 1 2>" (d 1 2))
  (ptest "'<1 1 #<a>>" (d 1 (a 1 2)))
  (ptest "<0 1 (b 1 2)>" (d 1 (b 1 2)))

  (ptest "'#&#<a>" (box (a 1 2)))
  (ptest "(box (b 1 2))" (box (b 1 2)))
  (ptest "'#&#s(c 1 2)" (box (c 1 2)))

  (ptest "'(#<a>)" (list (a 1 2)))
  (ptest "(list (b 1 2))" (list (b 1 2)))
  (ptest "'(#s(c 1 2))" (list (c 1 2)))
  (ptest "'(<1 1 2>)" (list (d 1 2)))
  (ptest "(list <0 1 2>)" (list (e 1 2)))
  (ptest "'(<1 1 2>)" (list (f 1 2)))
  (ptest "'(<1 1 2>)" (list (f2 1 2)))
  (ptest "'(<1 1 2>)" (list (g 1 2)))
  (ptest "(list <0 1 (b 1 2)>)" (list (d 1 (b 1 2))))
  (ptest "(list <0 1 (b 1 2)>)" (list (e 1 (b 1 2))))
  (ptest "'(<1 1 #(struct:b 1 2)>)" (list (f 1 (b 1 2))))
  (ptest "'(<1 1 #(struct:b 1 2)>)" (list (f2 1 (b 1 2))))
  (ptest "'(<1 1 #(struct:b 1 2)>)" (list (g 1 (b 1 2))))

  (ptest "'(0 . #<a>)" (cons 0 (a 1 2)))
  (ptest "(cons 0 (b 1 2))" (cons 0 (b 1 2)))
  (ptest "'(0 . #s(c 1 2))" (cons 0 (c 1 2)))

  (ptest "'#(#<a>)" (vector (a 1 2)))
  (ptest "(vector (b 1 2))" (vector (b 1 2)))
  (ptest "'#(#s(c 1 2))" (vector (c 1 2)))

  (ptest "'#hash((0 . #<a>))" (hash 0 (a 1 2)))
  (ptest "(hash 0 (b 1 2))" (hash 0 (b 1 2)))
  (ptest "'#hash((0 . #s(c 1 2)))" (hash 0 (c 1 2)))

  (ptest "(mcons 0 #<a>)" (mcons 0 (a 1 2)))
  (ptest "(mcons 0 (b 1 2))" (mcons 0 (b 1 2)))
  (ptest "(mcons 0 '#s(c 1 2))" (mcons 0 (c 1 2)))

  (ptest "(list '(1 2) #<a> (b 1 2))" (list '(1 2) (a 1 2) (b 1 2)))
  (ptest "(list* '(1 2) #<a> (b 1 2))" (list* '(1 2) (a 1 2) (b 1 2)))
  (ptest "(vector '(1 2) #<a> (b 1 2))" (vector '(1 2) (a 1 2) (b 1 2)))
  (ptest "(hash '(1 2) (b 1 2))" (hash '(1 2) (b 1 2)))

  (ptest "'(#<procedure:add1>)" (list add1))
  (ptest "'#(#<procedure:add1>)" (vector add1))

  (ptest "(arity-at-least 1)" (arity-at-least 1))

  (ptest "#0='(#0#)" (read (open-input-string "#0=(#0#)")))
  (ptest "#0='(#0# #0#)" (read (open-input-string "#0=(#0# #0#)")))
  (ptest "#0='(#0# . #0#)" (read (open-input-string "#0=(#0# . #0#)")))
  (ptest "#0='(#0# #0# . #0#)" (read (open-input-string "#0=(#0# #0# . #0#)")))
  (ptest "#0='#(#0# #0#)" (read (open-input-string "#0=#(#0# #0#)")))
  (ptest "#0='#&#0#" (read (open-input-string "#0=#&#0#")))
  (ptest "#0=(list (b 1 2) #0#)" (let ([v (make-placeholder #f)])
                                   (placeholder-set! v (list (b 1 2) v))
                                   (make-reader-graph v)))
  (ptest "#0=(list* (b 1 2) 8 #0#)" (let ([v (make-placeholder #f)])
                                      (placeholder-set! v (list* (b 1 2) 8 v))
                                      (make-reader-graph v)))
  (ptest "#0=(cons (b 1 2) #0#)" (let ([v (make-placeholder #f)])
                                   (placeholder-set! v (cons (b 1 2) v))
                                   (make-reader-graph v)))
  (ptest "#0=(vector (b 1 2) #0#)" (let ([v (make-placeholder #f)])
                                     (placeholder-set! v (vector (b 1 2) v))
                                     (make-reader-graph v)))
  (ptest "#0='#s(c 1 #0#)" (let ([v (make-placeholder #f)])
                             (placeholder-set! v (c 1 v))
                             (make-reader-graph v)))
  (ptest "#0=(c (b 1 2) #0#)" (let ([v (make-placeholder #f)])
                                (placeholder-set! v (c (b 1 2) v))
                                (make-reader-graph v)))

  (ptest "'(apple\n  \"0000000000000000000000000000000000000000000000000000000000000000000000\")"
         (list 'apple (make-string 70 #\0)))
  (ptest "'#(apple\n   \"0000000000000000000000000000000000000000000000000000000000000000000000\")"
         (vector 'apple (make-string 70 #\0)))
  (ptest "'(apple\n  .\n  \"0000000000000000000000000000000000000000000000000000000000000000000000\")"
         (cons 'apple (make-string 70 #\0)))
  (ptest "'#hash((apple\n        .\n        \"0000000000000000000000000000000000000000000000000000000000000000000000\"))"
         (hash 'apple (make-string 70 #\0)))

  (ptest "(list\n (b 1 2)\n \"00000000000000000000000000000000000000000000000000000000000000000\")"
         (list (b 1 2) (make-string 65 #\0)))
  (ptest "(cons\n (b 1 2)\n \"00000000000000000000000000000000000000000000000000000000000000000\")"
         (cons (b 1 2) (make-string 65 #\0)))
  (ptest "(vector\n (b 1 2)\n \"00000000000000000000000000000000000000000000000000000000000000000\")"
         (vector (b 1 2) (make-string 65 #\0)))
  (ptest "(mcons\n (b 1 2)\n \"00000000000000000000000000000000000000000000000000000000000000000\")"
         (mcons (b 1 2) (make-string 65 #\0)))
  (ptest "(hash\n (b 1 2)\n \"00000000000000000000000000000000000000000000000000000000000000000\")"
         (hash (b 1 2) (make-string 65 #\0)))
  (ptest "(box\n (b 1 \"00000000000000000000000000000000000000000000000000000000000000000000\"))"
         (box (b 1 (make-string 68 #\0))))

  (ptest "#0='(#0#\n     \"iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii\"\n     #0#)" 
         (read (open-input-string "#0=(#0# \"iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii\" #0#)")))

  (ptest "''a" ''a)
  (ptest "'`a" '`a)
  (ptest "'`,#,#`a" '`,#,#`a)
  (ptest "'`,#,#`,@#,@a" '`,#,#`,@#,@a)
  (ptest "'`,#,#`,@, @a" '`,#,#`,@, @a)
  (ptest "'`,#,#`,@#, @a" '`,#,#`,@#, @a)
  (ptest "'`,#,#`,@,|@a,|" '`,#,#`,@,|@a,|)
  (ptest "'`,#,#`,@#,|@a,|" '`,#,#`,@#,|@a,|)

  (ptest "(fxvector 1 10000 3)" (fxvector 1 10000 3))
  (ptest "(flvector 1.1 10000.1 3.1 0.0)" (flvector 1.1 10000.1 3.1 0.0))

  (void))

(let ([in-string (lambda (f v)
                   (let ([o (open-output-bytes)])
                     (f v o)
                     (get-output-string o)))])
  (test "Π" in-string write 'Π) ;; UTF-8 encoding can be misinterpreted as having a space
  (test "Σ" in-string write 'Σ) ;; interesting because it's special-casing
  (test "ς" in-string write 'ς) ;; also special-casing
  (test "σ" in-string write 'σ)
  (test "|a\xA0b|" in-string write (string->symbol "a\xA0b"))
  (parameterize ([read-case-sensitive #f])
    (test "|Π|" in-string write 'Π)
    (test "|Σ|" in-string write 'Σ)
    (test "σ" in-string write 'σ)
    (test "|ς|" in-string write 'ς))
  (parameterize ([read-accept-bar-quote #f])
    (test "Π" in-string write 'Π)
    (test "Σ" in-string write 'Σ)
    (test "a\\\xA0b" in-string write (string->symbol "a\xA0b"))))

;; ----------------------------------------

(test #t unquoted-printing-string? (unquoted-printing-string "a b"))
(test #f unquoted-printing-string? "a b")
(test #f unquoted-printing-string? 7)

(test "a b" unquoted-printing-string-value (unquoted-printing-string "a b"))

(test "a b" format "~s" (unquoted-printing-string "a b"))
(test "a b" format "~a" (unquoted-printing-string "a b"))
(test "a b" format "~v" (unquoted-printing-string "a b"))
(parameterize ([error-print-width 10])
  (test "a b1234..." format "~.s" (unquoted-printing-string "a b12345678"))
  (test "a b1234..." format "~.a" (unquoted-printing-string "a b12345678"))
  (test "a b1234..." format "~.v" (unquoted-printing-string "a b12345678"))
  (test "who: oops\n  field: a b12345678\n"
        'raise-arguments-error
        (parameterize ([current-error-port (open-output-bytes)]
                       [error-print-context-length 0])
          (call-with-continuation-prompt
           (lambda ()
             (raise-arguments-error 'who "oops" "field" (unquoted-printing-string "a b12345678")))
           (default-continuation-prompt-tag)
           void)
          (get-output-string (current-error-port)))))

;; Check GC interaction:
(let ([l (for/list ([i 100])
           (unquoted-printing-string "1 2 3"))])
  (collect-garbage)
  (for ([ups (in-list l)])
    (test "1 2 3" format "~s" ups)))

;; ----------------------------------------

(let ([p (build-path (current-directory) "something")])
  ;; path value in compiled code => path appears in .zo format:
  (let ([o (open-output-string)])
    (write (compile p) o)
    (test #t 'path-in-code?1 (regexp-match? (regexp-quote (path->bytes (current-directory))) (get-output-string o))))
  ;; `current-write-relative-directory' set => path not in .zo format: 
  (let ([o (open-output-string)])
    (parameterize ([current-write-relative-directory (current-directory)])
      (write (compile p) o)
    (test #f 'path-in-code?2 (regexp-match? (regexp-quote (path->bytes (current-directory))) (get-output-string o)))))
  ;; try all possible supers that have at least two path elements:
  (let loop ([super (current-directory)])
    (let ([super (let-values ([(base name dir?) (split-path super)])
                   (if (eq? base 'root)
                       #f
                       base))])
      (when (and super
                 ((length (explode-path super)) . >= . 2))
        ;; `current-write-relative-directory' set => super can be in .zo format: 
        (let ([o (open-output-string)])
          (parameterize ([current-write-relative-directory (current-directory)])
            (write (compile (build-path super "other")) o)
            (test #t 'path-in-code?3 (regexp-match? (regexp-quote (path->bytes super)) (get-output-string o)))))
        (let ([o (open-output-string)])
          (parameterize ([current-write-relative-directory (cons (current-directory)
                                                                 super)])
            (write (compile (build-path super "other")) o)
            (test #f 'path-in-code?4 (regexp-match? (regexp-quote (path->bytes super)) (get-output-string o)))))
        (loop super)))))

;; ----------------------------------------
;; make sure +inf.0 is ok for `print-syntax-width':
(parameterize ([print-syntax-width +inf.0])
  (test +inf.0 print-syntax-width))

;; ----------------------------------------
;; Try to provoke a stack overflow during printing of truncated
;; values, ensuring that the stack-overflow handling doesn't
;; interfere with the printer escape on truncation:

(with-handlers ([void void])
  (let loop ([i 6013])
    (if (zero? i)
        (break-thread)
        (with-handlers ([void (lambda (x y) x)])
          (loop (sub1 i))))))

;; ----------------------------------------
;; Check that printing a hash table doesn't crash
;; if the table changes while it's being printed
;; (or checked for cycles):

(let ()
  (define ht (make-hash))

  (struct trouble (t)
          #:property prop:custom-write
          (lambda (s p mode)
            (hash-set! ht (random) 'ok)
            (fprintf p "trouble")))

  (for ([i (in-range 100)])
    (hash-set! ht (trouble i) i))

  (for ([i 20])
    (define o (open-output-bytes))
    (print ht o)))

;; ----------------------------------------
;; Check that recursive printing accepts a structure
;; with the `prop:output-port` property

(let ()
  (struct p (out) #:property prop:output-port 0)
  (struct s ()
          #:property prop:custom-write
          (lambda (v out mode)
            (display "ok" (p out))))
  (define o (open-output-bytes))
  (write (s) (p o))
  (test "ok" get-output-string o))

;; ----------------------------------------
;; Check that some values are allowed in a srcloc source
;; in printed compiled code, and some values are not

(let ()
  (define (try v [result-v v] #:ok? [ok? #t])
    (define-values (i o) (make-pipe))
    (define c (compile `,(srcloc v 1 2 3 4)))
    (cond
     [ok?
      (parameterize ([current-write-relative-directory (current-directory)])
        (write c o))
      (test result-v
            srcloc-source
            (parameterize ([current-load-relative-directory (build-path (current-directory) "sub")])
              (eval (parameterize ([read-accept-compiled #t])
                      (read i)))))]
     [else
      (err/rt-test (write c o) (lambda (exn) (and (exn:fail? exn)
                                                  (regexp-match? #rx"cannot marshal" (exn-message exn)))))]))

  (try #f)
  (try 'apple)
  (try "apple")
  (try #"apple")
  (try (string->path "apple") "apple")
  (try (build-path 'up) "..")
  (try (build-path 'same) ".")
  (try (build-path 'up "apple") ".../apple")
  (try (build-path "x" 'up "apple") ".../apple")
  (try (build-path "apple" 'up) ".../apple/..")
  (try (build-path "apple" 'same) ".../apple/.")
  (try (build-path "x" "apple" 'up) ".../apple/..")
  (try (build-path "x" "apple" 'same) ".../apple/.")
  (let ([d (car (filesystem-root-list))])
    (try (build-path d 'up) (path->string (build-path d 'up))))
  (try (build-path (current-directory) "apple")
       (build-path (current-directory) "sub" "apple"))

  (try 7 #:ok? #f)
  (try (box 7) #:ok? #f))

;; ----------------------------------------

(report-errs)
