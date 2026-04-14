# FamixOpenApiGenerator (Pharo 12)



The baseline also loads Moose because `FamixOpenApiGenerator` inherits from `FamixMetamodelGenerator`.


## Load from GitHub repository

```smalltalk
Iceberg remoteTypeSelector: #httpsUrl.

Metacello new
  baseline: 'FamixOpenApiGenerator';
  repository: 'github://Evref-BL/Famix-OpenApi:main/src';
  load.
```

## Smoke test the metamodel generator

After loading:

```smalltalk
FamixOpenApi generate.
```
