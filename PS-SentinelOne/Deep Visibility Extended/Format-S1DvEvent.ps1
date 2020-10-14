function Format-S1DvEvent {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline)]
        $InputObject
    )
    Begin {
    $NetworkProperties = @(
        "eventTime", "eventType", "netConnStatus", "netEventDirection", "srcIp", "srcPort", "dstIp", "dstPort", "netConnInCount", "netConnOutCount",
        "endpointName", "endpointOs", "endpointMachineType",
        "srcProcName", "srcProcDisplayName", "srcProcUser", "srcProcPid", "srcProcImagePath", "srcProcCmdLine", "srcProcIntegrityLevel", "srcProcImageMd5", "srcProcImageSha1", "srcProcImageSha256", "srcProcStartTime", "srcProcPublisher",
        "srcProcParentName", "srcProcParentImagePath", "srcProcParentPid", "srcProcParentImageMd5", "srcProcParentImageSha1", "srcProcParentImageSha256", "srcProcParentStartTime"
    )
    $DNSProperties = @(
        "eventTime", "eventType", "dnsRequest", "dnsResponse",
        "endpointName", "endpointOs", "endpointMachineType",
        "srcProcName", "srcProcDisplayName", "srcProcUser", "srcProcPid", "srcProcImagePath", "srcProcCmdLine", "srcProcIntegrityLevel", "srcProcImageMd5", "srcProcImageSha1", "srcProcImageSha256", "srcProcStartTime", "srcProcPublisher",
        "srcProcParentName", "srcProcParentImagePath", "srcProcParentPid", "srcProcParentImageMd5", "srcProcParentImageSha1", "srcProcParentImageSha256", "srcProcParentStartTime"
    )
    }
    Process {
        switch ($InputObject.objectType) {
            "ip" {
                $InputObject | Select-Object -Property $NetworkProperties
            }
            "dns" {
                $InputObject | Select-Object -Property $DNSProperties
            }
        }
    }
}