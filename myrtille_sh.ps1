configuration myrtille_sh
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
        
        Registry RegistryKeyApplicationsfDisabledAllowList {
            Ensure    = "Present"  # You can also set Ensure to "Absent"
            Key       = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\TSAppAllowList"
            ValueName = "fDisabledAllowList"
            ValueType = "Dword"
            valueData = 1
        }

        # Registry RegistryKeyApplications {
        #     Ensure    = "Present"  # You can also set Ensure to "Absent"
        #     Key       = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\TSAppAllowList\Applications"
        #     ValueName = ""
        # }

        # Registry RegistryKeyApplicationsCalc {
        #     Ensure    = "Present"  # You can also set Ensure to "Absent"
        #     Key       = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\TSAppAllowList\Applications\Calc"
        #     ValueName = ""
        #     DependsOn = "[Registry]RegistryKeyApplications"
        # }

        # Registry RegistryKeyApplicationsCalcSetting1 {
        #     Ensure    = "Present"  # You can also set Ensure to "Absent"
        #     Key       = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\TSAppAllowList\Applications\Calc"
        #     ValueName = "Name"
        #     valueData = "calc.exe"
        #     DependsOn = "[Registry]RegistryKeyApplicationsCalc"
        # }

        # Registry RegistryKeyApplicationsCalcSetting2 {
        #     Ensure    = "Present"  # You can also set Ensure to "Absent"
        #     Key       = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\TSAppAllowList\Applications\Calc"
        #     ValueName = "Path"
        #     valueData = "c:\windows\system32"
        #     DependsOn = "[Registry]RegistryKeyApplicationsCalc"
        # }

        WindowsFeature RDS-RD-Server {
            Name   = "RDS-RD-Server"
            Ensure = "Present"
        }
        
        Registry RegistryKeyLicensing {
            Ensure    = "Present"  # You can also set Ensure to "Absent"
            Key       = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\RCM\Licensing Core"
            ValueName = "LicensingMode"
            valueData = "4"
            ValueType = "Dword"
            DependsOn = "[WindowsFeature]RDS-RD-Server"
        }
    }
}

myrtille_sh
Start-DscConfiguration .\myrtille_sh -Wait -Verbose -ComputerName localhost -Force
