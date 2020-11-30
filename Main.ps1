#########################################################################
#                        Import Modules                                 #
#########################################################################


#########################################################################
#                        Import Assemblies                              #
#########################################################################
    Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms, System.Drawing 
    $AssemblyLocation = ".\DLL\"
    foreach ($Assembly in (Get-ChildItem $AssemblyLocation -Filter *.dll)) {
        try {
            [System.Reflection.Assembly]::LoadFrom($Assembly.fullName) | out-null
            Write-Host -ForegroundColor Green "Loaded $($Assembly.fullname)"
        }#End Try
        catch {
            Write-Host -ForegroundColor Red "Failed to load $($Assembly.fullname)"
        }#End Catch
    }#End Foreach
#########################################################################
#                        Import Main XAML File                          #
#########################################################################
    [xml]$Main_Xaml = (Get-Content -Path .\XAML\Main_GUI.Xaml)
    $Main_Reader = (New-Object System.Xml.XmlNodeReader $Main_Xaml) 
    $Main_Form = [Windows.Markup.XamlReader]::Load($Main_Reader)
#########################################################################
#                        Getting Variables From Form                    #
#########################################################################
    $Main_Xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object { 
        New-Variable  -Name $_.Name -Value $Main_Form.FindName($_.Name) -Scope Global -Force
        Write-Host -ForegroundColor Yellow "Generated Variable $($_.Name)"
    }

#########################################################################
#                        Main Functionality                             #
#########################################################################
    #$Button_1.Content = "Im a button"
    $Button_1.Add_Click({
        Write-Host -ForegroundColor Red "You clicked Button 1"
    })

    $Main_Form.ShowDialog() | Out-Null