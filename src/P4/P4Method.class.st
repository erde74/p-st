Class {
	#name : #P4Method,
	#superclass : #P4Callable,
	#type : #variable,
	#instVars : [
		'selector',
		'host',
		'package',
		'usedGlobals',
		'usedReferences'
	],
	#category : #'P4-Kernel-Callable'
}

{ #category : #'as yet unclassified' }
P4Method class >> fromTac: aMethod [
	| literals result |
	literals := aMethod literals.
	
	result := self new: literals size.
	1 to: literals size do: [:i | result at: i put: (literals at: i)].
	result code: aMethod codeStream contents.
	result host: aMethod host.
	result selector: aMethod selector.
	^ result
	
]

{ #category : #'as yet unclassified' }
P4Method class >> pInstSize [ 
	^ self instSize - 2
]

{ #category : #'as yet unclassified' }
P4Method class >> pIsBytes [
	^ true
]

{ #category : #accessing }
P4Method >> code [
	^ code
]

{ #category : #accessing }
P4Method >> code: anObject [
	code := anObject
]

{ #category : #exporting }
P4Method >> dumpOn: binaryOut [
	<preventExport>
	| myRef |
	myRef := super dumpOn: binaryOut.  
	binaryOut resolveReferences: self reference: myRef.
	^ myRef
]

{ #category : #accessing }
P4Method >> host [
	^ host
]

{ #category : #accessing }
P4Method >> host: anObject [
	host := anObject
]

{ #category : #accessing }
P4Method >> numArgs [
	selector countArgs  
]

{ #category : #exporting }
P4Method >> pByteAt: i [
	^ code at: i.
	
]

{ #category : #exporting }
P4Method >> pByteName [
	^ host earlySelectorAddress: selector  
]

{ #category : #exporting }
P4Method >> pByteSize [
	^ code size
]

{ #category : #exporting }
P4Method >> pInstVarAt: i [
	<preventExport>
	i = 1 ifTrue: [ ^ self pVariableSize + self class pInstSize  ].
	^ super pInstVarAt: i
]

{ #category : #exporting }
P4Method >> pVariableSize [
	^ self basicSize
]

{ #category : #accessing }
P4Method >> package [
	^ package
]

{ #category : #accessing }
P4Method >> package: anObject [
	package := anObject
]

{ #category : #accessing }
P4Method >> printOn: aStream [
	aStream << '>>' << selector
]

{ #category : #accessing }
P4Method >> selector [
	^ selector
]

{ #category : #accessing }
P4Method >> selector: anObject [
	selector := anObject
]

{ #category : #accessing }
P4Method >> usedGlobals [
	^ usedGlobals
]

{ #category : #accessing }
P4Method >> usedGlobals: anObject [
	usedGlobals := anObject
]

{ #category : #accessing }
P4Method >> usedReferences [
	^ usedReferences
]

{ #category : #accessing }
P4Method >> usedReferences: anObject [
	usedReferences := anObject
]
