Import-Module Nameit, Vaporshell
$BuildRoot = $PSScriptRoot

# Assume this was created in a different step
$BucketName = 'Foobar'
$BucketRegion = 'eu-west-1'
$ExportPath =  Join-Path $BuildRoot 'cloudformation'
New-Item -Path $ExportPath -ItemType Directory -Force | Out-Null
$template = Initialize-Vaporshell -Description 'Resource datasync for SSM'

$AWSProfilesList = @('my-cred-name')
foreach ($AWSProfileName in $AWSProfilesList)
{
    Set-VSCredential -ProfileName $AWSProfileName
    $ProfileExportPath =  Join-Path $ExportPath $AWSProfileName
    New-Item -Path $ProfileExportPath -ItemType Directory -Force | Out-Null

    $IncludeRegions = @(
        # 'eu-central-1',
        'eu-west-1'
        # 'eu-west-2',
        # 'eu-west-3',
        # 'us-east-1',
        # 'us-east-2',
        # 'us-west-1',
        # 'us-west-2'
    )
    foreach ($region in $IncludeRegions)
    {
        $ExportTemplate = Join-Path $ProfileExportPath "datasync-$region.yml"
        $StackName = "ssm-resource-data-sync-$region"
        $SplatArgs = @{
            LogicalId     = 'ssmesourcedatasync'
            SyncName      = $StackName
            S3Destination = @{
                BucketRegion = $BucketRegion
                BucketName   = $BucketName
                SyncFormat   = 'JsonSerDe'
            }
            SyncType      = 'SyncToDestination'
        }
        $template.AddResource(
            (New-VSSSMResourceDataSync @SplatArgs)
        )
        Export-Vaporshell -Path $ExportTemplate -VaporshellTemplate $template -Force -ValidateTemplate -As YAML
        vsl -action vaporize --tf $ExportTemplate --sn $StackName --caps iam --v --f --w
        Watch-Stack $stackName
    }
}
