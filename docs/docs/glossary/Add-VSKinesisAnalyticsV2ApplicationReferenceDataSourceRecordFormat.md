# Add-VSKinesisAnalyticsV2ApplicationReferenceDataSourceRecordFormat

## SYNOPSIS
Adds an AWS::KinesisAnalyticsV2::ApplicationReferenceDataSource.RecordFormat resource property to the template.
For an SQL-based Amazon Kinesis Data Analytics application, describes the record format and relevant mapping information that should be applied to schematize the records on the stream.

## SYNTAX

```
Add-VSKinesisAnalyticsV2ApplicationReferenceDataSourceRecordFormat [[-MappingParameters] <Object>]
 [-RecordFormatType] <Object> [<CommonParameters>]
```

## DESCRIPTION
Adds an AWS::KinesisAnalyticsV2::ApplicationReferenceDataSource.RecordFormat resource property to the template.
For an SQL-based Amazon Kinesis Data Analytics application, describes the record format and relevant mapping information that should be applied to schematize the records on the stream.

## PARAMETERS

### -MappingParameters
When you configure application input at the time of creating or updating an application, provides additional mapping information specific to the record format such as JSON, CSV, or record fields delimited by some delimiter on the streaming source.

Type: MappingParameters
Documentation: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-kinesisanalyticsv2-applicationreferencedatasource-recordformat.html#cfn-kinesisanalyticsv2-applicationreferencedatasource-recordformat-mappingparameters
UpdateType: Mutable

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RecordFormatType
The type of record format.

Documentation: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-kinesisanalyticsv2-applicationreferencedatasource-recordformat.html#cfn-kinesisanalyticsv2-applicationreferencedatasource-recordformat-recordformattype
PrimitiveType: String
UpdateType: Mutable

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Vaporshell.Resource.KinesisAnalyticsV2.ApplicationReferenceDataSource.RecordFormat
## NOTES

## RELATED LINKS

[http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-kinesisanalyticsv2-applicationreferencedatasource-recordformat.html](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-kinesisanalyticsv2-applicationreferencedatasource-recordformat.html)

