<#PSScriptInfo
.DESCRIPTION 
    This is a port of the minesweeper game into powershell using new powershell 5 classes and .net framework forms.
.AUTHOR
	Robert Weber
.VERSION
	1.1
.GUID
	cfa53e66-abe8-4584-a3cd-9398162f5a0f
#>

<#
.SYNOPSIS 
    This is a port of the minesweeper game into powershell...using new powershell 5 classes and .net framework forms.
.PARAMETER Side
	The length of the sides of the arena
.PARAMETER Mines
	The number of mines to hide
.PARAMETER Easy
	A Switch to use the easy layout
.PARAMETER Medium
	A Switch to use the medium layout
.PARAMETER Hard
	A Switch to use the hard layout
.PARAMETER Expert
	A Switch to use the expert layout
.EXAMPLE
	.\minesweeper.ps1
.INPUTS
	This script expects no inputs
.OUTPUTS
	This script only outputs the minesweeper GUI	   
.NOTES
	Tags - Games, PSClasses, WinForms, MineSweeper, BPE
	Author - Robert Weber
	Version - 1.1
	Changes - Fixed a bug with the scope of the button event 'this' item
#>
[CmdletBinding()]
param( 
	[Parameter(Mandatory = $false, ValueFromPipeLine = $false,ValueFromPipelineByPropertyName = $false)][int]$side = 16, 
	[Parameter(Mandatory = $false, ValueFromPipeLine = $false,ValueFromPipelineByPropertyName = $false)][int]$mines = 40, 
	[Parameter(Mandatory = $false, ValueFromPipeLine = $false,ValueFromPipelineByPropertyName = $false)][switch]$easy, 
	[Parameter(Mandatory = $false, ValueFromPipeLine = $false,ValueFromPipelineByPropertyName = $false)][switch]$medium, 
	[Parameter(Mandatory = $false, ValueFromPipeLine = $false,ValueFromPipelineByPropertyName = $false)][switch]$hard, 
	[Parameter(Mandatory = $false, ValueFromPipeLine = $false,ValueFromPipelineByPropertyName = $false)][switch]$expert
)
Begin{
	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing

	#this is here because you can't call .net types from within the new classes.
	function getControls{
		return ( [System.Windows.Forms.Control[]] @() )
	}	
}

