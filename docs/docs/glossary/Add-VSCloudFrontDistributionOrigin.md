# Add-VSCloudFrontDistributionOrigin

## SYNOPSIS
Adds an AWS::CloudFront::Distribution.Origin resource property to the template.
A complex type that describes the Amazon S3 bucket, HTTP server (for example, a web server, Amazon MediaStore, or other server from which CloudFront gets your files.
This can also be an origin group, if you've created an origin group.
You must specify at least one origin or origin group.

## SYNTAX

```
Add-VSCloudFrontDistributionOrigin [[-OriginCustomHeaders] <Object>] [-DomainName] <Object>
 [[-S3OriginConfig] <Object>] [[-OriginPath] <Object>] [-Id] <Object> [[-CustomOriginConfig] <Object>]
 [<CommonParameters>]
```

## DESCRIPTION
Adds an AWS::CloudFront::Distribution.Origin resource property to the template.
A complex type that describes the Amazon S3 bucket, HTTP server (for example, a web server, Amazon MediaStore, or other server from which CloudFront gets your files.
This can also be an origin group, if you've created an origin group.
You must specify at least one origin or origin group.

For the current quota (limit on the number of origins or origin groups that you can specify for a distribution, see Quotas: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cloudfront-limits.html in the *Amazon CloudFront Developer Guide*.

**Note**

If you use CloudFormation to create a CloudFront distribution and an S3 bucket origin at the same time, the distribution might return HTTP 307 Temporary Redirect responses for up to 24 hours.
It can take up to 24 hours for the S3 bucket name to propagate to all AWS Regions.
When the propagation is complete, the CloudFront distribution will automatically stop sending these redirect responses; you don't need to take any action.
For more information, see Why am I getting an HTTP 307 Temporary Redirect response from Amazon S3?: http://aws.amazon.com/premiumsupport/knowledge-center/s3-http-307-response/ and Temporary Request Redirection: https://docs.aws.amazon.com/AmazonS3/latest/dev/Redirects.html#TemporaryRedirection.

## PARAMETERS

### -OriginCustomHeaders
A complex type that contains names and values for the custom headers that you want.

Type: List
Documentation: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-distribution-origin.html#cfn-cloudfront-distribution-origin-origincustomheaders
ItemType: OriginCustomHeader
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

### -DomainName
**Amazon S3 origins**: The DNS name of the Amazon S3 bucket from which you want CloudFront to get objects for this origin, for example, my-aws-bucket.s3.amazonaws.com.
For S3 buckets configured as a static website, use CustomOriginConfig instead.
For more information about specifying this value for different types of origins, see Origin Domain Name: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-web-values-specify.html#DownloadDistValuesDomainName in the *Amazon CloudFront Developer Guide*.
Constraints for Amazon S3 origins:
+ If you configured Amazon S3 Transfer Acceleration for your bucket, don't specify the s3-accelerate endpoint for DomainName.
+ If you configured your bucket as a static website, use CustomOriginConfig instead.
+ The bucket name must be between 3 and 63 characters long inclusive.
+ The bucket name must contain only lowercase characters, numbers, periods, underscores, and dashes.
+ The bucket name must not contain adjacent periods.
**Custom Origins**: The DNS domain name for the HTTP server from which you want CloudFront to get objects for this origin, for example, www.example.com.
Constraints for custom origins:
+  DomainName must be a valid DNS name that contains only a-z, A-Z, 0-9, dot ., hyphen -, or underscore _ characters.
+ The name cannot exceed 128 characters.

Documentation: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-distribution-origin.html#cfn-cloudfront-distribution-origin-domainname
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

### -S3OriginConfig
A complex type that contains information about the Amazon S3 origin.
If the origin is a custom origin or an S3 bucket that is configured as a website endpoint, use the CustomOriginConfig element instead.

Type: S3OriginConfig
Documentation: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-distribution-origin.html#cfn-cloudfront-distribution-origin-s3originconfig
UpdateType: Mutable

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OriginPath
An optional element that causes CloudFront to request your content from a directory in your Amazon S3 bucket or your custom origin.
When you include the OriginPath element, specify the directory name, beginning with a /.
CloudFront appends the directory name to the value of DomainName, for example, example.com/production.
Do not include a / at the end of the directory name.
For example, suppose you've specified the following values for your distribution:
+  DomainName: An Amazon S3 bucket named myawsbucket.
+  OriginPath: /production
+  CNAME: example.com
When a user enters example.com/index.html in a browser, CloudFront sends a request to Amazon S3 for myawsbucket/production/index.html.
When a user enters example.com/acme/index.html in a browser, CloudFront sends a request to Amazon S3 for myawsbucket/production/acme/index.html.

Documentation: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-distribution-origin.html#cfn-cloudfront-distribution-origin-originpath
PrimitiveType: String
UpdateType: Mutable

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
A unique identifier for the origin or origin group.
The value of Id must be unique within the distribution.
When you specify the value of TargetOriginId for the default cache behavior or for another cache behavior, you indicate the origin to which you want the cache behavior to route requests by specifying the value of the Id element for that origin.
When a request matches the path pattern for that cache behavior, CloudFront routes the request to the specified origin.
For more information, see Cache Behavior Settings: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-web-values-specify.html#DownloadDistValuesCacheBehavior in the *Amazon CloudFront Developer Guide*.

Documentation: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-distribution-origin.html#cfn-cloudfront-distribution-origin-id
PrimitiveType: String
UpdateType: Mutable

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomOriginConfig
A complex type that contains information about a custom origin or an Amazon S3 bucket that is configured as a static website.
If the origin is an Amazon S3 bucket that is *not* configured as a static website, use the S3OriginConfig element instead.

Type: CustomOriginConfig
Documentation: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-distribution-origin.html#cfn-cloudfront-distribution-origin-customoriginconfig
UpdateType: Mutable

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Vaporshell.Resource.CloudFront.Distribution.Origin
## NOTES

## RELATED LINKS

[http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-distribution-origin.html](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-distribution-origin.html)

