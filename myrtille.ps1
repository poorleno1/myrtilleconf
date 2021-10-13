configuration myrtille
{
    # One can evaluate expressions to get the node list
    # E.g: $AllNodes.Where("Role -eq Web").NodeName
    node localhost
    {
        # Call Resource Provider
        # E.g: WindowsFeature, File
        File TempDir {
            DestinationPath = "$env:SystemDrive\scripts"
            Type            = "Directory"
            Ensure          = "Present"
        }
         
       Script DownloadMyrtille {
       
           GetScript = {
                $result = Test-Path "c:\scripts\Myrtille_2.9.2_x86_x64_Setup.msi"
                return @{ "Result" = $result }
           }

           TestScript = {
                $state = [scriptblock]::Create($GetScript).Invoke()
                
                if ($state.Result)
                {
                    return $true
                }
                else
                {
                    return $false
                }
           }
           SetScript = {
                Start-BitsTransfer "https://github.com/cedrozor/myrtille/releases/download/v2.9.2/Myrtille_2.9.2_x86_x64_Setup.msi" -Destination C:\scripts
           }
       }
       
       Package MyrtilleInstall {
            Ensure    = "Present"  # You can also set Ensure to "Absent"
            Path      = "C:\scripts\Myrtille_2.9.2_x86_x64_Setup.msi"
            #Arguments = ''
            Name      = "Myrtille"
            ProductId = "342A3EAA-FDA8-4C61-AC22-29552B7A8773"
            DependsOn = "[Script]DownloadMyrtille"
        }


        Registry RegistryKeyApplicationsfDisabledAllowList
        {
            Ensure      = "Present"  # You can also set Ensure to "Absent"
            Key         = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\TSAppAllowList"
            ValueName   = "fDisabledAllowList"
            ValueType   = "Dword"
            valueData   = 1
        }

        Registry RegistryKeyApplications
        {
            Ensure      = "Present"  # You can also set Ensure to "Absent"
            Key         = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\TSAppAllowList\Applications"
            ValueName   = ""
        }

        Registry RegistryKeyApplicationsCalc
        {
            Ensure      = "Present"  # You can also set Ensure to "Absent"
            Key         = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\TSAppAllowList\Applications\Calc"
            ValueName   = ""
            DependsOn   = "[Registry]RegistryKeyApplications"
        }

        Registry RegistryKeyApplicationsCalcSetting1
        {
            Ensure      = "Present"  # You can also set Ensure to "Absent"
            Key         = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\TSAppAllowList\Applications\Calc"
            ValueName   = "Name"
            valueData   = "calc.exe"
            DependsOn   = "[Registry]RegistryKeyApplicationsCalc"
        }

        Registry RegistryKeyApplicationsCalcSetting2
        {
            Ensure      = "Present"  # You can also set Ensure to "Absent"
            Key         = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\TSAppAllowList\Applications\Calc"
            ValueName   = "Path"
            valueData   = "c:\windows\system32"
            DependsOn   = "[Registry]RegistryKeyApplicationsCalc"
        }


        WindowsFeature RDS-RD-Server 
        {
            Name = "RDS-RD-Server"
            Ensure = "Present"
        }
    }
}

myrtille
Start-DscConfiguration .\myrtille -Wait -Verbose -ComputerName localhost -Force
