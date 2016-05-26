ls -Recurse -include 'bin','obj','packages' ,'node_modules' |
  foreach {
    if ((ls $_.Parent.FullName | ?{ $_.Name -Like "*.sln" -or $_.Name -Like "*.*proj" }).Length -gt 0) {
      remove-item $_ -recurse -force
      write-host deleted $_
    }
}