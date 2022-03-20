(lang dune 3.0)

(name cleuros)

(generate_opam_files true)

(source
 (github smeshoyrer/cleuros))

(authors "Samuel Meshoyrer")

(maintainers "Samuel Meshoyrer")

(license LICENSE)

(documentation https://github.com/smeshoyrer/cleuros)

(package
 (name cleuros)
 (synopsis "plt project")
 (description "plt project")
 (depends ocaml dune)
 (tags
  (topics "to describe" your project)))

(using menhir 2.0)

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
