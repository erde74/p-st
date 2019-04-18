Class {
	#name : #P4A2TKernel,
	#superclass : #P4A2TStatic,
	#category : #'P4-TAC'
}

{ #category : #'as yet unclassified' }
P4A2TKernel >> annotation: annotation [
	"self halt."

	annotation selector == #fixedType:as:
		ifTrue: [ self
				staticType: annotation arguments first value
				as: annotation arguments second value ].
	annotation selector == #typeHint:as:
		ifTrue: [ self
				typeHint: annotation arguments first value
				as: annotation arguments second value ].
	annotation selector == #rename:
		ifTrue: [ 
			methodCompiler method selector: annotation arguments first value ].
	annotation selector == #globalName:
		ifTrue: [ methodCompiler method codeUid: annotation arguments first value ].
	annotation selector == #pprimitive:
		ifTrue: [ 
			methodCompiler method primitive: annotation arguments first value ].
	annotation selector == #renameExport:
		ifTrue: [ 
			methodCompiler method message: annotation arguments first value ].
	annotation selector == #groundTypes
		ifTrue: [ groundTypes := true ]
]
