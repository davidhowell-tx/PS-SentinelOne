function Format-S1DvEvent {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline)]
        $InputObject
    )
    Begin {
        $BaseProperties = @(
            "eventTime", "eventType", "objectType", "storyline",
            "endpointName", "endpointOs", "endpointMachineType", "agentUuid",
            "srcProcName", "srcProcDisplayName", "srcProcUser", "srcProcPid", "srcProcImagePath", "srcProcCmdLine", "srcProcIntegrityLevel", "srcProcImageMd5", "srcProcImageSha1", "srcProcImageSha256", "srcProcStartTime", "srcProcPublisher",
            "srcProcParentName", "srcProcParentImagePath", "srcProcParentPid", "srcProcParentImageMd5", "srcProcParentImageSha1", "srcProcParentImageSha256", "srcProcParentStartTime"
        )
        $CommandScriptProperties = @("processCmd")
        $IpProperties = @( "netConnStatus", "netEventDirection", "srcIp", "srcPort", "dstIp", "dstPort", "netConnInCount", "netConnOutCount" )
        $DnsProperties = @( "dnsRequest", "dnsResponse" )
        $FileProperties = @( "tgtFilePath", "tgtFileLocation", "tgtFileMd5", "tgtFileSha1", "tgtFileSha256", "tgtFileCreatedAt", "tgtFileModifiedAt", "tgtFileOldMd5", "tgtFileOldPath", "tgtFileOldSha1", "tgtFileOldSha256", "newFileName" )
        $ScheduledTaskProperties = @( "taskName", "taskPath" )
        $IndicatorProperties = @( "indicatorName", "indicatorCategory", "indicatorMetadata", "indicatorDescription" )
        $ProcessProperties = @( "tgtPid", "tgtProcCmdLine", "tgtProcDisplayName", "tgtProcImageMd5", "tgtProcImagePath", "tgtProcImageSha1", "tgtProcImageSha256", "tgtProcIntegrityLevel", "tgtProcName", "tgtProcPublisher", "tgtProcSignedStatus", "tgtProcStartTime", "tgtProcStorylineId", "tgtProcUser", "tgtProcVerifiedStatus" )
        $RegistryProperties = @( "registryPath", "registryKeyPath", "registryValueType", "registryValue", "registryOldValueType", "registryOldValue" )
    }
    Process {
        switch ($InputObject.objectType) {
            "command_script" {
                $InputObject | Select-Object -Property ($BaseProperties + $CommandScriptProperties)
            }
            "ip" {
                $InputObject | Select-Object -Property ($BaseProperties + $IpProperties)
            }
            "dns" {
                $InputObject | Select-Object -Property ($BaseProperties + $DnsProperties)
            }
            "file" {
                $InputObject | Select-Object -Property ($BaseProperties + $FileProperties)
            }
            "scheduled_task" {
                $InputObject | Select-Object -Property ($BaseProperties + $ScheduledTaskProperties)
            }
            "indicators" {
                $InputObject | Select-Object -Property ($BaseProperties + $IndicatorProperties)
            }
            "process" {
                $InputObject | Select-Object -Property ($BaseProperties + $ProcessProperties)
            }
            "registry" {
                $InputObject | Select-Object -Property ($BaseProperties + $RegistryProperties)
            }
        }
    }
}