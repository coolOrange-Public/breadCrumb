#Add-Type –assemblyName PresentationFramework
#Add-Type –assemblyName PresentationCore
#Add-Type –assemblyName WindowsBase


function InitializeWindow
{
	$dsWindow.Width = 600
	$dsWindow.Height = 400
	$mWindowName = $dsWindow.Name
	switch($mWindowName)
	{
		"InventorWindow"
		{
			#rules applying for Inventor
		}
		"AutoCADWindow"
		{
			#rules applying for AutoCAD
		}
		default
		{
			#rules applying commonly
		}
	}
	$mappedRootPath = $Prop["_VaultVirtualPath"].Value + $Prop["_WorkspacePath"].Value
	$mappedRootPath = $mappedRootPath -replace "\\", "/" -replace "//", "/"
	$rootFolder = $vault.DocumentService.GetFolderByPath($mappedRootPath)
	$root = New-Object PSObject -Property @{ Name = $rootFolder.Name; ID=$rootFolder.Id }	
	AddCombo -data $root
}




function AddinLoaded
{
	#Executed when DataStandard is loaded in Inventor
}
function AddinUnloaded
{
	#Executed when DataStandard is unloaded in Inventor
}

function GetFolderList
{
	try
	{
		$rootFolder = $vault.DocumentService.GetFolderByPath("$")
		$mWindowName = $dsWindow.Name
		if ($mWindowName -eq "InventorWindow")
		{
			$mappedRootPath = $Prop["_VaultVirtualPath"].Value + $Prop["_WorkspacePath"].Value
			$mappedRootPath = $mappedRootPath -replace "\\", "/"
			$mappedRootPath = $mappedRootPath -replace "//", "/"
			$rootFolder = $vault.DocumentService.GetFolderByPath($mappedRootPath)
		}

		# get direct sub-folders
		$folders = $vault.DocumentService.GetFoldersByParentId($rootFolder.id,$false)
		$myFolders = @()
		$folders | ForEach-Object { 
			$myFolders += $_.Name
			}
		
		if ($mWindowName -eq "InventorWindow")
		{
			$myFolders += "." # Add mapped project root folder for Inventor, to have at least one folder in case there are no sub-folders yet
		}
		return $myFolders
	}
	catch
	{
		$myFolders = "."
		return $myFolders
	}
}

function GetNumSchms
{
	try
	{
		$numSchems = $vault.DocumentService.GetNumberingSchemesByType('Activated')
		if ($numSchems.Count -gt 0) 
		{ 
			$list = New-Object 'System.Collections.Generic.List[string]'
			foreach ($item in $numSchems) 
			{ 
				if ($item.IsDflt)
				{
					$list.Insert(0,$item.Name)
				}
				else
				{
					$list.Add($item.Name)
				}
			}
			return $list
		}
	}
	catch [System.Exception]
	{		
		#[System.Windows.MessageBox]::Show($error)
	}	
}

function OnPostCloseDialog
{
	$mWindowName = $dsWindow.Name
	switch($mWindowName)
	{
		"InventorWindow"
		{
			#rules applying for Inventor
		}
		"AutoCADWindow"
		{
			#rules applying for AutoCAD
		}
		default
		{
			#rules applying commonly
		}
	}
}