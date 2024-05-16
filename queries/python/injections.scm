;; extends
;For magic cells
(
 (comment) @_start (#eq? @_start "# COMMAND ----------")
 (comment) @_id (#eq? @_id "# MAGIC %sql")
  [
(comment) @middle
  ]* 
  (comment) @_end 
  (#make-range! "comment" @injection.content)
(#set! injection.language "sql")
(#set! injection.include-children true)
(#set! "priority" 120)
)
;For spark.sql()
(call
  function: (attribute) @name (#eq? @name "spark.sql")
  (argument_list
    (string 
      (string_content) @injection.content))
  (#set! injection.language "sql")
(#set! injection.include-children true)
)
; test
( 
    ((comment) @_start (#eq? @_start "# MAGIC %sql")
    (comment) @injection.content
    (comment) @_end (#eq? @_end "# COMMAND ----------")
    )

    (#set! injection.language "sql")
    (#set! injection.include-children true)
    (#set! "priority" 120)
)

