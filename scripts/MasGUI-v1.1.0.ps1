param(
    [Parameter(Mandatory=$false)]
    [String]$Wallet = "D6VmxuuEDDxY2uSkMLUVS4GGXTEP8Xwnxu",
    [Parameter(Mandatory=$false)]
    [String]$UserName,
    [Parameter(Mandatory=$false)]
    [String]$WorkerName = "doctororbit",
    [Parameter(Mandatory=$false)]
    [Int]$API_ID = 0,
    [Parameter(Mandatory=$false)]
    [String]$API_Key = "",
    [Parameter(Mandatory=$false)]
    [Int]$Interval = 30,
    [Parameter(Mandatory=$false)]
    [Int]$FirstInterval = 150, #seconds of the first cycle of activated or started first time miner
    [Parameter(Mandatory=$false)]
    [Int]$StatsInterval = 250,
    [Parameter(Mandatory=$false)]
    [String]$Location = "US",
    [Parameter(Mandatory=$false)]
    [Switch]$SSL = $false,
    [Parameter(Mandatory=$false)]
    [Array]$Type = "nvidia",
    [Parameter(Mandatory=$false)]
    [String]$SelGPUDSTM = "0 1",
    [Parameter(Mandatory=$false)]
    [String]$SelGPUCC = "0,1",
    [Parameter(Mandatory=$false)]
    [Array]$Algorithm = $null,
    [Parameter(Mandatory=$false)]
    [Array]$MinerName = $null,
    [Parameter(Mandatory=$false)]
    [Array]$PoolName = $null,
    [Parameter(Mandatory=$false)]
    [Array]$Currency = ("USD"),
    [Parameter(Mandatory=$false)]
    [Array]$Passwordcurrency = ("DGB"),
    [Parameter(Mandatory=$false)]
    [Int]$Donate = 0,
    [Parameter(Mandatory=$false)]
    [String]$Proxy = "",
    [Parameter(Mandatory=$false)]
    [Int]$Delay = 1,
    [Parameter(Mandatory=$false)]
    [Int]$ActiveMinerGainPct = 5,
    [Parameter(Mandatory=$false)]
    [Float]$MarginOfError = 0.4,
    [Parameter(Mandatory=$false)]
    [String]$MPHApiKey = ""
)

$Version = "1.2.1"

