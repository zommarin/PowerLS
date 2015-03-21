<#
 .Synopsis
  Powershell unix-like ls
  Written by Jesse Jurman (JRJurman)

 .Description
  A colorful ls

 .Parameter Redirect
  The first month to display.

 .Example
   # List the current directory
   PowerLS

 .Example
   # List the parent directory
   PowerLS ../
#>
function PowerLS {
  param(
    $redirect = "."
  )

    # get the console buffersize
    $buffer = Get-Host
    $bufferwidth = $buffer.ui.rawui.buffersize.width

    # get all the files and folders
    $childs = Get-ChildItem $redirect

    # get the longest string and get the length
    $lnStr = $childs | select-object Name | sort-object { "$_".length } -descending | select-object -first 1
    $len = $lnStr.name.length + 1

    # keep track of how long our line is so far
    $count = 0

    # extra space to give some breather space
    $breather = 4

    # for every element, print the line
    foreach ($e in $childs) {

      $padding = (" "*($len - $e.name.length+$breather))
      $count += $newName.length

      # determine color we should be printing
      # Blue for folders, Green for files, and Gray for hidden files
      if (Test-Path ($redirect + "\" + $e) -pathtype container) { #folders
        write-host "$($e.name)/$padding" -nonewline -foregroundcolor blue
      }
      elseif ($e.name -match "^\..*$") { #hidden files
        write-host "$($e.name)!$padding" -nonewline -foregroundcolor darkgray
      }
      elseif ($e.name -match "\.[^\.]*") { #normal files
        write-host "$($e.name) $padding" -nonewline -foregroundcolor green
      }
      else { #others...
        write-host "$($e.name) $padding" -nonewline -foregroundcolor white
      }

      if ( $count -ge ($bufferwidth - ($len+$breather)) ) {
        write-host ""
        $count = 0
      }

    }

    write-host "" # add newline at bottom

}

export-modulemember -function PowerLS
