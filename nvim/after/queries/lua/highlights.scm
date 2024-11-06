;; extends

(
  "local" @keyword.local
  (#set! "priority" 110)
)

(
  (variable_list name: (identifier) @variable.throwaway)
  (#eq? @variable.throwaway "_")
)

