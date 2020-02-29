function Add-VSMediaLiveChannelVideoSelectorSettings {
    <#
    .SYNOPSIS
        Adds an AWS::MediaLive::Channel.VideoSelectorSettings resource property to the template. Information about the video to extract from the input.

    .DESCRIPTION
        Adds an AWS::MediaLive::Channel.VideoSelectorSettings resource property to the template.
Information about the video to extract from the input.

The parent of this entity is VideoSelector.

    .LINK
        http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-medialive-channel-videoselectorsettings.html

    .PARAMETER VideoSelectorProgramId
        Used to extract video by program ID.

        Type: VideoSelectorProgramId
        Documentation: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-medialive-channel-videoselectorsettings.html#cfn-medialive-channel-videoselectorsettings-videoselectorprogramid
        UpdateType: Mutable

    .PARAMETER VideoSelectorPid
        Used to extract video by PID.

        Type: VideoSelectorPid
        Documentation: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-medialive-channel-videoselectorsettings.html#cfn-medialive-channel-videoselectorsettings-videoselectorpid
        UpdateType: Mutable

    .FUNCTIONALITY
        Vaporshell
    #>
    [OutputType('Vaporshell.Resource.MediaLive.Channel.VideoSelectorSettings')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false)]
        $VideoSelectorProgramId,
        [parameter(Mandatory = $false)]
        $VideoSelectorPid
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
        $obj | Add-ObjectDetail -TypeName 'Vaporshell.Resource.MediaLive.Channel.VideoSelectorSettings'
        Write-Verbose "Resulting JSON from $($MyInvocation.MyCommand): `n`n$($obj | ConvertTo-Json -Depth 5)`n"
    }
}
