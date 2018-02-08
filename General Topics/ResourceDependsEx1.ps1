<#
 .synopsis
 A resource can depend on one or more other resources
#>

configuration WebsiteSetup
{

  Import-DscResource -ModuleName PSDesiredStateConfiguration
  Import-DSCResource -ModuleName xWebAdministration
    
  node Localhost
  {

    # Setup the home page
    File DefaultPage
    {
      Ensure = "Present"
      DestinationPath = "C:\Webserver\htdocs\Default.htm"
      Contents = "<H3>Alles klar mit DSC!</H3>"
    }

    # Setup a website but only if IIS has been installed already
    xWebsite PoshSite
    {
      Ensure = "Present"
      Name = "PoshSite"
      State = "Started"
      PhysicalPath = "C:\Webserver\htdocs"
      DependsOn = "[WindowsFeature]IIS"
      BindingInfo = MSFT_xWebBindingInformation
                    {
                       Protocol = "HTTP"
                       Port = 8000
                    }
    }

    # Setup the IIS
    WindowsFeature IIS
    {
      Ensure = "Present"
      Name = "Web-Server"
      IncludeAllSubFeature = $true
    }
   }
}

WebsiteSetup

Start-DSCConfiguration -Path .\WebsiteSetup -Verbose -Wait -Force