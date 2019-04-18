Class {
	#name : #P4TACMethod,
	#superclass : #P4TACCallable,
	#instVars : [
		'host',
		'message',
		'literals',
		'closures',
		'uid',
		'codeUid',
		'methodObject',
		'codeStream',
		'primitive',
		'returnAddress',
		'nonLocalReturn'
	],
	#category : #'P4-TAC-IR'
}

{ #category : #'visitor accepting' }
P4TACMethod >> accept: aVisitor [
	^ aVisitor visitMethod: self
]

{ #category : #accessing }
P4TACMethod >> addClosure: aBlock [
	aBlock code containsReturn ifTrue: [ nonLocalReturn := true ].
	^ closures add: aBlock
]

{ #category : #accessing }
P4TACMethod >> basePointer [
	^ self locals at: P4TACBasePointerName instance
]

{ #category : #accessing }
P4TACMethod >> baseSize [
	^ P4SmalltalkConfiguration objectHeaderSize + P4Method instSize + literals size
]

{ #category : #accessing }
P4TACMethod >> byteSize [
	^ codeStream pointerSize * self baseSize + self codeSize 
]

{ #category : #accessing }
P4TACMethod >> closures [
	^ closures
]

{ #category : #accessing }
P4TACMethod >> closures: anObject [
	closures := anObject
]

{ #category : #accessing }
P4TACMethod >> codeSize [
	^ codeStream size
]

{ #category : #accessing }
P4TACMethod >> codeStream [
	^ codeStream
]

{ #category : #accessing }
P4TACMethod >> codeUid [
	^ codeUid ifNil: [ uid := (host pfullName, '>>', self selector) asSymbol ]
]

{ #category : #accessing }
P4TACMethod >> codeUid: anObject [
	^ codeUid := anObject
]

{ #category : #accessing }
P4TACMethod >> export: aVariable [
	locals at: aVariable ifPresent: [ :var | ^ var ].
	^ nil
]

{ #category : #accessing }
P4TACMethod >> frameSize: aFrameSize [
	returnAddress ifNotNil: [ returnAddress index: aFrameSize + 1].
	super frameSize: aFrameSize  
]

{ #category : #accessing }
P4TACMethod >> hasNonLocalReturn [
	^ nonLocalReturn
]

{ #category : #accessing }
P4TACMethod >> host [
	^ host
]

{ #category : #accessing }
P4TACMethod >> host: anObject [
	host := anObject
]

{ #category : #initialization }
P4TACMethod >> initialize [
	super initialize.
	closures := OrderedCollection new.
	nonLocalReturn := false.
]

{ #category : #accessing }
P4TACMethod >> isPrimitive [
	^ primitive isNil not
]

{ #category : #accessing }
P4TACMethod >> literals [
	^ literals
]

{ #category : #accessing }
P4TACMethod >> literals: anObject [
	literals := anObject
]

{ #category : #accessing }
P4TACMethod >> message [ 
	^ message
]

{ #category : #accessing }
P4TACMethod >> message: aMessage [
	message := aMessage 
]

{ #category : #accessing }
P4TACMethod >> methodFrameSize [
	^ self frameSize
]

{ #category : #accessing }
P4TACMethod >> methodObject [ 
	^ methodObject ifNil: [ ^ methodObject := P4TACMethodObject new ].

]

{ #category : #accessing }
P4TACMethod >> numOfStringLiterals [ 
	^ (literals select: [ :l | l isString ]) size
]

{ #category : #accessing }
P4TACMethod >> primitive [
	^ primitive
]

{ #category : #accessing }
P4TACMethod >> primitive: anObject [
	primitive := anObject
]

{ #category : #printing }
P4TACMethod >> printOn: stream [
	stream << message
]

{ #category : #printing }
P4TACMethod >> printSource [
	| currentBlock stream |
	currentBlock := entry.
	stream := Stream new.
	[ currentBlock isLast ] whileFalse: [
		currentBlock do: [ :instr |
			instr printOn: stream ]
	].
	^ stream asString
]

{ #category : #accessing }
P4TACMethod >> returnToken [  
	^ self locals at: P4TACReturnTokenName instance
]

{ #category : #accessing }
P4TACMethod >> selector [
	^ message
]

{ #category : #accessing }
P4TACMethod >> selector: aSelector [
	message selector: aSelector
]

{ #category : #accessing }
P4TACMethod >> stream: aStream [
	^ codeStream := aStream 
]
