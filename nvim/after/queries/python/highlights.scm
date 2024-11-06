;; extends

(import_statement
  name: (aliased_import
    name: (dotted_name (identifier)) @module
    alias: (identifier) @module
    )
  )

(import_statement
  name: (dotted_name (identifier)) @module
 )

(import_from_statement
  module_name: (dotted_name) @module
  name: (dotted_name (identifier)) @function
  )

(call function: (attribute object: (identifier) @namespace))
(call function: (attribute object: (attribute
    object: (identifier) @namespace
    attribute: (identifier) @namespace
  )))

(
  (for_statement left: (identifier) @iterator)
  (#eq? @iterator "_")
)

(class_definition
  name: (identifier) @class
  )

(
  (for_in_clause left: (identifier) @iterator)
  (#eq? @iterator "_")
)

(assignment
  left: (identifier) @function
  right: (lambda)
  )

(assignment
  left: (identifier) @named.constant
  (#match? @named.constant "^[A-Z]{2}")
  )

(call arguments: (argument_list "(" @punctuation.bracket.function))
(call arguments: (argument_list ")" @punctuation.bracket.function))
(function_definition parameters: (parameters "(" @punctuation.bracket.function))
(function_definition parameters: (parameters ")" @punctuation.bracket.function))
(class_definition superclasses: (argument_list ")" @punctuation.bracket.function))
(class_definition superclasses: (argument_list "(" @punctuation.bracket.function))

( "[") @punctuation.bracket.list
( "]") @punctuation.bracket.list

;; pandas transpose highlight fix
(
  (attribute
    object: (attribute 
      attribute: (identifier) @field
  ))
  (#eq? @field "T")
)

(
  (assignment 
    right: (attribute 
      attribute: (identifier) @field
  ))
  (#eq? @field "T")
)

