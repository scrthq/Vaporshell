function Add-VSKinesisAnalyticsV2ApplicationSqlApplicationConfiguration {
    <#
    .SYNOPSIS
        Adds an AWS::KinesisAnalyticsV2::Application.SqlApplicationConfiguration resource property to the template. Describes the inputs, outputs, and reference data sources for an SQL-based Kinesis Data Analytics application.

    .DESCRIPTION
        Adds an AWS::KinesisAnalyticsV2::Application.SqlApplicationConfiguration resource property to the template.
Describes the inputs, outputs, and reference data sources for an SQL-based Kinesis Data Analytics application.

    .LINK
        http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-kinesisanalyticsv2-application-sqlapplicationconfiguration.html

    .PARAMETER Inputs
        The array of Input: https://docs.aws.amazon.com/kinesisanalytics/latest/apiv2/API_Input.html objects describing the input streams used by the application.

        Type: List
        Documentation: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-kinesisanalyticsv2-application-sqlapplicationconfiguration.html#cfn-kinesisanalyticsv2-application-sqlapplicationconfiguration-inputs
        ItemType: Input
        UpdateType: Mutable

    .FUNCTIONALITY
        Vaporshell
    #>
    [OutputType('Vaporshell.Resource.KinesisAnalyticsV2.Application.SqlApplicationConfiguration')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false)]
        [ValidateScript( {
                $allowedTypes = "Vaporshell.Resource.KinesisAnalyticsV2.Application.Input"
                if ([string]$($_.PSTypeNames) -match "($(($allowedTypes|ForEach-Object{[RegEx]::Escape($_)}) -join '|'))") {
                    $true
                }
                else {
                    $PSCmdlet.ThrowTerminatingError((New-VSError -String "This parameter only accepts the following types: $($allowedTypes -join ", "). The current types of the value are: $($_.PSTypeNames -join ", ")."))
                }
            })]
        $Inputs
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
        $obj | Add-ObjectDetail -TypeName 'Vaporshell.Resource.KinesisAnalyticsV2.Application.SqlApplicationConfiguration'
        Write-Verbose "Resulting JSON from $($MyInvocation.MyCommand): `n`n$($obj | ConvertTo-Json -Depth 5)`n"
    }
}
