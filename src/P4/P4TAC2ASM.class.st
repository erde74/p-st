Class {
	#name : #P4TAC2ASM,
	#superclass : #P4Object,
	#instVars : [
		'processor',
		'currentCallable',
		'methods'
	],
	#category : #'P4-ASM'
}

{ #category : #instructions }
P4TAC2ASM >> checkShortJump: aJump for: aBlock [
	| result |
	aJump isShort ifTrue: [ processor forceShortJump ].
	result := aBlock value.
	processor unforceShortJump.
	^ result
]

{ #category : #compiling }
P4TAC2ASM >> compile: aMethod [
	processor reset.
	processor tagMethod: aMethod.
	self compileCallable: aMethod.
	aMethod stream: processor stream.
	aMethod closures do: [ :aClosure |
		processor tagClosure: aClosure.
		self compileCallable: aClosure ].
	processor finalize.
	^ P4Method fromTac: aMethod.	
	
]

{ #category : #compiling }
P4TAC2ASM >> compileBasicBlock: aCodeBlock [
	processor label: aCodeBlock.
	aCodeBlock do: [ :anInstruction | anInstruction accept: self ]
]

{ #category : #compiling }
P4TAC2ASM >> compileCallable: aCallable [
	| currentBasicBlock |
	
	methods add: aCallable.
	aCallable setupFrame: self.
	currentBasicBlock := aCallable entry.
	[ currentBasicBlock atEnd ] whileFalse: [
		self compileBasicBlock: currentBasicBlock.
		currentBasicBlock := currentBasicBlock nextBlock ].
	aCallable invokeBlock ifNotNil: [self compileBasicBlock: aCallable invokeBlock].
	currentCallable := nil.
]

{ #category : #compiling }
P4TAC2ASM >> initialize [ 
	methods := OrderedCollection new.
]

{ #category : #accessing }
P4TAC2ASM >> processor: aProcessor [
	processor := aProcessor
]

{ #category : #private }
P4TAC2ASM >> setupStaticFrame: aCallable [
	| entry currentBasicBlock |
	currentCallable ifNotNil: [ self error: 'Should not build up a frame while another frame is active' ].
	currentCallable := aCallable.
	
	currentBasicBlock := currentCallable preamble.	
	[ currentBasicBlock == currentCallable argumentLoading  ] whileFalse: [
		self compileBasicBlock: currentBasicBlock.
		currentBasicBlock := currentBasicBlock nextBlock ].	

	currentCallable frameSize > 0
		ifTrue: [ 
			processor
				sub: (processor constant: currentCallable frameSize * processor pointerSize )
				from: processor stackPointer ].

	currentBasicBlock := currentCallable argumentLoading .	
	[ currentBasicBlock == currentCallable entry ] whileFalse: [
		self compileBasicBlock: currentBasicBlock.
		currentBasicBlock := currentBasicBlock nextBlock ].

]

{ #category : #private }
P4TAC2ASM >> tearDownFrame: shouldKeepArguments [
	currentCallable frameSize > 0
		ifTrue: [ 
			processor
				add: (processor constant: currentCallable frameSize * processor pointerSize )
				to: processor stackPointer ].
	self compileBasicBlock: currentCallable postamble. 
	shouldKeepArguments 
		ifFalse: [self compileBasicBlock: currentCallable popArguments.]

]

{ #category : #instructions }
P4TAC2ASM >> visitAdd: anInstruction [
	^ processor
		add: (anInstruction left accept: self)
		to: (anInstruction right accept: self)
]

{ #category : #instructions }
P4TAC2ASM >> visitAnd: anInstruction [
	^ processor
		and: (anInstruction left accept: self)
		with: (anInstruction right accept: self)
]

{ #category : #instructions }
P4TAC2ASM >> visitAssignment: anAssignment [
	^ processor
		mov: (anAssignment origin accept: self)
		to: (anAssignment target accept: self)
]

{ #category : #instructions }
P4TAC2ASM >> visitBitShift: anInstruction [
	^ processor
		shl: (anInstruction target accept: self)
		by: (anInstruction bits)
]

{ #category : #instructions }
P4TAC2ASM >> visitBitShiftRight: anInstruction [
	^ processor
		shr: (anInstruction target accept: self)
		by: (anInstruction bits)
]

{ #category : #instructions }
P4TAC2ASM >> visitBitTest: anInstruction [
	^ processor
		testBit: (anInstruction bit)
		on: (anInstruction location accept: self)
]

{ #category : #instructions }
P4TAC2ASM >> visitCall: aNative [
	^ processor directRelativeCall: aNative method offset: aNative offset    
]

{ #category : #instructions }
P4TAC2ASM >> visitCompare: aComparison [
	^ processor
		cmp: (aComparison left accept: self)
		with: (aComparison right accept: self)
]

{ #category : #instructions }
P4TAC2ASM >> visitConditionalJump: aJump [
	^ self checkShortJump: aJump for: [
		aJump 
			ifEqualsTest: [ aJump
				ifCarryTest: [ self error: 'combined checks of multiple flags (jge an the like) is not yet supported' ] 
				else: [ aJump 
					ifEqualsSet: [ processor je: aJump target ] 
					else: [ processor jne: aJump target ] ] ] 
			else: [ aJump 
				ifCarryTest: [ aJump 
					ifCarrySet: [ processor jc: aJump target ] 
					else: [ processor jnc: aJump target ] ]
				else: [ self error: 'this is not a conditional jump']]]
]

{ #category : #values }
P4TAC2ASM >> visitConstant: aConstant [
	^ processor constant: aConstant constantValue
]

{ #category : #instructions }
P4TAC2ASM >> visitConstantReference: aReference [
	^ processor externalReference: aReference target
]

{ #category : #instructions }
P4TAC2ASM >> visitHalt: aHalt [
	^ processor int3
]

{ #category : #instructions }
P4TAC2ASM >> visitIndirectCall: aCall [
	^ processor indirectCall: ( aCall register accept: self )
]

{ #category : #instructions }
P4TAC2ASM >> visitIndirectJump: aJump [
	^ processor indirectJmp: ( aJump register accept: self )
]

{ #category : #instructions }
P4TAC2ASM >> visitJump: aJump [
	^ self checkShortJump: aJump for: [ processor jmp: aJump target ]
]

{ #category : #instructions }
P4TAC2ASM >> visitLoadAddress: aLoadAddress [
	^ processor
		lea: (aLoadAddress origin accept: self)
		to: (aLoadAddress target accept: self)
]

{ #category : #values }
P4TAC2ASM >> visitMethodObjectAccess: aLiteral [
	^ (P4ASMObjectAccess new)
		target: aLiteral target;
		offset: aLiteral index * processor pointerSize  
]

{ #category : #instructions }
P4TAC2ASM >> visitOr: anInstruction [
	^ processor
		or: (anInstruction left accept: self)
		with: (anInstruction right accept: self)
]

{ #category : #instructions }
P4TAC2ASM >> visitPop: aPop [
	^ processor pop: aPop register
]

{ #category : #instructions }
P4TAC2ASM >> visitPush: aPush [
	^ processor push: aPush register
]

{ #category : #instructions }
P4TAC2ASM >> visitReference: aReference [
	^ processor reference: aReference target.
]

{ #category : #instructions }
P4TAC2ASM >> visitReturn: aReturn [
	aReturn tearDown ifTrue: [self tearDownFrame: false].
	processor ret.
]

{ #category : #instructions }
P4TAC2ASM >> visitSub: anInstruction [
	^ processor
		sub: (anInstruction left accept: self)
		from: (anInstruction right accept: self)
]

{ #category : #instructions }
P4TAC2ASM >> visitTeardown: aReturn [
	self tearDownFrame: aReturn shouldKeepArguments.
]

{ #category : #instructions }
P4TAC2ASM >> visitTest: anInstruction [
	^ processor
		test: (anInstruction left accept: self)
		with: (anInstruction right accept: self)
]

{ #category : #values }
P4TAC2ASM >> visitVariableAccess: aVariableAccess [
	^ aVariableAccess register accessAt: aVariableAccess index * processor pointerSize
]

{ #category : #values }
P4TAC2ASM >> visitVariableNode: aVariable [
	^ aVariable asAsm
]

{ #category : #visiting }
P4TAC2ASM >> visitVolatileFence: aP4TACVolatileFence [ 
]

{ #category : #instructions }
P4TAC2ASM >> visitXor: anInstruction [
	^ processor
		xor: (anInstruction left accept: self)
		with: (anInstruction right accept: self)
]
