﻿function New-ScpSession
{
<#
	.SYNOPSIS
		A brief description of the New-ScpSession function.
	
	.DESCRIPTION
		A detailed description of the New-ScpSession function.
	
	.PARAMETER RemoteHost
		A string representing the remote host to connect to.
	
	.PARAMETER NoSshKeyCheck
		When parameter is used will PowerScp will skip verification of remote host SSH key for example when connecting to a known host.
		
		Switch should be used only in exceptional cases when connecting to known or internal hosts as it will compromise connection security.
	
	.PARAMETER NoTlsCheck
		When parameter is used PowerScp will skip vericication of remote host TLS/SSL Certificate for example wehn connecting to a known host.
		
		Switch should be used only in exceptional cases when connecting to known or internal hosts as it will compromise connection security.
		
		Use when connecting to FTPS/WebDAVS servers.
	
	.PARAMETER ServerPort
		An Int number representing the port number to use establish the connection if not specified default value of 22 (SCP) will be used.
		
		Allowed values are 0 - 65535
	
	.PARAMETER SshKeyPath
		A description of the SshKeyPath parameter.
	
	.PARAMETER Protocol
		When parameter is used a protocol to be used in the connection can be specified. If parameter is not used default protocol is set to SCP
	
	.PARAMETER FtpMode
		Specify the FTP operation mdoe either Active or Passive.
		
		If not specified it will default to Passive.
		
		Valid values are:
		
		- Active
		- Passive (Default)
	
	.PARAMETER FtpSecure
		By default set to None specifies the type of security the client should used to FTPS servers.
		
		Valid values are:
		
		- None (Default)
		- Implicit
		- Explicit
	
	.PARAMETER ConnectionTimeOut
		A description of the ConnectionTimeOut parameter.
	
	.PARAMETER WebDavSecure
		A description of the WebDavSecure parameter.
	
	.PARAMETER WebDavRoot
		A string representing the WebDAV root path.
	
	.PARAMETER UserName
		A string representing the username that will be used to authenticate agains the remote host.
	
	.PARAMETER UserPassword
		A string representing the password used to connect to the remote host.
	
	.PARAMETER SshHostKeyFingerprint
		A description of the SshHostKeyFingerprint parameter.
	
	.PARAMETER Credentials
		A description of the Credentials parameter.
	
	.PARAMETER SshKeyPassword
		A description of the SshKeyPassword parameter.
	
	.PARAMETER SessionLogPath
		A string representing the path where session log should be written.
	
	.PARAMETER DebugLevel
		An integer representing verbosity of debug log. If not specified default to 0 which means no debug logging.
	
	.PARAMETER DebugLogPath
		A description of the DebugLogPath parameter.
	
	.PARAMETER ReconnectTime
		Time, in seconds, to try reconnecting broken sessions. Default is 120 seconds.
	
	.PARAMETER PrivateKeyPath
		A string representing the path to a file containing an SSH private key used for authentication with remote host.
	
	.EXAMPLE
		PS C:\> New-ScpSession -RemoteHost 'Value1'
	
	.OUTPUTS
		WinSCP.Session
	
	.NOTES
		Additional information about the function.
#>
	
	[CmdletBinding(DefaultParameterSetName = 'UsernamePassword')]
	[OutputType([WinSCP.Session], ParameterSetName = 'UsernamePassword')]
	[OutputType([WinSCP.Session], ParameterSetName = 'Credentials')]
	[OutputType([WinSCP.Session])]
	param
	(
		[Parameter(ParameterSetName = 'UsernamePassword',
				   Mandatory = $true)]
		[Parameter(ParameterSetName = 'Credentials',
				   Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[Alias('Host', 'HostName')]
		[string]$RemoteHost,
		[Parameter(ParameterSetName = 'Credentials',
				   Mandatory = $false)]
		[Parameter(ParameterSetName = 'UsernamePassword')]
		[Alias('GiveUpSecurityAndAcceptAnySshHostKey', 'AnySshKey', 'SshCheck', 'AcceptAnySshKey')]
		[switch]$NoSshKeyCheck,
		[Parameter(ParameterSetName = 'Credentials')]
		[Parameter(ParameterSetName = 'UsernamePassword')]
		[Alias('GiveUpSecurityAndAcceptAnyTlsHostCertificate', 'AnyTlsCertificte', 'AcceptAnyCertificate')]
		[switch]$NoTlsCheck,
		[Parameter(ParameterSetName = 'Credentials')]
		[Parameter(ParameterSetName = 'UsernamePassword')]
		[ValidateRange(0, 65535)]
		[Alias('Port', 'RemoteHostPort')]
		[int]$ServerPort = 22,
		[Parameter(ParameterSetName = 'Credentials')]
		[Parameter(ParameterSetName = 'UsernamePassword')]
		[ValidateScript({ Test-Path $_ })]
		[ValidateNotNullOrEmpty()]
		[Alias('SshPrivateKey', 'SshPrivateKeyPath', 'SsheKeyPath')]
		[string]$SshKeyPath = $null,
		[Parameter(ParameterSetName = 'Credentials')]
		[Parameter(ParameterSetName = 'UsernamePassword')]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('Ftp', 'Scp', 'Webdav', 'S3', IgnoreCase = $true)]
		[Alias('ConnectionProtocol')]
		[WinSCP.Protocol]$Protocol,
		[Parameter(ParameterSetName = 'Credentials')]
		[Parameter(ParameterSetName = 'UsernamePassword')]
		[WinSCP.FtpMode]$FtpMode,
		[Parameter(ParameterSetName = 'Credentials')]
		[Parameter(ParameterSetName = 'UsernamePassword')]
		[ValidateNotNullOrEmpty()]
		[Alias('FtpSecureMode', 'SecureFtpMode')]
		[WinSCP.FtpSecure]$FtpSecure,
		[Parameter(ParameterSetName = 'Credentials')]
		[Parameter(ParameterSetName = 'UsernamePassword')]
		[Timespan]$ConnectionTimeOut = (New-TimeSpan -Seconds 15),
		[Parameter(ParameterSetName = 'Credentials')]
		[Parameter(ParameterSetName = 'UsernamePassword')]
		[switch]$WebDavSecure,
		[Parameter(ParameterSetName = 'Credentials')]
		[Parameter(ParameterSetName = 'UsernamePassword')]
		[ValidateNotNullOrEmpty()]
		[Alias('RootPath')]
		[string]$WebDavRoot,
		[Parameter(ParameterSetName = 'UsernamePassword',
				   Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$UserName,
		[Parameter(ParameterSetName = 'UsernamePassword',
				   Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$UserPassword,
		[Parameter(ParameterSetName = 'Credentials')]
		[Parameter(ParameterSetName = 'UsernamePassword')]
		[string[]]$SshHostKeyFingerprint,
		[Parameter(ParameterSetName = 'Credentials',
				   Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[pscredential]$Credentials,
		[Parameter(ParameterSetName = 'Credentials')]
		[Parameter(ParameterSetName = 'UsernamePassword')]
		[string]$SshKeyPassword,
		[Parameter(ParameterSetName = 'Credentials')]
		[Parameter(ParameterSetName = 'UsernamePassword')]
		[ValidateNotNullOrEmpty()]
		[string]$SessionLogPath = $null,
		[Parameter(ParameterSetName = 'Credentials')]
		[Parameter(ParameterSetName = 'UsernamePassword')]
		[ValidateSet('0', '1', '2', IgnoreCase = $true)]
		[int]$DebugLevel = 0,
		[Parameter(ParameterSetName = 'Credentials')]
		[Parameter(ParameterSetName = 'UsernamePassword')]
		[ValidateNotNullOrEmpty()]
		[string]$DebugLogPath,
		[Parameter(ParameterSetName = 'Credentials')]
		[Parameter(ParameterSetName = 'UsernamePassword')]
		[ValidateNotNullOrEmpty()]
		[timespan]$ReconnectTime = 120
	)
	
	# Add assembly
	Add-Type -Path "$PSScriptRoot\lib\WinSCPnet.dll"
	
	# Create Session Options hash
	[hashtable]$sessionOptions = @{ }
	
	# Create Session Object hash
	[hashtable]$sesionObjectParameters = @{ }

	
	# Get parameterset
	switch ($PsCmdlet.ParameterSetName)
	{
		'UsernamePassword'
		{
			# Add paramters to object
			$sessionOptions.Add('UserName', $UserName)
			$sessionOptions.Add('Password', $UserPassword)
			
			break
		}
		
		'Credentials'
		{
			# Extract username and password and add to hash
			$sessionOptions.Add('UserName', $Credentials.UserName)
			$sessionOptions.Add('SecurePassword', $Credentials.Password)
			
			break
		}
	}
	
	# Get cmdlet parameters
	
	foreach ($key in $PSBoundParameters.Keys)
	{
		switch ($key)
		{
			'NoSshKeyCheck'
			{
				# Skip host fingerprint check
				$sessionOptions.Add('GiveUpSecurityAndAcceptAnySshHostKey', $true)
				
				break
			}
			'NoTlsCheck'
			{
				# Skip host TLS check
				$sessionOptions.Add('GiveUpSecurityAndAcceptAnyTlsHostCertificate', $true)
				
				break
			}
			'SshKeyPath'
			{
				#TODO: Private Key can be empty - Handle this
				# Check additional mandatory parameter is present
				if ([string]::IsNullOrEmpty($SshKeyPassword) -eq $true)
				{
					throw 'Parameter -PrivateKeyPassphrase is mandatory with -SshPrivateKeyPath'
					
					return $null
				}
				else
				{
					# Specify SshKeyPath and password
					$sessionOptions.Add('SshPrivateKeyPath', $SshKeyPath)
					$sessionOptions.Add('PrivateKeyPassphrase', $SshKeyPassword)
				}
				
				break
			}
			'SshKeyPassword'
			{
				#TODO:  Implement Secure String version of this parameter
				# Convert SSH password string to clear text
				#[string]$sshPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SshKeyPassword))
				
				# Check additional mandatory parameter is present
				if ([string]::IsNullOrEmpty($SshKeyPath) -eq $true)
				{
					throw 'Parameter -SshKeyPath is mandatory with -SshKeyPassword'
					
					return $null
				}
				else
				{
					# Specify SSH Key passphrase
					$sessionOptions.Add('PrivateKeyPassphrase', $SshKeyPassword)
					$sessionOptions.Add('SshPrivateKeyPath', $SshKeyPath)
				}
				
				break
			}
			'WebDavSecure'
			{
				if (($Protocol -ne 'Webdav') -or
					($Protocol -ne 'S3'))
				{
					Write-Error -Message 'WebDavSecure can only specified with Protocol WebDav or S3'
					
					return $null
				}
				else
				{
					# Add to options hash
					$sessionOptions.Add('WebdavSecure', $true)
				}
				
				break
			}
			'WebDavRoot'
			{
				if (($Protocol -ne 'Webdav') -or
					($Protocol -ne 'S3'))
				{
					Write-Error -Message 'WebDavSecure can only specified with Protocol WebDav or S3'
					
					return $null
				}
				else
				{
					# Add to options hash
					$sessionOptions.Add('WebDavRoot', $true)
				}
				
				break
			}
			'SessionLogPath'
			{
				$sesionObjectParameters.Add('SessionLogPath', $SessionLogPath)
				
				break
			}
			'DebugLogPath'
			{
				$sesionObjectParameters.Add('DebugLogPath', $DebugLogPath)
				
				break
			}
		}
	}
	
	# Add mandatory parameters to Session Options
	$sessionOptions.Add('HostName', $RemoteHost)
	$sessionOptions.Add('PortNumber', $ServerPort)
	$sessionOptions.Add('Timeout', $ConnectionTimeOut)
	
	# Add mandatory paramters to Session Object
	$sesionObjectParameters.Add('ExecutablePath', "$PSScriptRoot\bin\winscp.exe")

	# Create session options object
	$paramNewObject = @{
		TypeName = 'WinSCP.SessionOptions'
		Property = $sessionOptions
	}
	
	[WinSCP.SessionOptions]$scpSessionOptions = New-Object @paramNewObject
	
	# # Create Session Object
	$paramNewObject = @{
		TypeName = 'WinSCP.Session'
		Property = $sesionObjectParameters
	}
	
	[WinSCP.Session]$sessionObject = New-Object @paramNewObject
		
	try
	{
		# Open session
		$sessionObject.Open($scpSessionOptions)
		
		return $sessionObject
	}
	catch
	{
		# Save exception message
		[string]$reportedException = $Error[0].Exception.Message
		
		Write-Error -Message $reportedException
		
		#TODO: Implement -FullOutput Switch to throw full exception 
		
		return $null
	}
}