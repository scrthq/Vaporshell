function Add-VSSESTemplateTemplate {
    <#
    .SYNOPSIS
        Adds an AWS::SES::Template.Template resource property to the template. The content of the email, composed of a subject line, an HTML part, and a text-only part.

    .DESCRIPTION
        Adds an AWS::SES::Template.Template resource property to the template.
The content of the email, composed of a subject line, an HTML part, and a text-only part.

    .LINK
        http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ses-template-template.html

    .PARAMETER HtmlPart
        The HTML body of the email.

        Documentation: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ses-template-template.html#cfn-ses-template-template-htmlpart
        PrimitiveType: String
        UpdateType: Mutable

    .PARAMETER TextPart
        The email body that is visible to recipients whose email clients don't display HTML content.

        Documentation: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ses-template-template.html#cfn-ses-template-template-textpart
        PrimitiveType: String
        UpdateType: Mutable

    .PARAMETER TemplateName
        The name of the template. You specify this name when you send email using the SendTemplatedEmail or SendBulkTemplatedEmail operations.

        Documentation: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ses-template-template.html#cfn-ses-template-template-templatename
        PrimitiveType: String
        UpdateType: Immutable

    .PARAMETER SubjectPart
        The subject line of the email.

        Documentation: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ses-template-template.html#cfn-ses-template-template-subjectpart
        PrimitiveType: String
        UpdateType: Mutable

    .FUNCTIONALITY
        Vaporshell
    #>
    [OutputType('Vaporshell.Resource.SES.Template.Template')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false)]
        [ValidateScript( {
                $allowedTypes = "System.String","Vaporshell.Function","Vaporshell.Condition"
                if ([string]$($_.PSTypeNames) -match "($(($allowedTypes|ForEach-Object{[RegEx]::Escape($_)}) -join '|'))") {
                    $true
                }
                else {
                    $PSCmdlet.ThrowTerminatingError((New-VSError -String "This parameter only accepts the following types: $($allowedTypes -join ", "). The current types of the value are: $($_.PSTypeNames -join ", ")."))
                }
            })]
        $HtmlPart,
        [parameter(Mandatory = $false)]
        [ValidateScript( {
                $allowedTypes = "System.String","Vaporshell.Function","Vaporshell.Condition"
                if ([string]$($_.PSTypeNames) -match "($(($allowedTypes|ForEach-Object{[RegEx]::Escape($_)}) -join '|'))") {
                    $true
                }
                else {
                    $PSCmdlet.ThrowTerminatingError((New-VSError -String "This parameter only accepts the following types: $($allowedTypes -join ", "). The current types of the value are: $($_.PSTypeNames -join ", ")."))
                }
            })]
        $TextPart,
        [parameter(Mandatory = $false)]
        [ValidateScript( {
                $allowedTypes = "System.String","Vaporshell.Function","Vaporshell.Condition"
                if ([string]$($_.PSTypeNames) -match "($(($allowedTypes|ForEach-Object{[RegEx]::Escape($_)}) -join '|'))") {
                    $true
                }
                else {
                    $PSCmdlet.ThrowTerminatingError((New-VSError -String "This parameter only accepts the following types: $($allowedTypes -join ", "). The current types of the value are: $($_.PSTypeNames -join ", ")."))
                }
            })]
        $TemplateName,
        [parameter(Mandatory = $false)]
        [ValidateScript( {
                $allowedTypes = "System.String","Vaporshell.Function","Vaporshell.Condition"
                if ([string]$($_.PSTypeNames) -match "($(($allowedTypes|ForEach-Object{[RegEx]::Escape($_)}) -join '|'))") {
                    $true
                }
                else {
                    $PSCmdlet.ThrowTerminatingError((New-VSError -String "This parameter only accepts the following types: $($allowedTypes -join ", "). The current types of the value are: $($_.PSTypeNames -join ", ")."))
                }
            })]
        $SubjectPart
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
        $obj | Add-ObjectDetail -TypeName 'Vaporshell.Resource.SES.Template.Template'
        Write-Verbose "Resulting JSON from $($MyInvocation.MyCommand): `n`n$($obj | ConvertTo-Json -Depth 5)`n"
    }
}
