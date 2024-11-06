;; extends

(binary_operator
  lhs: (identifier) @named.constant
  (#match? @named.constant "^[A-Z]{2}")
  )

(binary_operator
  rhs: (identifier) @named.constant
  (#match? @named.constant "^[A-Z]{2}")
  )

