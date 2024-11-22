(load "./packages.scm")  ; Load shared packages
(use-modules (gnu home)
             (gnu home services)
             (gnu packages shells)
             (guix gexp))

(home-environment
 (services
  (list
	(packages my-packages)  ; Use shared packages
   ;; Example shell configuration
	(service home-bash-service-type
            (home-bash-configuration
             (bashrc (list (local-file "/path/to/your/.bashrc"))))))))
