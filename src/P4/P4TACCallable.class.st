Class {
	#name : #P4TACCallable,
	#superclass : #P4TACCodeBlock,
	#instVars : [
		'preamble',
		'registerPushing',
		'argumentLoading',
		'primitiveCalling',
		'entry',
		'postamble',
		'popArguments',
		'invokeBlock',
		'locals',
		'temporaries',
		'frameSize',
		'usedRegisters',
		'remoteVariables'
	],
	#category : #'P4-TAC-IR'
}

{ #category : #accessing }
P4TACCallable >> argumentLoading [
	^ argumentLoading
]

{ #category : #accessing }
P4TACCallable >> argumentLoading: anObject [
	argumentLoading := anObject
]

{ #category : #accessing }
P4TACCallable >> basePointer [ 
	^ self outerScope basePointer
]

{ #category : #accessing }
P4TACCallable >> basePointerFor: asm2tac [
	^ asm2tac visitVariableNode: P4TACBasePointerName instance
]

{ #category : #accessing }
P4TACCallable >> basicBlocksDo: aBlock [
	| currentBlock |
	currentBlock := preamble.
	[ currentBlock atEnd ] whileFalse: [
		aBlock value: currentBlock.
		currentBlock := currentBlock nextBlock ]
	
]

{ #category : #accessing }
P4TACCallable >> entry [
	^ entry
]

{ #category : #accessing }
P4TACCallable >> entry: anEntry [
	entry := anEntry .
]

{ #category : #accessing }
P4TACCallable >> expungeUnusedLocals [
	| names toRemove local |
	names := locals keys.
	names do: [ :name |
		local :=(locals at: name).
		local isUnused ifTrue: [ locals removeKey: name ] ].
	toRemove := Set new.
	temporaries do: [ :aTemp | aTemp isUnused ifTrue: [ toRemove add: aTemp ]].
	toRemove do: [ :aTemp | temporaries remove: aTemp ].
]

{ #category : #accessing }
P4TACCallable >> frameSize [
    ^ frameSize + self stackAllignment
]

{ #category : #accessing }
P4TACCallable >> frameSize: aFrameSize [
	frameSize := aFrameSize 
]

{ #category : #accessing }
P4TACCallable >> hasLocal: aVariable [
	^ locals includes: aVariable     
]

{ #category : #'initialize-release' }
P4TACCallable >> initialize [
	locals := IdentityDictionary new.
	temporaries := P4Set new.
]

{ #category : #accessing }
P4TACCallable >> invokeBlock [
	^ invokeBlock
]

{ #category : #accessing }
P4TACCallable >> invokeBlock: anObject [
	invokeBlock := anObject
]

{ #category : #testing }
P4TACCallable >> is: variable lifeAfter: line [
	liveness at: variable ifPresent: [ :ival |
		^ ival end > line ].
	^ false.
]

{ #category : #accessing }
P4TACCallable >> locals [
	^ locals
]

{ #category : #accessing }
P4TACCallable >> popArguments [
	^ popArguments
]

{ #category : #accessing }
P4TACCallable >> popArguments: anObject [
	popArguments := anObject
]

{ #category : #accessing }
P4TACCallable >> postamble [
	^ postamble
]

{ #category : #accessing }
P4TACCallable >> postamble: anObject [
	postamble := anObject
]

{ #category : #accessing }
P4TACCallable >> preamble [
	^ preamble
]

{ #category : #accessing }
P4TACCallable >> preamble: anObject [
	preamble := anObject
]

{ #category : #accessing }
P4TACCallable >> primitiveCalling [
	^ primitiveCalling
]

{ #category : #accessing }
P4TACCallable >> primitiveCalling: anObject [
	^ primitiveCalling := anObject
]

{ #category : #accessing }
P4TACCallable >> registerPushing [
	^ registerPushing
]

{ #category : #accessing }
P4TACCallable >> registerPushing: anObject [
	^ registerPushing := anObject
]

{ #category : #accessing }
P4TACCallable >> remoteVariables [
	^ remoteVariables
]

{ #category : #accessing }
P4TACCallable >> remoteVariables: anObject [
	remoteVariables := anObject
]

{ #category : #accessing }
P4TACCallable >> returnTokenFor: asm2tac [
	^ asm2tac visitVariableNode: P4TACReturnTokenName instance
]

{ #category : #visiting }
P4TACCallable >> setupFrame: aVisitor [
	^ aVisitor setupStaticFrame: self
]

{ #category : #accessing }
P4TACCallable >> stackAllignment [
	| realSize |
	realSize := (usedRegisters + frameSize + 1).
	self hasNonLocalReturn ifTrue: [ realSize := realSize + 1 ].
	^ realSize bitAnd: 1
]

{ #category : #accessing }
P4TACCallable >> temps [
	^ temporaries
]

{ #category : #accessing }
P4TACCallable >> usedRegisters [
	^ usedRegisters
]

{ #category : #accessing }
P4TACCallable >> usedRegisters: anObject [
	usedRegisters := anObject
]
