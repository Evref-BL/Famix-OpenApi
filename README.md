# OpenApiMetamodelGenerator (Pharo 12)

This project is initialized from `alkalinan/Pharo-12-project-template` and includes a Tonel package:

- `OpenAPI2ModelGenerator`
- `OpenApiMetamodelGenerator`

The baseline also loads Moose (v7) because `OpenAPI2MetamodelGenerator` inherits from `FamixMetamodelGenerator`.


## Load from GitHub repository

```smalltalk
Metacello new
  baseline: 'OpenApiMetamodelGenerator';
  repository: 'github://Evref-BL/Famix-OpenApi/src';
  load.
```

## Smoke test the metamodel generator

After loading:

```smalltalk
OpenAPI2MetamodelGenerator generate.
```
