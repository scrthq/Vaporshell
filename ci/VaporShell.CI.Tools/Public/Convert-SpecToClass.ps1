function Convert-SpecToClass {
    [cmdletbinding()]
    Param (
        [parameter(Mandatory = $true, Position = 0)]
        [object]
        $Resource,
        [parameter(Mandatory = $true, Position = 1)]
        [ValidateSet("Resource", "Property")]
        [string]
        $ResourceType,
        [parameter()]
        [int]
        $Number = 0,
        [parameter()]
        [string[]]
        $DuplicateClassNames = @(),
        [parameter()]
        [object]
        $HelpDoc
    )
    $bareResource = $Resource.Resource
    $Name = $bareResource.Name
    $Link = $bareResource.Value.Documentation
    $Properties = $bareResource.Value.Properties.PSObject.Properties
    $ShortName = $Name.Replace("AWS::", "")
    $ServiceName = $ShortName.Split('::')[0]
    if ($ServiceName -eq 'Serverless') {
        $ServiceName = 'SAM'
        $ShortName = $ShortName -replace '^Serverless', 'SAM'
    }
    $ServiceModuleName = "VaporShell.$ServiceName"
    $repoRoot = Resolve-Path ([System.IO.Path]::Combine($PSScriptRoot, '..', '..', '..'))
    $ModPath = [System.IO.Path]::Combine($repoRoot, 'BuildOutput', '_autoGenerated', $ServiceModuleName)
    $basePath = "$($ModPath)\Classes"
    $noDepsTypes = @('Boolean', 'Double', 'Integer', 'Json', 'Long', 'String', 'Timestamp')
    $commonParams = @('Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction', 'ErrorVariable', 'WarningVariable', 'InformationVariable', 'OutVariable', 'OutBuffer', 'PipelineVariable')
    switch ($ResourceType) {
        Property {
            $Dir = "$basePath\00 - Property Types"
            $ClassBase = 'VSResourceProperty'
            $ClassName = $ShortName -replace '\W'
            if ($ClassName -in $DuplicateClassNames -or $ClassName -in $commonParams) {
                $ClassName = $ClassName + 'Property'
            }
            if ($HelpDoc) {
                $Synopsis = "Adds an '$Name' resource property to a '$($ShortName -replace '\..*' -replace '\W')' resource. $($HelpDoc.Synopsis)"
                $Description = "Adds an '$Name' resource property to a '$($ShortName -replace '\..*' -replace '\W')' resource.`n$($HelpDoc.Description)"
            }
        }
        Resource {
            $Dir = "$basePath\10 - Resource Types"
            $ClassBase = 'VSResource'
            $ClassName = $ShortName -replace '\..*' -replace '\W'
            if ($HelpDoc) {
                $Synopsis = "Adds an $Name resource to the template. $($HelpDoc.Synopsis)"
                $Description = "Adds an $Name resource to the template. $($HelpDoc.Description)"
            }
        }
    }
    if (-not (Test-Path $Dir)) {
        $null = New-Item $Dir -ItemType Directory -Force
    }
    $PS1Path = "$Dir\$('{0:0000}' -f $Number) - $ClassName.ps1"
    Write-BuildLog "[$ServiceModuleName] Generating $ResourceType class: $ClassName"
    $scriptContents = @(
        'using namespace System'
        'using namespace System.Collections'
        'using namespace System.Collections.Generic'
        'using namespace System.IO'
        'using namespace System.Management.Automation'
        ''
        #"Write-Verbose `"Importing class '$ClassName'`""
        "class $ClassName : $ClassBase {"
    )
    $prprtyContents = @()
    $hiddenContents = @()
    $functionVerb = switch ($ResourceType) {
        Resource {
            'New'
        }
        Property {
            'Add'
        }
    }
    $hiddenContents += "    hidden [string] `$_vsFunctionName = '$($functionVerb)-VS$($ShortName -replace '\W')'"
    if ($Resource.Documentation) {
        $hiddenContents += "    hidden [string] `$_awsDocumentation = '$($Resource.Documentation)'"
    }
    $hiddenContents += '' # Add a gap between the default hidden properties for _vsFunctionName and _awsDocumentation for cleanliness
    if ($ResourceType -eq 'Resource') {
        $prprtyContents += "    [string] `$Type = '$Name'"
        if ($null -ne $Resource.Attributes) {
            $hiddenContents += "    hidden [string[]] `$_attributes = @('$($Resource.Attributes.PSObject.Properties.Name -join "','")')"
        }
    }
    $methodContents = @()
    $accessorContents = @(
        '    hidden [void] _addAccessors() {'
    )
    if ($ResourceType -eq 'Resource') {
        $accessorContents += '        $this._addBaseAccessors()'
    }
    $PCount = 0
    $Properties | ForEach-Object { $PCount++ }
    $i = 0
    foreach ($Prop in $Properties) {
        $i++
        $ParamName = "$($Prop.Name)"
        $_paramName = '_' + "$($Prop.Name)".SubString(0, 1).ToLower() + "$($Prop.Name)".SubString(1)
        if ($ParamName -eq 'Type' -and $ResourceType -eq 'Resource') {
            $ParamName = (($ShortName -split '::')[-1] -replace '\W') + 'Type'
            $_paramName = '_' + "$ParamName".SubString(0, 1).ToLower() + "$ParamName".SubString(1)
        }
        if ($Prop.Value.PrimitiveItemType -in @('Boolean', 'Integer', 'Json', 'String')) {
            $propType = switch ($Prop.Value.PrimitiveItemType) {
                Boolean {
                    'bool'
                }
                Integer {
                    'int'
                }
                Json {
                    'VSJson'
                }
                String {
                    'string'
                }
            }
            $ValType = "[$propType"
            $setterType = 'object'
            if ($Prop.Value.Type -eq 'List') {
                $valueString = '@($value)'
                $ValType += "[]"
                $setterType += '[]'
            }
            else {
                $valueString = '$value'
            }
            $ValType += "]"
            $prprtyContents += "    $ValType `$$ParamName"
            $setterParams = if ($propType -eq 'string') {
                "param([ValidateType(([$propType], [int], [IntrinsicFunction], [ConditionFunction]))] [$setterType] `$value)"
            }
            else {
                "param([ValidateType(([$propType], [string], [IntrinsicFunction], [ConditionFunction]))] [$setterType] `$value)"

            }
            if ($ResourceType -eq 'Resource') {
                $getter = "`$this.Properties['$ParamName']"
                if ($propType -eq 'int') {
                    $setter = @(
                        "`$this.Properties['$ParamName'] = if (`$cast = $valueString -as [int]) {"
                        '    $cast'
                        '}'
                        'else{'
                        "    $valueString"
                        '}'
                    ) -join "`n$(' ' * 12)"
                }
                else {
                    $setter = "`$this.Properties['$ParamName'] = $valueString"
                }
            }
            else {
                $hiddenContents += "    hidden [object] `$$_paramName"
                $getter = "`$this.$_paramName"
                if ($propType -in @('int')) {
                    $setter = @(
                        "`$this.$_paramName = if (`$cast = $valueString -as [int]) {"
                        '    $cast'
                        '}'
                        'else {'
                        "    $valueString"
                        '}'
                    ) -join "`n$(' ' * 12)"
                }
                else {
                    $setter = "`$this.$_paramName = $valueString"
                }
            }
            $accessorContents += @(
                "        `$this | Add-Member -Force -MemberType ScriptProperty -Name $ParamName -Value {"
                "            $getter"
                '        } -SecondValue {'
                "            $setterParams"
                "            $setter"
                '        }'
            )
        }
        elseif ($Prop.Value.ItemType) {
            if ($Prop.Value.ItemType -eq "Tag" -or ($ParamName -eq 'Tags' -and $Prop.Value.ItemType -eq 'Json')) {
                $ValType = "[VSTag"
                if ($Prop.Value.Type -eq 'List') {
                    $ValType += "[]"
                }
                $ValType += "]"
                $prprtyContents += "    $ValType `$$ParamName"
                if ($ResourceType -eq 'Resource') {
                    $getter = "`$this.Properties['$ParamName']"
                    $setter = "`$this.Properties['$ParamName'] = [VSTag]::TransformTag(`$value)"
                    #$setter = @(
                    #    "`$this.Properties['$ParamName'] = if (`$value -is [VSTag]) {"
                    #    '    $value'
                    #    '}'
                    #    'elseif ($value -is [array]) {'
                    #    '    foreach ($tag in $value) {'
                    #    '        [VSTag]::new($tag)'
                    #    '    }'
                    #    '}'
                    #    'else {'
                    #    '    [VSTag]::new($value)'
                    #    '}'
                    #) -join "`n$(' ' * 12)"
                }
                else {
                    $hiddenContents += "    hidden [object] `$$_paramName"
                    $getter = "`$this.$_paramName"
                    $setter = "`$this.$_paramName = [VSTag]::TransformTag(`$value)"
                }
                $accessorContents += @(
                    "        `$this | Add-Member -Force -MemberType ScriptProperty -Name $ParamName -Value {"
                    "            $getter"
                    '        } -SecondValue {'
                    '            param([TransformTag()] [ValidateType(([IDictionary], [psobject], [VSTag]))] [object] $value)'
                    "            $setter"
                    '        }'
                )
            }
            else {
                $singleType = ($ShortName -replace '\..*' -replace '\W') + $Prop.Value.ItemType
                if (($singleType -in $DuplicateClassNames -or $singleType -in $commonParams) -and $ResourceType -eq 'Property') {
                    $singleType += 'Property'
                }
                $ValType = "[$singleType"
                $setterType = 'object'
                if ($Prop.Value.Type -eq 'List') {
                    $ValType += "[]"
                    $setterType += "[]"
                }
                $ValType += "]"
                $prprtyContents += "    $ValType `$$ParamName"
                $setterParams = "param([ValidateType(([$singleType], [IntrinsicFunction], [ConditionFunction]))] [$setterType] `$value)"
                if ($ResourceType -eq 'Resource') {
                    $getter = "`$this.Properties['$ParamName']"
                    $setter = "`$this.Properties['$ParamName'] = `$value"
                }
                else {
                    $hiddenContents += "    hidden [object] `$$_paramName"
                    $getter = "`$this.$_paramName"
                    $setter = "`$this.$_paramName = `$value"
                }
                $accessorContents += @(
                    "        `$this | Add-Member -Force -MemberType ScriptProperty -Name $ParamName -Value {"
                    "            $getter"
                    '        } -SecondValue {'
                    "            $setterParams"
                    "            $setter"
                    '        }'
                )
            }
        }
        elseif ($Prop.Name -eq "UserData") {
            $prprtyContents += "    [TransformUserData()] [UserData] `$$ParamName"
            if ($ResourceType -eq 'Resource') {
                $getter = "`$this.Properties['$ParamName']"
                $setter = "`$this.Properties['$ParamName'] = `$value -as [UserData]"
            }
            else {
                $hiddenContents += "    hidden [object] `$$_paramName"
                $getter = "`$this.$_paramName"
                $setter = "`$this.$_paramName = `$value -as [UserData]"
            }
            $accessorContents += @(
                '        $this | Add-Member -Force -MemberType ScriptProperty -Name UserData -Value {'
                "            $getter"
                '        } -SecondValue {'
                '            param([TransformUserData()] [object] $value)'
                "            $setter"
                '        }'
            )
        }
        elseif ($Prop.Value.Type -eq "Map") {
            $prprtyContents += "    [IDictionary] `$Map"
        }
        elseif ($Prop.Value.PrimitiveType -in @("Integer","Number") -or $Prop.Value.PrimitiveItemType -in @("Integer","Number")) {
            $ValType = '[int'
            $setterType = 'object'
            if ($Prop.Value.Type -eq 'List') {
                $valueString = '@($value)'
                $ValType += "[]"
                $setterType += "[]"
            }
            else {
                $valueString = '$value'
            }
            $ValType += "]"
            $prprtyContents += "    $ValType `$$ParamName"
            $setterParams = "param([ValidateType(([string], [int], [IntrinsicFunction], [ConditionFunction]))] [$setterType] `$value)"
            if ($ResourceType -eq 'Resource') {
                $getter = "`$this.Properties['$ParamName']"
                $setter = @(
                    "`$this.Properties['$ParamName'] = if (`$cast = $valueString -as [int]) {"
                    '    $cast'
                    '}'
                    'else {'
                    "    $valueString"
                    '}'
                ) -join "`n$(' ' * 12)"
            }
            else {
                $hiddenContents += "    hidden [object] `$$_paramName"
                $getter = "`$this.$_paramName"
                $setter = @(
                    "`$this.$_paramName = if (`$cast = $valueString -as [int]) {"
                    '    $cast'
                    '}'
                    'else {'
                    "    $valueString"
                    '}'
                ) -join "`n$(' ' * 12)"
            }
            $accessorContents += @(
                "        `$this | Add-Member -Force -MemberType ScriptProperty -Name $ParamName -Value {"
                "            $getter"
                '        } -SecondValue {'
                "            $setterParams"
                "            $setter"
                '        }'
            )
        }
        elseif ($Prop.Value.PrimitiveType -eq 'Double' -or $Prop.Value.PrimitiveItemType -eq 'Double') {
            $ValType = '[double'
            $setterType = 'object'
            if ($Prop.Value.Type -eq 'List') {
                $valueString = '@($value)'
                $ValType += "[]"
                $setterType += "[]"
            }
            else {
                $valueString = '$value'
            }
            $ValType += "]"
            $prprtyContents += "    $ValType `$$ParamName"
            $setterParams = "param([ValidateType(([double], [IntrinsicFunction], [ConditionFunction]))] [$setterType] `$value)"
            if ($ResourceType -eq 'Resource') {
                $getter = "`$this.Properties['$ParamName']"
                $setter = "`$this.Properties['$ParamName'] = $valueString"
            }
            else {
                $hiddenContents += "    hidden [object] `$$_paramName"
                $getter = "`$this.$_paramName"
                $setter = "`$this.$_paramName = $valueString"
            }
            $accessorContents += @(
                "        `$this | Add-Member -Force -MemberType ScriptProperty -Name $ParamName -Value {"
                "            $getter"
                '        } -SecondValue {'
                "            $setterParams"
                "            $setter"
                '        }'
            )
        }
        elseif ($Prop.Value.PrimitiveType -eq "Boolean") {
            $ValType = '[bool]'
            $prprtyContents += "    $ValType `$$ParamName"
            $setterParams = "param([ValidateType(([bool], [IntrinsicFunction], [ConditionFunction]))] [object] `$value)"
            if ($ResourceType -eq 'Resource') {
                $getter = "`$this.Properties['$ParamName']"
                $setter = "`$this.Properties['$ParamName'] = `$value"
            }
            else {
                $hiddenContents += "    hidden [object] `$$_paramName"
                $getter = "`$this.$_paramName"
                $setter = "`$this.$_paramName = `$value"
            }
            $accessorContents += @(
                "        `$this | Add-Member -Force -MemberType ScriptProperty -Name $ParamName -Value {"
                "            $getter"
                '        } -SecondValue {'
                "            $setterParams"
                "            $setter"
                '        }'
            )
        }
        elseif ($Prop.Value.PrimitiveType -eq "Json") {
            $prprtyContents += "    [VSJson] `$$ParamName"
            $accessorContents += @(
                "        `$this | Add-Member -Force -MemberType ScriptProperty -Name $ParamName -Value {"
                "            `$this.Properties['$ParamName']"
                '        } -SecondValue {'
                '            param([ValidateType(([string], [VSJson], [VSYaml], [psobject], [IDictionary]))][object] $value)'
                "            `$this.Properties['$ParamName'] = if (`$value -is [VSJson]) {"
                '                $value'
                '            }'
                '            else {'
                "                [VSJson]::new(`$value)"
                '            }'
                '        }'
            )
        }
        elseif ($Prop.Value.PrimitiveType -eq "String") {
            if ($ParamName -eq "LoggingLevel") {
                $hiddenContents += '    hidden [object] $_loggingLevel'
                $prprtyContents += '    [LoggingLevel] $LoggingLevel'
                $methodContents += @(
                    '    [object] FormatLoggingLevel([object] $loggingLevel) {'
                    '        if ($loggingLevel -is [string]) {'
                    '            return $loggingLevel.ToUpper()'
                    '        }'
                    '        else {'
                    '            return $loggingLevel'
                    '        }'
                    '    }'
                )
                $accessorContents += @(
                    '        $this | Add-Member -Force -MemberType ScriptProperty -Name LoggingLevel -Value {'
                    '            $this.FormatLoggingLevel($this._loggingLevel)'
                    '        } -SecondValue {'
                    '            param('
                    '                [ValidateType(([string], [IntrinsicFunction], [ConditionFunction], [LoggingLevel]))] [object]'
                    '                $value'
                    '            )'
                    '            $this._loggingLevel = $value'
                    '        }'
                )
            }
            elseif ($ClassName -eq 'LambdaFunctionCode' -and $ParamName -eq 'ZipFile') {
                $hiddenContents += '    hidden [object] $_zipFile'
                $prprtyContents += '    [string] $ZipFile'
                $accessorContents += @(
                    '        $this | Add-Member -Force -MemberType ScriptProperty -Name ZipFile -Value {'
                    '            $this._zipFile'
                    '        } -SecondValue {'
                    '            param('
                    '                [ValidateType(([string], [IntrinsicFunction], [ConditionFunction]))] [object]'
                    '                $value'
                    '            )'
                    '            $final = if ($value -is [string] -and (Test-Path $value)) {'
                    '                $resolvedPath = (Resolve-Path $value).Path'
                    '                [File]::ReadAllText($resolvedPath)'
                    '            }'
                    '            else {'
                    '                $value'
                    '            }'
                    '            $this._zipFile = $final'
                    '        }'
                )
            }
            else {
                $ValType = '[string'
                $setterType = 'object'
                if ($Prop.Value.Type -eq 'List') {
                    $valueString = '@($value)'
                    $ValType += "[]"
                    $setterType += "[]"
                }
                else {
                    $valueString = '$value'
                }
                $ValType += "]"
                $prprtyContents += "    $ValType `$$ParamName"
                $setterParams = "param([ValidateType(([string], [int], [IntrinsicFunction], [ConditionFunction]))] [$setterType] `$value)"
                if ($ResourceType -eq 'Resource') {
                    $getter = "`$this.Properties['$ParamName']"
                    $setter = @(
                        "`$this.Properties['$ParamName'] = if (`$value -is [int]) {"
                        '    $value.ToString()'
                        '}'
                        'else {'
                        "    $valueString"
                        '}'
                    ) -join "`n$(' ' * 12)"
                }
                else {
                    $hiddenContents += "    hidden [object] `$$_paramName"
                    $getter = "`$this.$_paramName"
                    $setter = @(
                        "`$this.$_paramName = if (`$value -is [int]) {"
                        '    $value.ToString()'
                        '}'
                        'else {'
                        "    $valueString"
                        '}'
                    ) -join "`n$(' ' * 12)"
                }
                $accessorContents += @(
                    "        `$this | Add-Member -Force -MemberType ScriptProperty -Name $ParamName -Value {"
                    "            $getter"
                    '        } -SecondValue {'
                    "            $setterParams"
                    "            $setter"
                    '        }'
                )
            }
        }
        else {
            $propType = if ($prop.Value.ItemType) {
                if (($prop.Value.Type -eq 'Tag' -and $prop.Value.ItemType -eq 'Json') -or (($prop.Value.ItemType -eq 'Tag' -or $prop.Value.ItemType -eq 'Json') -and $prop.Value.Type -eq 'List')) {
                    'VSTag'
                }
                else {
                    (($ShortName -replace '\..*') + $prop.Value.ItemType) -replace '\W'
                }
            }
            elseif ($prop.Value.Type) {
                if (($prop.Value.Type -eq 'Tag' -or $prop.Value.Type -eq 'Json') -and $prop.Value.Type -eq 'List') {
                    'VSTag'
                }
                elseif ($prop.Value.Type -in $noDepsTypes) {
                    $prop.Value.Type
                }
                else {
                    (($ShortName -replace '\..*') + $prop.Value.Type) -replace '\W'
                }
            }
            elseif ($prop.Value.PrimitiveType) {
                $prop.Value.PrimitiveType
            }
            elseif ($prop.Value.PrimitiveItemType) {
                $prop.Value.PrimitiveItemType
            }
            else {
                'object'
            }
            switch -Regex ($propType) {
                '^Boolean$' {
                    $propType = 'bool'
                }
                '^Double$' {
                    $propType = 'double'
                }
                '^(Integer|Number)$' {
                    $propType = 'int'
                }
                '^Long$' {
                    $propType = 'long'
                }
                '^Json$' {
                    $propType = 'VSJson'
                }
                '^Timestamp$' {
                    $propType = 'VSTimestamp'
                }
                '^String$' {
                    $propType = 'string'
                }
            }
            $ValType = "[$propType"
            $setterType = 'object'
            if ($Prop.Value.Type -eq 'List') {
                $valueString = '@($value)'
                $ValType += "[]"
                $setterType += '[]'
            }
            else {
                $valueString = '$value'
            }
            $ValType += "]"
            $prprtyContents += "    $ValType `$$ParamName"
            $setterParams = if ($propType -eq 'string') {
                "param([ValidateType(([$propType], [IntrinsicFunction], [ConditionFunction]))] [$setterType] `$value)"
            }
            else {
                "param([ValidateType(([$propType], [string], [IntrinsicFunction], [ConditionFunction]))] [$setterType] `$value)"
            }
            if ($ResourceType -eq 'Resource') {
                $getter = "`$this.Properties['$ParamName']"
                $setter = "`$this.Properties['$ParamName'] = $valueString"
                if ($propType -in @('int')) {
                    $setter = @(
                        "`$this.Properties['$ParamName'] = if (`$cast = $valueString -as [int]) {"
                        '    $cast'
                        '}'
                        'else {'
                        "    $valueString"
                        '}'
                    ) -join "`n$(' ' * 12)"
                }
                else {
                    $setter = "`$this.Properties['$ParamName'] = $valueString"
                }
            }
            else {
                $hiddenContents += "    hidden [object] `$$_paramName"
                $getter = "`$this.$_paramName"
                if ($propType -in @('int')) {
                    $setter = @(
                        "`$this.$_paramName = if (`$cast = $valueString -as [int]) {"
                        '    $cast'
                        '}'
                        'else {'
                        "    $valueString"
                        '}'
                    ) -join "`n$(' ' * 12)"
                }
                else {
                    $setter = "`$this.$_paramName = $valueString"
                }
            }
            $accessorContents += @(
                "        `$this | Add-Member -Force -MemberType ScriptProperty -Name $ParamName -Value {"
                "            $getter"
                '        } -SecondValue {'
                "            $setterParams"
                "            $setter"
                '        }'
            )
        }
    }
    if ($ResourceType -ne "Property") {
        $prprtyContents += '    [VSJson] $Metadata'
        if ($Name -in @("AWS::AutoScaling::AutoScalingGroup", "AWS::EC2::Instance", "AWS::CloudFormation::WaitCondition")) {
            $prprtyContents += '    [CreationPolicy] $CreationPolicy'
        }
        if ($Name -ne 'AWS::Events::EventBusPolicy') {
            $hiddenContents += '    hidden [object] $_condition'
            $prprtyContents += '    [UpdatePolicy] $UpdatePolicy'
            $prprtyContents += '    [string] $Condition'
            $accessorContents += @(
                "        `$this | Add-Member -Force -MemberType ScriptProperty -Name Condition -Value {"
                '            $this._condition'
                '        } -SecondValue {'
                '            param('
                '                [ValidateType(([string], [IntrinsicFunction], [ConditionFunction]))] [object]'
                '                $value'
                '            )'
                '            $this._condition = $value'
                '        }'
            )
        }
    }
    $scriptContents += $hiddenContents
    $scriptContents += ""
    $scriptContents += $prprtyContents
    $scriptContents += ""
    if ($methodContents.Count) {
        $scriptContents += $methodContents
        $scriptContents += ""
    }
    $scriptContents += $accessorContents
    $scriptContents += "    }"
    $scriptContents += ""
    $scriptContents += @(
        "    $ClassName() : base() {}"
        "    $ClassName([IDictionary] `$props) : base(`$props) {}"
        "    $ClassName([psobject] `$props) : base(`$props) {}"
        '}'
    )
    Set-Content -Value ($scriptContents -join [System.Environment]::NewLine) -Path $PS1Path -Encoding UTF8 -Force
}