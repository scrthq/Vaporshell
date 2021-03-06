# Add-VSLambdaEventInvokeConfigDestinationConfig

## SYNOPSIS
Adds an AWS::Lambda::EventInvokeConfig.DestinationConfig resource property to the template.
A configuration object that specifies the destination of an event after Lambda processes it.

## SYNTAX

```
Add-VSLambdaEventInvokeConfigDestinationConfig [[-OnSuccess] <Object>] [[-OnFailure] <Object>]
 [<CommonParameters>]
```

## DESCRIPTION
Adds an AWS::Lambda::EventInvokeConfig.DestinationConfig resource property to the template.
A configuration object that specifies the destination of an event after Lambda processes it.

## PARAMETERS

### -OnSuccess
The destination configuration for successful invocations.

Type: OnSuccess
Documentation: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-lambda-eventinvokeconfig-destinationconfig.html#cfn-lambda-eventinvokeconfig-destinationconfig-onsuccess
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

### -OnFailure
The destination configuration for failed invocations.

Type: OnFailure
Documentation: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-lambda-eventinvokeconfig-destinationconfig.html#cfn-lambda-eventinvokeconfig-destinationconfig-onfailure
UpdateType: Mutable

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Vaporshell.Resource.Lambda.EventInvokeConfig.DestinationConfig
## NOTES

## RELATED LINKS

[http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-lambda-eventinvokeconfig-destinationconfig.html](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-lambda-eventinvokeconfig-destinationconfig.html)

