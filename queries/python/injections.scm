;; extends
;For magic cells

;For spark.sql()
(call
  function: (attribute) @name (#eq? @name "spark.sql")
  (argument_list
    (string 
      (string_content) @injection.content))
  (#set! injection.include-children true)
  (#set! injection.language "sql")
  (#set! "priority" 120)
)
; test
; ( 
;     ((comment) @_start (#eq? @_start "# MAGIC %sql")
;     (comment) @injection.content
;     (comment) @_end (#eq? @_end "# COMMAND ----------")
;     )
;
;     (#set! injection.language "sql")
;     (#set! injection.include-children true)
;     (#set! "priority" 120)
; )

