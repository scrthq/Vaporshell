function Add-VSAppMeshVirtualNodeServiceDiscovery {
    <#
    .SYNOPSIS
        Adds an AWS::AppMesh::VirtualNode.ServiceDiscovery resource property to the template. An object that represents the service discovery information for a virtual node.

    .DESCRIPTION
        Adds an AWS::AppMesh::VirtualNode.ServiceDiscovery resource property to the template.
An object that represents the service discovery information for a virtual node.

    .LINK
        http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-appmesh-virtualnode-servicediscovery.html

    .PARAMETER DNS
        Specifies the DNS information for the virtual node.

        Type: DnsServiceDiscovery
        Documentation: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-appmesh-virtualnode-servicediscovery.html#cfn-appmesh-virtualnode-servicediscovery-dns
        UpdateType: Mutable

    .PARAMETER AWSCloudMap
        Specifies any AWS Cloud Map information for the virtual node.

        Type: AwsCloudMapServiceDiscovery
        Documentation: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-appmesh-virtualnode-servicediscovery.html#cfn-appmesh-virtualnode-servicediscovery-awscloudmap
        UpdateType: Mutable

    .FUNCTIONALITY
        Vaporshell
    #>
    [OutputType('Vaporshell.Resource.AppMesh.VirtualNode.ServiceDiscovery')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false)]
        $DNS,
        [parameter(Mandatory = $false)]
        $AWSCloudMap
    )
    Begin {
        $obj = [PSCustomObject]@{}
        $commonParams = @('Verbose','Debug','ErrorAction','WarningAction','InformationAction','ErrorVariable','WarningVariable','InformationVariable','OutVariable','OutBuffer','PipelineVariable')
    }
    Process {
        foreach ($key in $PSBoundParameters.Keys | Where-Object {$commonParams -notcontains $_}) {
            switch ($key) {
                Default {
                    $obj | Add-Member -MemberType NoteProperty -Name $key -Value $PSBoundParameters.$key
                }
            }
        }
    }
    End {
        $obj | Add-ObjectDetail -TypeName 'Vaporshell.Resource.AppMesh.VirtualNode.ServiceDiscovery'
        Write-Verbose "Resulting JSON from $($MyInvocation.MyCommand): `n`n$($obj | ConvertTo-Json -Depth 5)`n"
    }
}
