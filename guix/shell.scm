(load "./packages.scm")  ; Relative path to load the packages file

;; Create a shell environment with the shared packages
(define shell-env
  (specifications->manifest packages))

;; Run `guix shell` with this environment file as follows:
;; guix shell -m shell.scm
my-shell-env