Process{

	Class MineSweeper{
		$gui = @{
				'form' = new-object "System.Windows.Forms.form"
				'controls' = @{}
				'vars' = @{}
			}
		[int] $rows = $script:side
		[int] $cols = $script:side
		[int] $mines = $script:mines
		$map = (getControls)
		$cleared = (new-object collections.arraylist)
		
		[void] ToggleFlag( $num ){
			<#
			.DESCRIPTION
				This function toggles the placement of flags
			.PARAMETER num
				This is the index of the button being toggled
			#>
			if( $this.map[$num].text -ne "M"){
				$this.map[$num].text = "M" 
				$this.map[$num].BackColor = "lightblue"
				$this.gui.controls.txtFlags.text = $([int]$this.gui.controls.txtFlags.text) - 1
			}else{
				$this.map[$num].text = "" 
				$this.map[$num].BackColor = "lightGray"
				$this.gui.controls.txtFlags.text = $([int]$this.gui.controls.txtFlags.text) + 1
			}
		}
		
		[void] clearSpace($num) {
			<#
			.DESCRIPTION
				This function clears the flag in a space
			.PARAMETER num
				This is the index of the button being toggled
			#>
			$this.cleared.add( $num )
	 
			while($this.cleared.count -gt 0){
				$n = $this.cleared[0]
				$this.ExecClear($n)
				$this.cleared.remove($n)
			}
		}

		[void] DoRaise($num){ 
			<#
			.DESCRIPTION
				This function counts the number of 'mines' surrounding the current cell
			.PARAMETER num
				This is the index of the button being toggled
			#>
			if ($this.map[$num].tag -ne "x"){ 
				[int]$this.map[$num].tag = [int]$this.map[$num].tag + 1
			} 
		} 
		
		[void] ExecClear($num) {
			<#
			.DESCRIPTION
				This function updates the gui with the toggles to the flags
			.PARAMETER num
				This is the index of the button being toggled
			#>
			$C = $num % $this.rows 
			$R = [math]::truncate($num/$this.rows) 
			If ($this.map[$num].enabled -eq $true) { 
				if ($this.map[$num].tag -eq "x") { 
					$this.map[$num].text = "x" 
					$this.map[$num].BackColor = "red"
					$this.map | % {
						$_.enabled = $false

					}
				} Else {
					$this.map[$num].BackColor = "#FFC0C0C0" 
					$this.map[$num].FlatStyle = 'Flat' 
					
					if ($this.map[$num].tag -ne 0) {
						$this.map[$num].BackColor = "#FFC0C0C0"
						$this.map[$num].text = $this.map[$num].tag
						$this.map[$num].Enabled = $true
						switch($this.map[$num].tag){
							1 { $this.map[$num].backcolor = "#FF9999FF"; }
							2 { $this.map[$num].backcolor = "#FF99FF99"; }
							3 { $this.map[$num].backcolor = "#FFFF9999"; }
							
							4 { $this.map[$num].backcolor = "#FF9999CC"; }
							5 { $this.map[$num].backcolor = "#FF99CC99"; }
							6 { $this.map[$num].backcolor = "#FFCC9999"; }
							
							7 { $this.map[$num].backcolor = "#FF6666ff"; }
							8 { $this.map[$num].backcolor = "#FF66ff66"; }
							9 { $this.map[$num].backcolor = "#FFff6666"; }
						}
					} Else {
						$this.map[$num].BackColor = "#FFEEEEEE"
						if ($C -gt 0) { 
							$this.cleared.add(  $( $num - 1 ) ) 
	 
							if ($R -gt 0) { 
								$this.cleared.add( $( $num - $this.Cols) - 1 ) 
							} 
						} 
						if ($C -lt ($this.Cols - 1)) { 
							$this.cleared.add($num + 1 ) 
							if ($R -gt 0) { 
								$this.cleared.add( ( $num - $this.cols) + 1 )
							} 
						} 
						if ($R -gt 0) { 
							$this.cleared.add( $num - $this.cols) 
						} 
						if ($R -lt ($this.rows -1)) { 
							$this.cleared.add($num + $this.cols) 
							if ($C -gt 0) { 
								$this.cleared.add( ($num + $this.Cols) - 1 ) 
							}
							if ($C -lt ($this.Cols - 1)) { 
								$this.cleared.add( ( $num + $this.Cols ) + 1 )
							} 
						} 
					} 
					$this.map[$num].Enabled = $false
				} 
			} 
		}

		[void] generateForm(){
			<#
			.DESCRIPTION
				This function generates the GUI using winforms
			#>				
			$this.gui.form.Width = ($this.cols * 25) + 35 
			$this.gui.form.Height = ($this.rows * 25) + 90   
			
			$this.gui.controls.add('txtFlags', (New-Object "System.windows.forms.textBox" ) )
			$this.gui.controls.txtFlags.location = New-Object System.Drawing.Size(10,10)
			$this.gui.controls.txtFlags.size = New-Object System.Drawing.Size(50,25)
			$this.gui.controls.txtFlags.backColor = '#FFFFFFFF'
			$this.gui.controls.txtFlags.text = $this.mines
			$this.gui.form.Controls.Add($this.gui.controls.txtFlags)
	 
			for ($i = 0;$i -lt $this.rows;$i++){ 
				$row = @() 
				for ($j = 0;$j -lt $this.Cols;$j++){ 

					$Button = new-object System.Windows.Forms.Button 
					$Button.width = 25 
					$Button.Height = 25 
					$button.top = ($i * 25) + 40 
					$button.Left = $j * 25 + 10 
					$button.Name = $( ($i * $this.cols) + $j)
					$button.tabstop = $false
					$button.FlatStyle = 'Flat'
					$button.FlatAppearance.Bordersize = 1
					$Button.FlatAppearance.BorderColor = "#80808080"
					$button.backColor = "#FF999999"
	 
					$Button.tag = "0" 
					
					$script:self = $this
					
					$button.add_mouseDown({
						switch($_.Button){
							"Left" {
								[int]$num = $this.name 
								$script:self.cleared = new-object collections.arraylist
								$script:self.clearSpace($num) 
							}
							"Right" {
								[int]$num = $this.name 
								$script:self.ToggleFlag($num)
							}
						}
					}) 
					$row += $Button 
				}    
				$this.Map += $row 
			}
		}
		
		[void] fillMines(){
			<#
			.DESCRIPTION
				This function places mines in the field
			#>
			$Random = new-object system.random([datetime]::now.Millisecond) 
			for ($i = 0 ; $i -lt $this.Mines) { 
				$num = $random.next($this.map.count) 
				if ( $this.map[$num].tag -ne "x") { 
					$this.map[$num].tag = "x" 
					$C = $num % $this.rows 
					$R = [math]::truncate($num/$this.rows) 

					if ($C -gt 0) { 
						$this.doRaise($num - 1) 
						if ($R -gt 0) { 
							$this.doRaise(($num - $this.Cols) - 1) 
						} 
					} 
					if ($C -lt ($this.Cols - 1)) { 
						$this.doRaise($num + 1) 
						if ($R -gt 0) { 
							$this.doRaise(($num - $this.Cols) + 1) 
						} 
					} 
					if ($R -gt 0) { 
						$this.doRaise($num - $this.cols) 
					} 
					if ($R -lt ($this.rows -1)) { 
						$this.doRaise($num + $this.cols) 
						if ($C -gt 0) { 
							$this.doRaise(($num + $this.Cols) - 1) 
						} 
						if ($C -lt ($this.Cols -1)) { 
							$this.doRaise(($num + $this.Cols) + 1) 
						} 
					}
					$i++ 
				} 
			}
			$this.gui.Form.controls.addrange($this.map)
		}
		
		[void] Dispose(){
			<#
			.DESCRIPTION
				This function disposes the objects and variables created for this script
			#>
			$this = $null
		}
		
		MineSweeper(){
		<#
		.DESCRIPTION
			This is the constructor for the MineSweeper object
		#>
			switch($true){
				$script:easy{ $this.cols, $this.rows, $this.mines = @(8,8,10) }
				$script:medium{ $this.cols, $this.rows, $this.mines = @(16,16,40) }
				$script:hard{ $this.cols, $this.rows, $this.mines = @(24,24,99) }
				$script:expert{ $this.cols, $this.rows, $this.mines = @(32,32,150) }
			}
		
			$this.generateForm()
			$this.fillMines()
			$this.gui.Form.ShowDialog()| Out-Null
		}	
	}
	
	$mineSweeper = [MineSweeper]::new()
}
End{
	$mineSweeper.Dispose()
	[system.gc]::Collect()
}