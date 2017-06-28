---
layout: page 
title: Upcoming & Historical Changes
description: Changes within each release of Vaporshell
---
<!-- TOC -->

- [Upcoming](#upcoming)
    - [In-Progress](#in-progress)
    - [Long-Term](#long-term)
- [Historical](#historical)
    - [0.7.10](#0710)
    - [0.7.9](#079)
    - [0.7.8](#078)
    - [0.7.7](#077)
    - [0.7.6](#076)
    - [0.7.5](#075)
    - [0.7.4](#074)
    - [0.7.3](#073)
    - [0.7.2](#072)

<!-- /TOC -->


## Upcoming

### In-Progress

- [Issue #2](https://github.com/scrthq/Vaporshell/issues/2): YAML output options using cfn-flip
- [Issue #3](https://github.com/scrthq/Vaporshell/issues/3): Enable external config files for template reuse across environments

### Long-Term

- Add support for other Cloud Providers such as Google Cloud Platform, Azure


## Historical
### 0.7.10

- Added full Serverless coverage
- Expanded `Add-UserData` functionality to detect ps1, bat & cmd files and tag them if needed


### 0.7.9

- Fixed issue where List parameters with single values were being cast as a single string/object instead of an array with a single string/object


### 0.7.8

- Added `-ValidateTemplate` parameter to leverage `aws cloudformation validate-template` for syntax validation

### 0.7.7

- AppVeyor config updates


### 0.7.6 

- Added in FunctionBuilder and finished building all resource and resource property types


### 0.7.5 

- Added `Add-UserData`


### 0.7.4 

- Added Coveralls.io code coverage grading to CI process


### 0.7.3

- Expanded AppVeyor tests


### 0.7.2

- Updated module minor version to 7