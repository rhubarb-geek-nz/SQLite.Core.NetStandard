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

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"
$Framework = 'net8.0'

trap
{
	throw $PSItem
}

foreach ($Name in "bin", "obj") {
	if (Test-Path "$Name") {
		Remove-Item "$Name" -Force -Recurse
	} 
}

& dotnet build "test.csproj" --configuration Release

If ( $LastExitCode -ne 0 )
{
	Exit $LastExitCode
}

If (-not(Test-Path "test.db"))
{
@"
CREATE TABLE MESSAGES (
	CONTENT VARCHAR(256)
);

INSERT INTO MESSAGES (CONTENT) VALUES ('Hello World');

SELECT * FROM MESSAGES;
"@ | & sqlite3 test.db

	If ( $LastExitCode -ne 0 )
	{
		Exit $LastExitCode
	}
}

& dotnet "bin/Release/$Framework/test.dll"

If ( $LastExitCode -ne 0 )
{
	Exit $LastExitCode
}

Write-Host "Tests complete"
