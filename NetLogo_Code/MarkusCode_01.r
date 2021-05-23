globals [ patch-data ]

; This procedure loads in patch data from a file.  The format of the file is: pxcor
; pycor pcolor.  You can view the file by opening the file File IO Patch Data.txt
; using a simple text editor.  Note that it automatically loads the file "File IO
; Patch Data.txt". To have the user choose their own file, see load-own-patch-data.
to load-patch-data

  ; We check to make sure the file exists first
  ifelse ( file-exists? "File IO Patch Data.txt" )
  [
    ; We are saving the data into a list, so it only needs to be loaded once.
    set patch-data []

    ; This opens the file, so we can use it.
    file-open "File IO Patch Data.txt"

    ; Read in all the data in the file
    while [ not file-at-end? ]
    [
      ; file-read gives you variables.  In this case numbers.
      ; We store them in a double list (ex [[1 1 9.9999] [1 2 9.9999] ...
      ; Each iteration we append the next three-tuple to the current list
      set patch-data sentence patch-data (list (list file-read file-read file-read))
    ]

    user-message "File loading complete!"

    ; Done reading in patch information.  Close the file.
    file-close
  ]
  [ user-message "There is no File IO Patch Data.txt file in current directory!" ]
end

; This procedure does the same thing as the above one, except it lets the user choose
; the file to load from.  Note that we need to check that it isn't false.  This because
; it will return false if the user cancels the file dialog.  There is currently only
; one file to load from, but you can create your own using the function save-patch-data
; near the bottom which saves all the current patches into a file.
to load-own-patch-data
  let file user-file

  if ( file != false )
  [
    set patch-data []
    file-open file

    while [ not file-at-end? ]
      [ set patch-data sentence patch-data (list (list file-read file-read file-read)) ]

    user-message "File loading complete!"
    file-close
  ]
end

; This procedure will use the loaded in patch data to color the patches.
; The list is a list of three-tuples where the first item is the pxcor, the
; second is the pycor, and the third is pcolor. Ex. [ [ 0 0 5 ] [ 1 34 26 ] ... ]
to show-patch-data
  clear-patches
  clear-turtles
  ifelse ( is-list? patch-data )
    [ foreach patch-data [ three-tuple -> ask patch first three-tuple item 1 three-tuple [ set pcolor last three-tuple ] ] ]
    [ user-message "You need to load in patch data first!" ]
  display
end

; This is the procedure that was used to create the file "File IO Patch Data.txt".
; You can also use it to create your own files.  See File Output code example for more
; details on File Output.
to save-patch-data
  let file user-new-file

  if ( file != false )
  [
    file-open file
    ask patches
    [
      file-write pxcor
      file-write pycor
      file-write pcolor
    ]
    file-close
  ]
end


; Public Domain:
; To the extent possible under law, Uri Wilensky has waived all
; copyright and related or neighboring rights to this model.
