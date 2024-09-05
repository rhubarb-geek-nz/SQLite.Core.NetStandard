#!/usr/bin/env pwsh
#
#  Copyright 2023, Roger Brown
#
#  This file is part of rhubarb-geek-nz/SQLite.Core.NetStandard.
#
#  This program is free software: you can redistribute it and/or modify it
#  under the terms of the GNU General Public License as published by the
#  Free Software Foundation, either version 3 of the License, or (at your
#  option) any later version.
# 
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>
#

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$LinuxVersion = 'debian.11'
$AlpineVersion = 'alpine.3.19'
$OSXVersion = 'osx.11'

trap
{
	throw $PSItem
}

$xmlDoc = [System.Xml.XmlDocument](Get-Content 'SQLite.Core.NetStandard.nuspec')

$nsMgr = New-Object -TypeName System.Xml.XmlNamespaceManager -ArgumentList $xmlDoc.NameTable

$nsmgr.AddNamespace('ns', 'http://schemas.microsoft.com/packaging/2012/06/nuspec.xsd')

$Version = $xmlDoc.SelectSingleNode("/ns:package/ns:metadata/ns:version", $nsmgr).InnerText

$PackageId = $xmlDoc.SelectSingleNode("/ns:package/ns:metadata/ns:id", $nsmgr).InnerText

$VersionTriplets = ( $Version.Split('.')[0..2] | Join-String -Separator '.' ) 

Write-Host "Version = $Version, VersionTriplets = $VersionTriplets"

$PackageFile = "$PackageId.$VersionTriplets.nupkg"

$DataDir="$(PWD)/data"

$ZipDir="$(PWD)/zips"

if ( Test-Path $DataDir )
{
	Remove-Item $DataDir -Recurse
}

if ( Test-Path $PackageFile )
{
	Remove-Item $PackageFile
}

if ( -not ( Test-Path $ZipDir ) )
{
	$null = New-Item $ZipDir -ItemType 'directory'
}

foreach ($ZipSpec in @(
		@( "https://system.data.sqlite.org/blobs/$Version/sqlite-netStandard20-binary-$Version.zip", "$DataDir/lib/netstandard2.0" ),
		@( "https://system.data.sqlite.org/blobs/$Version/sqlite-netStandard21-binary-$Version.zip", "$DataDir/lib/netstandard2.1" ),
		@( "https://github.com/rhubarb-geek-nz/SQLite.Interop/releases/download/$Version/SQLite.Interop-$Version-$LinuxVersion.zip", "$DataDir" ),
		@( "https://github.com/rhubarb-geek-nz/SQLite.Interop/releases/download/$Version/SQLite.Interop-$Version-$AlpineVersion.zip", "$DataDir" ),
		@( "https://github.com/rhubarb-geek-nz/SQLite.Interop/releases/download/$Version-bionic/SQLite.Interop-$Version-linux-bionic.zip", "$DataDir" ),
		@( "https://github.com/rhubarb-geek-nz/SQLite.Interop/releases/download/$Version-freebsd/SQLite.Interop-$Version-freebsd.zip", "$DataDir" ),
		@( "https://github.com/rhubarb-geek-nz/SQLite.Interop/releases/download/$Version/SQLite.Interop-$Version-$OSXVersion.zip", "$DataDir" ),
		@( "https://github.com/rhubarb-geek-nz/SQLite.Interop-win/releases/download/$Version/SQLite.Interop-$Version-win.zip", "$DataDir" )
))
{
	$ZipURL=$ZipSpec[0]
	$ZipDest=$ZipSpec[1]
	$ZipName=$ZipURL.Split('/')[-1]

	Write-Host $ZipURL '->' $ZipName '->' $ZipDest

	if ( -not ( Test-Path "$ZipDir/$ZipName" ))
	{
		Invoke-WebRequest -Uri $ZipURL -OutFile "$ZipDir/$ZipName"
	}

	Expand-Archive -Path "$ZipDir/$ZipName" -DestinationPath $ZipDest
}

foreach ($NetStandard in "$DataDir/lib/netstandard2.0", "$DataDir/lib/netstandard2.1")
{
	$List = ( Get-ChildItem $NetStandard | ForEach-Object {
		if ( 'System.Data.SQLite.dll' -ne ( Split-Path $_ -Leaf ) ) {
			$_
		}
	})

	foreach ($File in $List)
	{
		Remove-Item $File
	}
}

foreach ($SrcDest in @(
	@($LinuxVersion,'linux'),
	@($AlpineVersion,'linux-musl'),
	@($OSXVersion,'osx')
))
{
	$Src=$SrcDest[0]
	$Dest=$SrcDest[1]

	Write-Host $Src '->' $Dest

	foreach ($Arch in 'arm', 'arm64', 'x64')
	{
		if ( Test-Path "$DataDir/runtimes/$Src-$Arch" )
		{
			Rename-Item "$DataDir/runtimes/$Src-$Arch" "$DataDir/runtimes/$Dest-$Arch"
		}
	}
}

& nuget pack SQLite.Core.NetStandard.nuspec -BasePath $DataDir

If ( $LastExitCode -ne 0 )
{
	Exit $LastExitCode
}
