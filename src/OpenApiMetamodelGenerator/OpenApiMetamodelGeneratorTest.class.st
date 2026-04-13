Class {
	#name : #OpenApiMetamodelGeneratorTest,
	#superclass : #TestCase,
	#package : 'OpenApiMetamodelGenerator'
}

{ #category : 'testing' }
OpenApiMetamodelGeneratorTest >> testHelloWorld [
	self assert: OpenApiMetamodelGenerator new helloWorld equals: 'open api metamodel generator'
]
