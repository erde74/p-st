Class {
	#name : #P4TACBuilder,
	#superclass : #P4Object,
	#instVars : [
		'currentBasicBlock',
		'locals',
		'temps',
		'instVars',
		'instVarsIdx',
		'literals',
		'resultVariable',
		'globals',
		'method',
		'klass',
		'selfImport'
	],
	#category : #'P4-TAC'
}

{ #category : #'tac-value-builder' }
P4TACBuilder >> add: value to: aVariable [
	currentBasicBlock << (P4TACAdd a: value to: aVariable)
]

{ #category : #accessing }
P4TACBuilder >> addGlobal: anObject [
	^ globals at: anObject asString asSymbol  put: (P4TACExternalReference target: anObject )
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> and: value with: aVariable [
	currentBasicBlock << (P4TACAnd a: value to: aVariable)
]

{ #category : #helper }
P4TACBuilder >> bitShift: target by: num [
	currentBasicBlock << P4TACBitShift new target: target; bits: num
]

{ #category : #accessing }
P4TACBuilder >> classReferenceFor: aName [
	klass := (Smalltalk globals at: aName ifAbsent: [ self error: 'Undeclared class ', aName ]) asPClass.
	^ self loadConstant: klass

]

{ #category : #'initialize-release' }
P4TACBuilder >> clearInstVars [
	instVars removeAll.
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> closure: aClosure inScope: aCallable [
	| closure capture temp |
	temp := self nextClosureTemp.
	closure := P4TACClosure new.
	closure code: aClosure.
	closure outerScope: aCallable.
	capture := P4TACCaptureClosure new.
	capture closure: closure.
	capture capturedAt: currentBasicBlock.
	capture resultVariable: temp.
	currentBasicBlock << capture.
	^ capture
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> compare: value to: aVariable [
	currentBasicBlock << (P4TACCompare a: value to: aVariable)
]

{ #category : #accessing }
P4TACBuilder >> currentBasicBlock [
	^ currentBasicBlock

]

{ #category : #helper }
P4TACBuilder >> declare: variableName [
	^ locals at: variableName ifAbsentPut: (P4TACLocal named: variableName)
]

{ #category : #helper }
P4TACBuilder >> declareInstVars: someInstVars [
	| index |
	index := 0.
	someInstVars do: [ :v |
		instVarsIdx at: v asSymbol put: index.
		index := index + 1 ]
]

{ #category : #helper }
P4TACBuilder >> declareLocals: someLocals [
	| name |
	someLocals do: [ :v |
		name := v name asSymbol.
		self declare: name.  
	]
]

{ #category : #helper }
P4TACBuilder >> declareSelf: variableName [
	^ locals at: variableName put: (P4TACSelf named: variableName)
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> directCall: aSymbol [
	currentBasicBlock << (P4TACCall to: aSymbol)
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> directCallSkipTypeCheck: aSymbol on: type [
	currentBasicBlock << ((P4TACCall to: aSymbol) offset: type typeCheckByteSize)
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> directReturn: value [
	self move: value to: resultVariable.
	currentBasicBlock << P4TACReturn new noTeardown

]

{ #category : #'tac-value-builder' }
P4TACBuilder >> endBlock [
	currentBasicBlock nextBlock ifNotNil: [ self error: 'Trying to end non-final block' ].
	currentBasicBlock nextBlock: P4TACEndBlock new
]

{ #category : #globals }
P4TACBuilder >> false [
	^ globals at: #false
]

{ #category : #helper }
P4TACBuilder >> firstBasicBlock [
	^ currentBasicBlock := P4TACBasicBlock number: 1  
	
]

{ #category : #accessing }
P4TACBuilder >> global: aGlobal [
	^ globals at: aGlobal
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> indirectCall: target [
	currentBasicBlock << (P4TACIndirectCall to: target)
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> indirectJump: target [
	currentBasicBlock << (P4TACIndirectJump to: target)
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> indirectTailJump: target [
	currentBasicBlock 
		<< P4TACTeardown new;
		<< (P4TACIndirectJump to: target)
]

{ #category : #'initialize-release' }
P4TACBuilder >> initialize [
	literals := OrderedCollection new.
	instVars := IdentityDictionary new.
	instVarsIdx := IdentityDictionary new.
	locals := IdentityDictionary new.
	self initializeGlobals.
]

{ #category : #accessing }
P4TACBuilder >> initializeGlobals [
	globals := P4IdentityDictionary new.
	self 
		addGlobal: nil;
		addGlobal: true;
		addGlobal: false.
]

{ #category : #accessing }
P4TACBuilder >> instVar: aName [
	^self instVar: aName ifAbsent: [ self error: 'this is no instVar']
]

{ #category : #accessing }
P4TACBuilder >> instVar: aName ifAbsent: aBlock [
	^ instVars at: aName ifAbsentPut: [
		instVarsIdx at: aName 
			ifPresent: [ :i | self self accessAt: i ]
			ifAbsent: aBlock ]
]

{ #category : #accessing }
P4TACBuilder >> instVarOrGlobal: aName [
	^ self instVar: aName ifAbsent: [ 
		globals at: aName ifAbsent: [
			(aName at: 1) isUppercase 
				ifTrue: [ self classReferenceFor: aName ]
				ifFalse: [ self error: 'Unknown variable: ', aName ]]]

]

{ #category : #'tac-value-builder' }
P4TACBuilder >> intAdd: value to: aVariable [
	currentBasicBlock 
		<< (P4TACXOr a: (P4TACConstant with: 1) to: aVariable);
		<< (P4TACAdd a: value to: aVariable)
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> intSub: value from: aVariable [
	currentBasicBlock 
		<< (P4TACSub a: value to: aVariable);
		<< (P4TACOr a: (P4TACConstant with: 1) to: aVariable)
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> invoke: n [
	currentBasicBlock << (P4TACCall to: (P4Object earlySelectorAddress: #invoke:) )
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> jump: target [
	currentBasicBlock << (P4TACJump to: target)
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> jumpCarry: target [
	currentBasicBlock << ((P4TACJump to: target) carry)
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> jumpEqual: target [
	currentBasicBlock << ((P4TACJump to: target) equals)
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> jumpNoCarry: target [
	currentBasicBlock << ((P4TACJump to: target) noCarry)
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> jumpNotEqual: target [
	currentBasicBlock << ((P4TACJump to: target) notEquals)
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> literalFrameIndex: aConstant [	
	literals add: aConstant.
	^ literals size.
]

{ #category : #accessing }
P4TACBuilder >> literals [
	^ literals
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> loadConstant: aConstant [
	| index |
	index := self literalFrameIndex: aConstant.
	^ (method accessAt: index)
]

{ #category : #helper }
P4TACBuilder >> loadSelf: variableName from: aBlock [
	selfImport := aBlock
]

{ #category : #accessing }
P4TACBuilder >> local: aName [
	^ locals
		at: aName
		ifAbsent: [ self error: 'no such local variable' ]
]

{ #category : #accessing }
P4TACBuilder >> local: aName ifAbsent: aBlock [
	^ locals
		at: aName
		ifAbsent: aBlock
]

{ #category : #helper }
P4TACBuilder >> localOrInstVar: aName [
	| temp |
	^ self local: aName ifAbsent: [
		self instVar: aName ifAbsent: [ self error: 'no such local or intsance variable'] ].
]

{ #category : #accessing }
P4TACBuilder >> locals: aDictionary [
	locals := aDictionary
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> move: aTACValue to: aTACVariable [
	currentBasicBlock << (aTACValue moveTo: aTACVariable ).
]

{ #category : #helper }
P4TACBuilder >> nextBasicBlock [
	^ P4TACBasicBlock new
	
]

{ #category : #helper }
P4TACBuilder >> nextClosureTemp [
	^ temps add: (P4TACClosureTemp named: ('closureTmp', temps size asString)).
]

{ #category : #helper }
P4TACBuilder >> nextTemp [
	^ temps add: (P4TACTemp named: ('tmp', temps size asString)).
]

{ #category : #globals }
P4TACBuilder >> nil [
	^ globals at: #nil
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> or: value with: aVariable [
	currentBasicBlock << (P4TACOr a: value to: aVariable)
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> pHalt [
	currentBasicBlock << P4TACHalt new.
	^ self loadConstant: nil.  
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> pop: register [
	currentBasicBlock << register pop
]

{ #category : #helper }
P4TACBuilder >> postamble [
	^ currentBasicBlock := P4TACBasicBlock number: -1

]

{ #category : #helper }
P4TACBuilder >> preamble [
	^ currentBasicBlock := P4TACBasicBlock number: 0

]

{ #category : #'tac-value-builder' }
P4TACBuilder >> push: register [
	currentBasicBlock << register push
]

{ #category : #'initialize-release' }
P4TACBuilder >> reset [
	literals removeAll.
	instVars removeAll.
	instVarsIdx removeAll.
	locals removeAll.
]

{ #category : #accessing }
P4TACBuilder >> resultVariable: aRegister [
	^ resultVariable := P4TACResultVariable withRegister: aRegister
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> return: value [
	self move: value to: resultVariable.
	currentBasicBlock << P4TACReturn new

]

{ #category : #accessing }
P4TACBuilder >> self [
	^ locals at: #self ifAbsent: selfImport
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> setMethodObject: aCallable [
	method := aCallable methodObject  
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> shortJump: target [
	currentBasicBlock << ((P4TACJump to: target) short)
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> shortJumpCarry: target [
	currentBasicBlock << ((P4TACJump to: target) carry; short)
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> shortJumpEqual: target [
	currentBasicBlock << ((P4TACJump to: target) equals; short)
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> shortJumpNoCarry: target [
	currentBasicBlock << ((P4TACJump to: target) noCarry; short)
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> shortJumpNotEqual: target [
	currentBasicBlock << ((P4TACJump to: target) notEquals; short)
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> tailJump: target [
	currentBasicBlock 
		<< P4TACTeardown new;
		<< (P4TACJump to: target)
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> teardown [
	currentBasicBlock 
		<< P4TACTeardown new
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> teardownToPerform [
	currentBasicBlock 
		<< P4TACTeardown new keepArguments
]

{ #category : #helper }
P4TACBuilder >> temporaryStore: aValue [
	| temp |
	aValue isConstant ifTrue: [ ^ aValue ].
	temp := self nextTemp.
	self move: aValue to: temp.
	^ temp
]

{ #category : #accessing }
P4TACBuilder >> temps: aCollection [
	temps := aCollection
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> test: value with: aVariable [
	currentBasicBlock << (P4TACTest a: value to: aVariable)
]

{ #category : #'tac-value-builder' }
P4TACBuilder >> testBit: num on: aVariable [
	currentBasicBlock << (P4TACBitTest of: num in: aVariable)
]

{ #category : #globals }
P4TACBuilder >> true [
	^ globals at: #true
]

{ #category : #helper }
P4TACBuilder >> untag: target [
	currentBasicBlock << P4TACBitShiftRight new target: target; bits: 1
]

{ #category : #helper }
P4TACBuilder >> useAsNextBasicBlock: aBlock [
	currentBasicBlock ifNotNil: [ 
		^ currentBasicBlock := currentBasicBlock nextBlock: aBlock ].
	aBlock number: 0.
	currentBasicBlock := aBlock 

]

{ #category : #'tac-value-builder' }
P4TACBuilder >> volatileFence [
	currentBasicBlock << P4TACVolatileFence new.

]
