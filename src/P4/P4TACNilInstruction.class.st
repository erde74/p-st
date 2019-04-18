Class {
	#name : #P4TACNilInstruction,
	#superclass : #P4TACInstruction,
	#classInstVars : [
		'instance'
	],
	#category : #'P4-TAC-IR'
}

{ #category : #singleton }
P4TACNilInstruction class >> instance [
	^ instance ifNil: [ instance := self new ].
]

{ #category : #'instruction-stream' }
P4TACNilInstruction >> putObjectOn: aStream [
]
