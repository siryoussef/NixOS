(use-modules (gnu packages)
             (gnu packages guile)
             (gnu packages databases))

(define my-packages
  (list
   (specification->package "guix-daemon")  ; Special to Guix
   (specification->package "guile-dbi")    ; Database library for Guile
   (specification->package "guile-redis"))) ; Redis client for Guile
