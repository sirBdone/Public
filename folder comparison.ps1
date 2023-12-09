measure-command {
    
    $ErrorActionPreference = "silentlycontinue"

    . "C:\Users\SirBd0ne\Documents\GitHub\Public\pick-fileFolder.ps1"
    
    pick-filefolder
    $drive1 = $global:selectedfolder #"C:\"  # specify the first drive to compare
    pick-filefolder 
    $drive2 = $global:selectedfolder #"s:\"  # specify the second drive to compare

    # create an empty array to store the results of the Get-ChildItem calls
    $results = @()

    # run the Get-ChildItem calls in parallel
    $results += Start-Job -ScriptBlock {
        Get-ChildItem -Path $using:drive1 -Recurse -Force | Select-Object -Property Name,FullName,@{n='drive';e={"drive1"}}
    }
    $results += Start-Job -ScriptBlock {
        Get-ChildItem -Path $using:drive2 -Recurse -Force | Select-Object -Property Name,FullName,@{n='drive';e={"drive2"}}
    }

    # wait for the jobs to complete
    Wait-Job $results

    $allresults = $results | %{
        receive-job $_
    }

    $table = $allresults  | select name,fullname,drive

    # compare the two lists and get the items that are only present in the first list
    write-host "These are the files that are not in the folder you selected:" -ForegroundColor green
    ($table | group name | ?{$_.count -le 1}).group | ?{$_.fullname -cnotmatch 'git'} | sort name

}