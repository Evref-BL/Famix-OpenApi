# OpenApiMetamodelGenerator (Pharo 12)

This project is initialized from `alkalinan/Pharo-12-project-template` and includes a Tonel package:

- `OpenAPI2ModelGenerator`
- `OpenApiMetamodelGenerator`

The baseline also loads Moose (v7) because `OpenAPI2MetamodelGenerator` inherits from `FamixMetamodelGenerator`.

## Load from local checkout

In a Pharo 12 Playground:

```smalltalk
Metacello new
  baseline: 'OpenApiMetamodelGenerator';
  repository: 'tonel:///Users/nicolashlad/Development/Projects/IDM/Pharo-12-project-template/src';
  load.
```

## Load from GitHub repository

```smalltalk
Metacello new
  baseline: 'OpenApiMetamodelGenerator';
  repository: 'github://<your-username>/<your-repository>/src';
  load.
```

## Smoke test the metamodel generator

After loading:

```smalltalk
OpenAPI2MetamodelGenerator generate.
```
