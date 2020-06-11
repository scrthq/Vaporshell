$projectRoot = Resolve-Path "$PSScriptRoot/../../.."
$Verbose = @{}
if ($ENV:BHBranchName -eq "dev" -or $env:BHCommitMessage -match "!verbose" -or $ENV:TRAVIS_COMMIT_MESSAGE -match "!verbose" -or $ENV:TRAVIS_BRANCH -eq "dev" ) {
    $Verbose.add("Verbose", $True)
}
$BuildOutputPath = Resolve-Path "$projectRoot/BuildOutput"
$ServiceModulesPath = Resolve-Path "$BuildOutputPath/_autoGenerated"
if (($env:PSModulePath -split ';') -notcontains $BuildOutputPath) {
    $env:PSModulePath = @($BuildOutputPath, $env:PSModulePath) -join [System.IO.Path]::PathSeparator
}
$serviceModules = Get-ChildItem $ServiceModulesPath -Directory

foreach ($serviceModule in $serviceModules) {
    $ModulePath = Resolve-Path "$BuildOutputPath/$($serviceModule.BaseName)"
    Describe "[$($serviceModule.BaseName)] Class tests" -Tag 'ModuleClass',"$($serviceModule.BaseName)ModuleClass",$serviceModule.BaseName {
        BeforeAll {
            Import-Module $ModulePath -Force
        }
        Context "[$($serviceModule.BaseName)] Confirm classes instantiate with the parameterless constructor" {
            $types = [System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object {
                ($_.FullName -match 'PowerShell Class Assembly' -and $_.CustomAttributes -match "$($serviceModule.BaseName)\.Classes\.ps1") -or # PS Core dynamic PS class assembly match
                ($_.FullName -match "$($serviceModule.BaseName)\.Classes\.ps1") # Windows PS dynamic PS class assembly match
            } | Select-Object -ExpandProperty DefinedTypes | Where-Object {
                $_.Name -notmatch '_\<staticHelpers\>$'
            } | Sort-Object FullName
            $testCase = $types | ForEach-Object { @{type = $_ } }
            It "[$($serviceModule.BaseName)] Class <type> should not throw when instantiated" -TestCases $testCase {
                param($type)
                { $type::new() } | Should -Not -Throw
            }

            It "[$($serviceModule.BaseName)] Class <type> should have a Help() method" -TestCases $testCase {
                param($type)
                { $type::new() | Get-Member -MemberType Method -Name 'Help' } | Should -Not -BeNullOrEmpty
            }
            It "[$($serviceModule.BaseName)] Class <type> should return Help content with Help()" -TestCases $testCase {
                param($type)
                { $type::new().Help() } | Should -Not -Throw
                $response = $type::new().Help()
                $response | Should -Not -BeNullOrEmpty
            }

            It "[$($serviceModule.BaseName)] Class <type> should have a Docs method" -TestCases $testCase {
                param($type)
                { $type::new() | Get-Member -MemberType Method -Name 'Docs' } | Should -Not -BeNullOrEmpty
            }
            It "[$($serviceModule.BaseName)] Class <type> should return a string with Docs()" -TestCases $testCase {
                param($type)
                Mock Start-Process -MockWith { }
                { $type::new().Docs() } | Should -Not -Throw
                $response = $type::new().Docs()
                $response | Should -Not -BeNullOrEmpty
            }

            It "[$($serviceModule.BaseName)] If Resource class, <type> should have a GetAtt method" -TestCases $testCase {
                param($type)
                if ($type.BaseType.FullName -eq 'VSResource') {
                    { $type::new() | Get-Member -MemberType Method -Name 'GetAtt' } | Should -Not -BeNullOrEmpty
                }
            }
            It "[$($serviceModule.BaseName)] If Resource class, <type> GetAtt() should work as expected" -TestCases $testCase {
                param($type)
                if ($type.BaseType.FullName -eq 'VSResource') {
                    $item = $type::new()
                    if ($item._attributes.Count -ne 1) {
                        $message = if ($item._attributes.Count -eq 0) {
                            "There are 0 attributes available for this resource! Please use <FnRef> instead."
                        }
                        else {
                            "There are $($item._attributes.Count) attributes available for this resource! Please specify the attribute you would like to use for <FnGetAtt> instead. Valid attributes for a $($type.FullName) resource: $($item._attributes -join ', ')"
                        }
                        { $item.GetAtt() } | Should -Throw -ExpectedMessage $message
                    }
                    else {
                        { $item.GetAtt() } | Should -Not -Throw
                    }
                }
            }
            It "[$($serviceModule.BaseName)] If Resource class, <type> GetAtt([string]`$attName) should work as expected" -TestCases $testCase {
                param($type)
                if ($type.BaseType.FullName -eq 'VSResource') {
                    $item = $type::new()
                    $fakeAtt = 'NonExistentAttribute'
                    if ($item._attributes.Count -eq 0) {
                        { $item.GetAtt($fakeAtt) } | Should -Throw -ExpectedMessage "There are 0 attributes available for this resource! Please use <FnRef> instead."
                    }
                    else {
                        { $item.GetAtt($fakeAtt) } | Should -Throw -ExpectedMessage "$fakeAtt is not a valid attribute for this resource to return via <FnGetAtt>.  Valid attributes for a $($item.GetType().FullName) resource: $($item._attributes -join ', ')"

                        $realAtt = $item._attributes | Select-Object -First 1
                        { $item.GetAtt($realAtt) } | Should -Not -Throw
                    }
                }
            }
        }
    }
}
