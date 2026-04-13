# FamixOpenApiGenerator (Pharo 12)

This project is initialized from `alkalinan/Pharo-12-project-template` and includes a Tonel package:

- `OpenAPI2ModelGenerator`
- `FamixOpenApiGenerator`

The baseline also loads Moose because `FamixOpenApi` inherits from `FamixMetamodelGenerator`.


## Load from GitHub repository

```smalltalk
Metacello new
  baseline: 'FamixOpenApiGenerator';
  repository: 'github://Evref-BL/Famix-OpenApi/src';
  load.
```

## Smoke test the metamodel generator

After loading:

```smalltalk
FamixOpenApi generate.
```
