﻿# Generated by: Sean McNellis (seanmcn)
#
# Copyright © Microsoft Corporation.  All Rights Reserved.
# This code released under the terms of the 
# Microsoft Public License (MS-PL, http://opensource.org/licenses/ms-pl.html.)
# Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment. 
# THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, 
# INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE. 
# We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code, provided that. 
# You agree: 
# (i) to not use Our name, logo, or trademarks to market Your software product in which the Sample Code is embedded; 
# (ii) to include a valid copyright notice on Your software product in which the Sample Code is embedded; 
# and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, including attorneys’ fees, that arise or result from the use or distribution of the Sample Code 

# Script parameters #
$connectionsSourceCsvPath = ".\connectionsSource.csv"
# Script parameters #

$conns = New-Object System.Collections.ArrayList

Write-Output "Loading Connections Source CSV File"
$connectionsSource = Import-Csv -Path $connectionsSourceCsvPath

foreach($connectionSource in $connectionsSource)
{
    Write-Output "Creating Credentail"
    $user = $connectionSource.User
    $password = ConvertTo-SecureString -String $connectionSource.Password -AsPlainText -Force

    $cred = New-Object System.Management.Automation.PSCredential ($user,$password) 
    
    Write-Output "Connecting to CRM organization"
    try
    {
        if($connectionSource.Type -eq "Online")
        {
            $conn = Get-CrmConnection -Credential $cred -OnLineType Office365 -DeploymentRegion $connectionSource.DeploymentRegion -OrganizationName $connectionSource.OrganizationName -ErrorAction Stop
        }
        else
        {
            $conn = Get-CrmConnection -Credential $cred -OrganizationName $connectionSource.OrganizationName -ServerUrl $connectionSource.ServerUrl -ErrorAction Stop
        }
    }
    catch
    {
        throw
    }
    $conns.Add($conn)
}

# Do any operation as you need.
# In this sample, adds an Account record for all organizations
foreach($conn in $conns)
{
    Write-Output "Adding an Account record to CRM organization"
    New-CrmRecord -conn $conn -EntityLogicalName account -Fields @{"name"="Sample Account"}
}

Write-Output "Completed"