Set-Location (Split-Path $script:MyInvocation.MyCommand.Path)
Get-ChildItem . -Recurse | Unblock-File
Write-host "INFO: Adding MasGUI path to Windows Defender's exclusions.. (may show an error if Windows Defender is disabled)" -foregroundcolor "Yellow"
try{if((Get-MpPreference).ExclusionPath -notcontains (Convert-Path .)){Start-Process powershell -Verb runAs -ArgumentList "Add-MpPreference -ExclusionPath '$(Convert-Path .)'"}}catch{}
if($Proxy -eq ""){$PSDefaultParameterValues.Remove("*:Proxy")}
else{$PSDefaultParameterValues["*:Proxy"] = $Proxy}
. .\Include.ps1
$DecayStart = Get-Date
$DecayPeriod = 120
$DecayBase = 1-0.1
$ActiveMinerPrograms = @()
Start-Transcript -Path ".\Logs\miner.log" -Append -Force
if(Test-Path "Stats"){Get-ChildItemContent "Stats" | ForEach {$Stat = Set-Stat $_.Name $_.Content.Week}}
$LastDonated = (Get-Date).AddDays(-1).AddHours(1)
$WalletDonate = "D6VmxuuEDDxY2uSkMLUVS4GGXTEP8Xwnxu"
$UserNameDonate = "doctororbit"
$WorkerNameDonate = "DoctorORBiT"
$PasswordcurrencyDonate = "DGB"
$WalletBackup = $Wallet
$UserNameBackup = $UserName
$WorkerNameBackup = $WorkerName
#Randomly sets donation minutes per day between 0 - 3 minutes if not set
$PasswordcurrencyBackup = $Passwordcurrency
If ($Donate -lt 1) {$Donate = Get-Random -Maximum 3}
while($true)
{
    $DecayExponent = [int](((Get-Date)-$DecayStart).TotalSeconds/$DecayPeriod)
    #Activate or deactivate donation
    if((Get-Date).AddDays(-1).AddMinutes($Donate) -ge $LastDonated -and ($Wallet -eq $WalletBackup -or $UserName -eq $UserNameBackup))
    {
        if ($Wallet) {$Wallet = $WalletDonate}
        if ($UserName) {$UserName = $UserNameDonate}
        if ($WorkerName) {$WorkerName = $WorkerNameDonate}
        if ($Passwordcurrency) {$Passwordcurrency = $PasswordcurrencyDonate}
    }
    if((Get-Date).AddDays(-1) -ge $LastDonated -and ($Wallet -ne $WalletBackup -or $UserName -ne $UserNameBackup))
    {
        $Wallet = $WalletBackup
        $UserName = $UserNameBackup
        $WorkerName = $WorkerNameBackup
        $Passwordcurrency = $PasswordcurrencyBackup
        $LastDonated = Get-Date
    }
    Write-host "Getting up-to-date BTC rates from Coinbase" -foregroundcolor "Green"
    $Rates = Invoke-RestMethod "https://api.coinbase.com/v2/exchange-rates?currency=BTC" -UseBasicParsing | Select-Object -ExpandProperty data | Select-Object -ExpandProperty rates
    $Currency | Where-Object {$Rates.$_} | ForEach-Object {$Rates | Add-Member $_ ([Double]$Rates.$_) -Force}
    $Stats = [PSCustomObject]@{}
    if(Test-Path "Stats"){Get-ChildItemContent "Stats" | ForEach {$Stats | Add-Member $_.Name $_.Content}}
    Write-host "Loading Pool Statistics..." -foregroundcolor "Green"
    $AllPools = if(Test-Path "Pools"){Get-ChildItemContent "Pools" | ForEach {$_.Content | Add-Member @{Name = $_.Name} -PassThru} |
        Where Location -EQ $Location |
        Where SSL -EQ $SSL |
        Where {$PoolName.Count -eq 0 -or (Compare $PoolName $_.Name -IncludeEqual -ExcludeDifferent | Measure).Count -gt 0}}
    if($AllPools.Count -eq 0){Write-host "Error contacting pool, retrying..`n" -foregroundcolor "Yellow" | Out-Host; sleep 15; continue}
    $Pools = [PSCustomObject]@{}
    $Pools_Comparison = [PSCustomObject]@{}
    $AllPools.Algorithm | Select -Unique | ForEach {$Pools | Add-Member $_ ($AllPools | Where Algorithm -EQ $_ | Sort Price -Descending | Select -First 1)}
    $AllPools.Algorithm | Select -Unique | ForEach {$Pools_Comparison | Add-Member $_ ($AllPools | Where Algorithm -EQ $_ | Sort StablePrice -Descending | Select -First 1)}
    Write-host "Loading miners..." -foregroundcolor "Yellow"
    $Miners = if(Test-Path "Miners"){Get-ChildItemContent "Miners" | ForEach {$_.Content | Add-Member @{Name = $_.Name} -PassThru} |
        Where {$Type.Count -eq 0 -or (Compare $Type $_.Type -IncludeEqual -ExcludeDifferent | Measure).Count -gt 0} |
        Where {$Algorithm.Count -eq 0 -or (Compare $Algorithm $_.HashRates.PSObject.Properties.Name -IncludeEqual -ExcludeDifferent | Measure).Count -gt 0} |
        Where {$MinerName.Count -eq 0 -or (Compare $MinerName $_.Name -IncludeEqual -ExcludeDifferent | Measure).Count -gt 0}}
    $Miners = $Miners | ForEach {
        $Miner = $_
        if((Test-Path $Miner.Path) -eq $false)
        {
            Write-host "Downloading $($Miner.Name).." -foregroundcolor "Yellow"
            if((Split-Path $Miner.URI -Leaf) -eq (Split-Path $Miner.Path -Leaf))
            {
                New-Item (Split-Path $Miner.Path) -ItemType "Directory" | Out-Null
                Invoke-WebRequest $Miner.URI -OutFile $_.Path -UseBasicParsing
            }
            elseif(([IO.FileInfo](Split-Path $_.URI -Leaf)).Extension -eq '')
            {
                $Path_Old = Get-PSDrive -PSProvider FileSystem | ForEach {Get-ChildItem -Path $_.Root -Include (Split-Path $Miner.Path -Leaf) -Recurse -ErrorAction Ignore} | Sort LastWriteTimeUtc -Descending | Select -First 1
                $Path_New = $Miner.Path

                if($Path_Old -ne $null)
                {
                    if(Test-Path (Split-Path $Path_New)){(Split-Path $Path_New) | Remove-Item -Recurse -Force}
                    (Split-Path $Path_Old) | Copy-Item -Destination (Split-Path $Path_New) -Recurse -Force
                }
                else
                {
                    Write-Host -BackgroundColor Yellow -ForegroundColor Black "Cannot find $($Miner.Path) distributed at $($Miner.URI). "
                }
            }
            else
            {
                Expand-WebRequest $Miner.URI (Split-Path $Miner.Path)
            }
        }
        else
        {
            $Miner
        }
    }
    if($Miners.Count -eq 0){"No Miners!" | Out-Host; sleep $Interval; continue}
    $Miners | ForEach {
        $Miner = $_
        $Miner_HashRates = [PSCustomObject]@{}
        $Miner_Pools = [PSCustomObject]@{}
        $Miner_Pools_Comparison = [PSCustomObject]@{}
        $Miner_Profits = [PSCustomObject]@{}
        $Miner_Profits_Comparison = [PSCustomObject]@{}
        $Miner_Profits_Bias = [PSCustomObject]@{}
        $Miner_Types = $Miner.Type | Select -Unique
        $Miner_Indexes = $Miner.Index | Select -Unique
        $Miner.HashRates | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
            $Miner_HashRates | Add-Member $_ ([Double]$Miner.HashRates.$_)
            $Miner_Pools | Add-Member $_ ([PSCustomObject]$Pools.$_)
            $Miner_Pools_Comparison | Add-Member $_ ([PSCustomObject]$Pools_Comparison.$_)
            $Miner_Profits | Add-Member $_ ([Double]$Miner.HashRates.$_*$Pools.$_.Price)
            $Miner_Profits_Comparison | Add-Member $_ ([Double]$Miner.HashRates.$_*$Pools_Comparison.$_.Price)
            $Miner_Profits_Bias | Add-Member $_ ([Double]$Miner.HashRates.$_*$Pools.$_.Price*(1-($MarginOfError*[Math]::Pow($DecayBase,$DecayExponent))))
        }
        $Miner_Profit = [Double]($Miner_Profits.PSObject.Properties.Value | Measure -Sum).Sum
        $Miner_Profit_Comparison = [Double]($Miner_Profits_Comparison.PSObject.Properties.Value | Measure -Sum).Sum
        $Miner_Profit_Bias = [Double]($Miner_Profits_Bias.PSObject.Properties.Value | Measure -Sum).Sum
        $Miner.HashRates | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
            if(-not [String]$Miner.HashRates.$_)
            {
                $Miner_HashRates.$_ = $null
                $Miner_Profits.$_ = $null
                $Miner_Profits_Comparison.$_ = $null
                $Miner_Profits_Bias.$_ = $null
                $Miner_Profit = $null
                $Miner_Profit_Comparison = $null
                $Miner_Profit_Bias = $null
            }
        }
        if($Miner_Types -eq $null){$Miner_Types = $Miners.Type | Select -Unique}
        if($Miner_Indexes -eq $null){$Miner_Indexes = $Miners.Index | Select -Unique}
        if($Miner_Types -eq $null){$Miner_Types = ""}
        if($Miner_Indexes -eq $null){$Miner_Indexes = 0}
        $Miner.HashRates = $Miner_HashRates
        $Miner | Add-Member Pools $Miner_Pools
        $Miner | Add-Member Profits $Miner_Profits
        $Miner | Add-Member Profits_Comparison $Miner_Profits_Comparison
        $Miner | Add-Member Profits_Bias $Miner_Profits_Bias
        $Miner | Add-Member Profit $Miner_Profit
        $Miner | Add-Member Profit_Comparison $Miner_Profit_Comparison
        $Miner | Add-Member Profit_Bias $Miner_Profit_Bias
        $Miner | Add-Member Profit_Bias_Orig $Miner_Profit_Bias
        $Miner | Add-Member Type $Miner_Types -Force
        $Miner | Add-Member Index $Miner_Indexes -Force
        $Miner.Path = Convert-Path $Miner.Path
    }
    $Miners | ForEach {
        $Miner = $_
        $Miner_Devices = $Miner.Device | Select -Unique
        if($Miner_Devices -eq $null){$Miner_Devices = ($Miners | Where {(Compare $Miner.Type $_.Type -IncludeEqual -ExcludeDifferent | Measure).Count -gt 0}).Device | Select -Unique}
        if($Miner_Devices -eq $null){$Miner_Devices = $Miner.Type}
        $Miner | Add-Member Device $Miner_Devices -Force
    }
    $ActiveMinerPrograms | Where { $_.Status -eq "Running" } | ForEach {$Miners | Where Path -EQ $_.Path | Where Arguments -EQ $_.Arguments | ForEach {$_.Profit_Bias = $_.Profit * (1 + $ActiveMinerGainPct / 100)}}
    $BestMiners = $Miners | Select Type,Index -Unique | ForEach {$Miner_GPU = $_; ($Miners | Where {(Compare $Miner_GPU.Type $_.Type | Measure).Count -eq 0 -and (Compare $Miner_GPU.Index $_.Index | Measure).Count -eq 0} | Sort -Descending {($_ | Where Profit -EQ $null | Measure).Count},{($_ | Measure Profit_Bias -Sum).Sum},{($_ | Where Profit -NE 0 | Measure).Count} | Select -First 1)}
    $BestDeviceMiners = $Miners | Select Device -Unique | ForEach {$Miner_GPU = $_; ($Miners | Where {(Compare $Miner_GPU.Device $_.Device | Measure).Count -eq 0} | Sort -Descending {($_ | Where Profit -EQ $null | Measure).Count},{($_ | Measure Profit_Bias -Sum).Sum},{($_ | Where Profit -NE 0 | Measure).Count} | Select -First 1)}
    $BestMiners_Comparison = $Miners | Select Type,Index -Unique | ForEach {$Miner_GPU = $_; ($Miners | Where {(Compare $Miner_GPU.Type $_.Type | Measure).Count -eq 0 -and (Compare $Miner_GPU.Index $_.Index | Measure).Count -eq 0} | Sort -Descending {($_ | Where Profit -EQ $null | Measure).Count},{($_ | Measure Profit_Comparison -Sum).Sum},{($_ | Where Profit -NE 0 | Measure).Count} | Select -First 1)}
    $BestDeviceMiners_Comparison = $Miners | Select Device -Unique | ForEach {$Miner_GPU = $_; ($Miners | Where {(Compare $Miner_GPU.Device $_.Device | Measure).Count -eq 0} | Sort -Descending {($_ | Where Profit -EQ $null | Measure).Count},{($_ | Measure Profit_Comparison -Sum).Sum},{($_ | Where Profit -NE 0 | Measure).Count} | Select -First 1)}
    $Miners_Type_Combos = @([PSCustomObject]@{Combination = @()}) + (Get-Combination ($Miners | Select Type -Unique) | Where{(Compare ($_.Combination | Select -ExpandProperty Type -Unique) ($_.Combination | Select -ExpandProperty Type) | Measure).Count -eq 0})
    $Miners_Index_Combos = @([PSCustomObject]@{Combination = @()}) + (Get-Combination ($Miners | Select Index -Unique) | Where{(Compare ($_.Combination | Select -ExpandProperty Index -Unique) ($_.Combination | Select -ExpandProperty Index) | Measure).Count -eq 0})
    $Miners_Device_Combos = (Get-Combination ($Miners | Select Device -Unique) | Where{(Compare ($_.Combination | Select -ExpandProperty Device -Unique) ($_.Combination | Select -ExpandProperty Device) | Measure).Count -eq 0})
    $BestMiners_Combos = $Miners_Type_Combos | ForEach {$Miner_Type_Combo = $_.Combination; $Miners_Index_Combos | ForEach {$Miner_Index_Combo = $_.Combination; [PSCustomObject]@{Combination = $Miner_Type_Combo | ForEach {$Miner_Type_Count = $_.Type.Count; [Regex]$Miner_Type_Regex = '^(' + (($_.Type | ForEach {[Regex]::Escape($_)}) -join '|') + ')$'; $Miner_Index_Combo | ForEach {$Miner_Index_Count = $_.Index.Count; [Regex]$Miner_Index_Regex = '^(' + (($_.Index | ForEach {[Regex]::Escape($_)}) -join '|') + ')$'; $BestMiners | Where {([Array]$_.Type -notmatch $Miner_Type_Regex).Count -eq 0 -and ([Array]$_.Index -notmatch $Miner_Index_Regex).Count -eq 0 -and ([Array]$_.Type -match $Miner_Type_Regex).Count -eq $Miner_Type_Count -and ([Array]$_.Index -match $Miner_Index_Regex).Count -eq $Miner_Index_Count}}}}}}
    $BestMiners_Combos += $Miners_Device_Combos | ForEach {$Miner_Device_Combo = $_.Combination; [PSCustomObject]@{Combination = $Miner_Device_Combo | ForEach {$Miner_Device_Count = $_.Device.Count; [Regex]$Miner_Device_Regex = '^(' + (($_.Device | ForEach {[Regex]::Escape($_)}) -join '|') + ')$'; $BestDeviceMiners | Where {([Array]$_.Device -notmatch $Miner_Device_Regex).Count -eq 0 -and ([Array]$_.Device -match $Miner_Device_Regex).Count -eq $Miner_Device_Count}}}}
    $BestMiners_Combos_Comparison = $Miners_Type_Combos | ForEach {$Miner_Type_Combo = $_.Combination; $Miners_Index_Combos | ForEach {$Miner_Index_Combo = $_.Combination; [PSCustomObject]@{Combination = $Miner_Type_Combo | ForEach {$Miner_Type_Count = $_.Type.Count; [Regex]$Miner_Type_Regex = '^(' + (($_.Type | ForEach {[Regex]::Escape($_)}) -join '|') + ')$'; $Miner_Index_Combo | ForEach {$Miner_Index_Count = $_.Index.Count; [Regex]$Miner_Index_Regex = '^(' + (($_.Index | ForEach {[Regex]::Escape($_)}) -join '|') + ')$'; $BestMiners_Comparison | Where {([Array]$_.Type -notmatch $Miner_Type_Regex).Count -eq 0 -and ([Array]$_.Index -notmatch $Miner_Index_Regex).Count -eq 0 -and ([Array]$_.Type -match $Miner_Type_Regex).Count -eq $Miner_Type_Count -and ([Array]$_.Index -match $Miner_Index_Regex).Count -eq $Miner_Index_Count}}}}}}
    $BestMiners_Combos_Comparison += $Miners_Device_Combos | ForEach {$Miner_Device_Combo = $_.Combination; [PSCustomObject]@{Combination = $Miner_Device_Combo | ForEach {$Miner_Device_Count = $_.Device.Count; [Regex]$Miner_Device_Regex = '^(' + (($_.Device | ForEach {[Regex]::Escape($_)}) -join '|') + ')$'; $BestDeviceMiners_Comparison | Where {([Array]$_.Device -notmatch $Miner_Device_Regex).Count -eq 0 -and ([Array]$_.Device -match $Miner_Device_Regex).Count -eq $Miner_Device_Count}}}}
    $BestMiners_Combo = $BestMiners_Combos | Sort -Descending {($_.Combination | Where Profit -EQ $null | Measure).Count},{($_.Combination | Measure Profit_Bias -Sum).Sum},{($_.Combination | Where Profit -NE 0 | Measure).Count} | Select -First 1 | Select -ExpandProperty Combination
    $BestMiners_Combo_Comparison = $BestMiners_Combos_Comparison | Sort -Descending {($_.Combination | Where Profit -EQ $null | Measure).Count},{($_.Combination | Measure Profit_Comparison -Sum).Sum},{($_.Combination | Where Profit -NE 0 | Measure).Count} | Select -First 1 | Select -ExpandProperty Combination
    $BestMiners_Combo | ForEach {
        if(($ActiveMinerPrograms | Where Path -EQ $_.Path | Where Arguments -EQ $_.Arguments).Count -eq 0)
        {
            $ActiveMinerPrograms += [PSCustomObject]@{
                Name = $_.Name
                Path = $_.Path
                Arguments = $_.Arguments
                Wrap = $_.Wrap
                Process = $null
                API = $_.API
                Port = $_.Port
                Algorithms = $_.HashRates.PSObject.Properties.Name
                New = $false
                Active = [TimeSpan]0
                Activated = 0
                Status = "Idle"
                HashRate = 0
                Benchmarked = 0
                Hashrate_Gathered = ($_.HashRates.PSObject.Properties.Value -ne $null)
            }
        }
    }
    $ActiveMinerPrograms | ForEach {
        [Array]$filtered = ($BestMiners_Combo | Where Path -EQ $_.Path | Where Arguments -EQ $_.Arguments)
        if($filtered.Count -eq 0)
        {
            if($_.Process -eq $null)
            {
                $_.Status = "Failed"
            }
            elseif($_.Process.HasExited -eq $false)
            {
            $_.Active += (Get-Date)-$_.Process.StartTime
               $_.Process.CloseMainWindow() | Out-Null
               Sleep 1
               Stop-Process $_.Process -Force | Out-Null
               Write-Host -ForegroundColor Yellow "closing current miner and switching"
               Sleep 1
               $_.Status = "Idle"
            }
            $Miners | Where Path -EQ $_.Path | Where Arguments -EQ $_.Arguments | ForEach {$_.Profit_Bias = $_.Profit_Bias_Orig}
        }
    }
    $newMiner = $false
    $CurrentMinerHashrate_Gathered =$false
    $newMiner = $false
    $CurrentMinerHashrate_Gathered =$false
    $ActiveMinerPrograms | ForEach {
        [Array]$filtered = ($BestMiners_Combo | Where Path -EQ $_.Path | Where Arguments -EQ $_.Arguments)
        if($filtered.Count -gt 0)
        {
            if($_.Process -eq $null -or $_.Process.HasExited -ne $false)
            {
 		# Log switching information to .\log\swicthing.log
		[pscustomobject]@{date=(get-date);algo=$_.Algorithms;wallet=$Wallet;username=$UserName} | export-csv .\Logs\switching.log -Append -NoTypeInformation

 		# Launch prerun if exists
		$PrerunName = ".\Prerun\"+$_.Algorithms+".bat"
		$DefaultPrerunName = ".\Prerun\default.bat"
                If (Test-Path $PrerunName) {
			Write-Host -F Yellow "Launching Prerun: " $PrerunName
			Start-Process $PrerunName -WorkingDirectory ".\Prerun"
			Sleep 2
		} else {
			If (Test-Path $DefaultPrerunName) {
				Write-Host -F Yellow "Launching Prerun: " $DefaultPrerunName
				Start-Process $DefaultPrerunName -WorkingDirectory ".\Prerun"
				Sleep 2
				}
		}

                Sleep $Delay
                $DecayStart = Get-Date
                $_.New = $true
                $_.Activated++
                if($_.Process -ne $null){$_.Active += $_.Process.ExitTime-$_.Process.StartTime}
                if($_.Wrap){$_.Process = Start-Process -FilePath "PowerShell" -ArgumentList "-executionpolicy bypass -command . '$(Convert-Path ".\Wrapper.ps1")' -ControllerProcessID $PID -Id '$($_.Port)' -FilePath '$($_.Path)' -ArgumentList '$($_.Arguments)' -WorkingDirectory '$(Split-Path $_.Path)'" -PassThru}
                else{$_.Process = Start-SubProcess -FilePath $_.Path -ArgumentList $_.Arguments -WorkingDirectory (Split-Path $_.Path)}
                if($_.Process -eq $null){$_.Status = "Failed"}
                else {
                    $_.Status = "Running"
                    $newMiner = $true
                    $Miners | Where Path -EQ $_.Path | Where Arguments -EQ $_.Arguments | ForEach {$_.Profit_Bias = $_.Profit * (1 + $ActiveMinerGainPct / 100)}
                    $newMiner = $true
                    $Miners | Where Path -EQ $_.Path | Where Arguments -EQ $_.Arguments | ForEach {$_.Profit_Bias = $_.Profit * (1 + $ActiveMinerGainPct / 100)}
                }
            }
            $CurrentMinerHashrate_Gathered = $_.Hashrate_Gathered
        }
    }
    Clear-Host
    [Array] $processesIdle = $ActiveMinerPrograms | Where { $_.Status -eq "Idle" }
    if ($processesIdle.Count -gt 0) {
        Write-Host "Idle: " $processesIdle.Count
        $processesIdle | Sort {if($_.Process -eq $null){(Get-Date)}else{$_.Process.ExitTime}} | Format-Table -Wrap (
            @{Label = "Speed"; Expression={$_.HashRate | ForEach {"$($_ | ConvertTo-Hash)/s"}}; Align='right'},
            @{Label = "Exited"; Expression={"{0:dd}:{0:hh}:{0:mm}" -f $(if($_.Process -eq $null){(0)}else{(Get-Date) - $_.Process.ExitTime}) }},
            @{Label = "Active"; Expression={"{0:dd}:{0:hh}:{0:mm}" -f $(if($_.Process -eq $null){$_.Active}else{if($_.Process.ExitTime -gt $_.Process.StartTime){($_.Active+($_.Process.ExitTime-$_.Process.StartTime))}else{($_.Active+((Get-Date)-$_.Process.StartTime))}})}},
            @{Label = "Cnt"; Expression={Switch($_.Activated){0 {"Never"} 1 {"Once"} Default {"$_"}}}},
            @{Label = "Command"; Expression={"$($_.Path.TrimStart((Convert-Path ".\"))) $($_.Arguments)"}}
        ) | Out-Host
    }
    Clear-Host
    Write-Host "1 BTC = " $Rates.$Currency "$Currency"
    $Miners | Sort -Descending Type,Profit | Format-Table -GroupBy Type (
    @{Label = "Miner"; Expression={$_.Name}},
    @{Label = "Algorithm"; Expression={$_.HashRates.PSObject.Properties.Name}},
    @{Label = "Speed"; Expression={$_.HashRates.PSObject.Properties.Value | ForEach {if($_ -ne $null){"$($_ | ConvertTo-Hash)/s"}else{"Benchmarking"}}}; Align='right'},
    @{Label = "mBTC/Day"; Expression={$_.Profits.PSObject.Properties.Value*1000 | ForEach {if($_ -ne $null){$_.ToString("N3")}else{"Benchmarking"}}}; Align='right'},
    @{Label = "BTC/Day"; Expression={$_.Profits.PSObject.Properties.Value | ForEach {if($_ -ne $null){$_.ToString("N5")}else{"Benchmarking"}}}; Align='right'},
    @{Label = "$Currency/Day"; Expression={$_.Profits.PSObject.Properties.Value | ForEach {if($_ -ne $null){($_ * $Rates.$Currency).ToString("N3")}else{"Benchmarking"}}}; Align='right'},
    @{Label = "BTC/GH/Day"; Expression={$_.Pools.PSObject.Properties.Value.Price | ForEach {($_*1000000000).ToString("N5")}}; Align='right'},
    @{Label = "Pool"; Expression={$_.Pools.PSObject.Properties.Value | ForEach {"$($_.Name)-$($_.Info)"}}}
    ) | Out-Host
    [Array] $processRunning = $ActiveMinerPrograms | Where { $_.Status -eq "Running" }
    Write-Host "Running:"
    $processRunning | Sort {if($_.Process -eq $null){[DateTime]0}else{$_.Process.StartTime}} | Select -First (1) | Format-Table -Wrap (
        @{Label = "Speed"; Expression={$_.HashRate | ForEach {"$($_ | ConvertTo-Hash)/s"}}; Align='right'},
        @{Label = "Started"; Expression={"{0:dd}:{0:hh}:{0:mm}" -f $(if($_.Process -eq $null){(0)}else{(Get-Date) - $_.Process.StartTime}) }},
        @{Label = "Active"; Expression={"{0:dd}:{0:hh}:{0:mm}" -f $(if($_.Process -eq $null){$_.Active}else{if($_.Process.ExitTime -gt $_.Process.StartTime){($_.Active+($_.Process.ExitTime-$_.Process.StartTime))}else{($_.Active+((Get-Date)-$_.Process.StartTime))}})}},
        @{Label = "Cnt"; Expression={Switch($_.Activated){0 {"Never"} 1 {"Once"} Default {"$_"}}}},
        @{Label = "Command"; Expression={"$($_.Path.TrimStart((Convert-Path ".\"))) $($_.Arguments)"}}
    ) | Out-Host
    [Array] $processesFailed = $ActiveMinerPrograms | Where { $_.Status -eq "Failed" }
    if ($processesFailed.Count -gt 0) {
        Write-Host -ForegroundColor Red "Failed: " $processesFailed.Count
        $processesFailed | Sort {if($_.Process -eq $null){[DateTime]0}else{$_.Process.StartTime}} | Format-Table -Wrap (
            @{Label = "Speed"; Expression={$_.HashRate | ForEach {"$($_ | ConvertTo-Hash)/s"}}; Align='right'},
            @{Label = "Exited"; Expression={"{0:dd}:{0:hh}:{0:mm}" -f $(if($_.Process -eq $null){(0)}else{(Get-Date) - $_.Process.ExitTime}) }},
            @{Label = "Active"; Expression={"{0:dd}:{0:hh}:{0:mm}" -f $(if($_.Process -eq $null){$_.Active}else{if($_.Process.ExitTime -gt $_.Process.StartTime){($_.Active+($_.Process.ExitTime-$_.Process.StartTime))}else{($_.Active+((Get-Date)-$_.Process.StartTime))}})}},
            @{Label = "Cnt"; Expression={Switch($_.Activated){0 {"Never"} 1 {"Once"} Default {"$_"}}}},
            @{Label = "Command"; Expression={"$($_.Path.TrimStart((Convert-Path ".\"))) $($_.Arguments)"}}
        ) | Out-Host
    }
    Write-Host "--------------------------------------------------------------------------------"
    Write-Host -ForegroundColor Yellow "Last Refresh: $(Get-Date)"
    if ($newMiner -eq $true) {
        if ($Interval -ge $FirstInterval -and $Interval -ge $StatsInterval) { $timeToSleep = $Interval }
        else {
            if ($CurrentMinerHashrate_Gathered -eq $true) { $timeToSleep = $FirstInterval }
            else { $timeToSleep =  $StatsInterval }
        }
    } else {
        $timeToSleep = $Interval
    }
    Write-Host "Sleep" $timeToSleep "sec"
    Sleep $timeToSleep
    Write-Host "--------------------------------------------------------------------------------"
    [Array] $processRunning = $ActiveMinerPrograms | Where { $_.Status -eq "Running" }
    Write-Host "Running:"
    $processRunning | Sort {if($_.Process -eq $null){[DateTime]0}else{$_.Process.StartTime}} | Select -First (1) | Format-Table -Wrap (
        @{Label = "Speed"; Expression={$_.HashRate | ForEach {"$($_ | ConvertTo-Hash)/s"}}; Align='right'},
        @{Label = "Started"; Expression={"{0:dd}:{0:hh}:{0:mm}" -f $(if($_.Process -eq $null){(0)}else{(Get-Date) - $_.Process.StartTime}) }},
        @{Label = "Active"; Expression={"{0:dd}:{0:hh}:{0:mm}" -f $(if($_.Process -eq $null){$_.Active}else{if($_.Process.ExitTime -gt $_.Process.StartTime){($_.Active+($_.Process.ExitTime-$_.Process.StartTime))}else{($_.Active+((Get-Date)-$_.Process.StartTime))}})}},
        @{Label = "Cnt"; Expression={Switch($_.Activated){0 {"Never"} 1 {"Once"} Default {"$_"}}}},
        @{Label = "Command"; Expression={"$($_.Path.TrimStart((Convert-Path ".\"))) $($_.Arguments)"}}
    ) | Out-Host
    [Array] $processesFailed = $ActiveMinerPrograms | Where { $_.Status -eq "Failed" }
    if ($processesFailed.Count -gt 0) {
        Write-Host -ForegroundColor Red "Failed: " $processesFailed.Count
        $processesFailed | Sort {if($_.Process -eq $null){[DateTime]0}else{$_.Process.StartTime}} | Format-Table -Wrap (
            @{Label = "Speed"; Expression={$_.HashRate | ForEach {"$($_ | ConvertTo-Hash)/s"}}; Align='right'},
            @{Label = "Exited"; Expression={"{0:dd}:{0:hh}:{0:mm}" -f $(if($_.Process -eq $null){(0)}else{(Get-Date) - $_.Process.ExitTime}) }},
            @{Label = "Active"; Expression={"{0:dd}:{0:hh}:{0:mm}" -f $(if($_.Process -eq $null){$_.Active}else{if($_.Process.ExitTime -gt $_.Process.StartTime){($_.Active+($_.Process.ExitTime-$_.Process.StartTime))}else{($_.Active+((Get-Date)-$_.Process.StartTime))}})}},
            @{Label = "Cnt"; Expression={Switch($_.Activated){0 {"Never"} 1 {"Once"} Default {"$_"}}}},
            @{Label = "Command"; Expression={"$($_.Path.TrimStart((Convert-Path ".\"))) $($_.Arguments)"}}
        ) | Out-Host
    }
    Write-Host "--------------------------------------------------------------------------------"
    Write-Host -ForegroundColor Yellow "Last Refresh: $(Get-Date)"
    if ($newMiner -eq $true) {
        if ($Interval -ge $FirstInterval -and $Interval -ge $StatsInterval) { $timeToSleep = $Interval }
        else {
            if ($CurrentMinerHashrate_Gathered -eq $true) { $timeToSleep = $FirstInterval }
            else { $timeToSleep =  $StatsInterval }
        }
    } else {
    $timeToSleep = $Interval
    }
    Write-Host "Sleep" $timeToSleep "sec"
    Sleep $timeToSleep
    Write-Host "--------------------------------------------------------------------------------"
    $ActiveMinerPrograms | ForEach {
        if($_.Process -eq $null -or $_.Process.HasExited)
        {
            if($_.Status -eq "Running"){$_.Status = "Failed"}
        }
        else
        {
            $WasActive = [math]::Round(((Get-Date)-$_.Process.StartTime).TotalSeconds)
            if ($WasActive -ge $StatsInterval) {
                $_.HashRate = 0
                $Miner_HashRates = $null
                if($_.New){$_.Benchmarked++}
                $Miner_HashRates = Get-HashRate $_.API $_.Port ($_.New -and $_.Benchmarked -lt 3)
                $_.HashRate = $Miner_HashRates | Select -First $_.Algorithms.Count
                if($Miner_HashRates.Count -ge $_.Algorithms.Count)
                {
                    for($i = 0; $i -lt $_.Algorithms.Count; $i++)
                    {
                        $Stat = Set-Stat -Name "$($_.Name)_$($_.Algorithms | Select -Index $i)_HashRate" -Value ($Miner_HashRates | Select -Index $i)
                    }
                    $_.New = $false
                    $_.Hashrate_Gathered = $true
                    Write-Host "Stats '"$_.Algorithms"' -> "($Miner_HashRates | ConvertTo-Hash)"after"$WasActive" sec"
                    Write-Host "--------------------------------------------------------------------------------"
                }
            }
        }
    }
}
Stop-Transcript
