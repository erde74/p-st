Class {
	#name : #P4TACLivenessAnalysis,
	#superclass : #P4Object,
	#instVars : [
		'position',
		'callable'
	],
	#category : #'P4-TAC'
}

{ #category : #private }
P4TACLivenessAnalysis >> removeInstructionsOf: aMethod [
	| toRemove currentBasicBlock |
	currentBasicBlock := aMethod preamble.
	[ currentBasicBlock atEnd ] whileFalse: [
		currentBasicBlock do: [ :instruction |
			instruction isAssignment ifTrue: [
				(instruction target isUnused) ifTrue: [
					currentBasicBlock remove: instruction ]]].
		currentBasicBlock := currentBasicBlock nextBlock. ].

]

{ #category : #accessing }
P4TACLivenessAnalysis >> runOn: aTACNode [
	aTACNode accept: self
	
]

{ #category : #exceptionbuilder }
P4TACLivenessAnalysis >> tag: aTAC [
	position := position +1.
	aTAC flowNumber: position .  
	  
]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitAdd: anAdd [
	self visitOperation: anAdd
]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitAnd: anAnd [
	self visitOperation: anAnd
]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitAssignment: anAssignment [
	self tag: anAssignment .
	anAssignment target assignedAt: position.
	anAssignment origin usedAt: position.  
	  
]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitBasicBlock: aBasicBlock [
	aBasicBlock do: [ :s | s accept: self ]. 	
]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitBitShift: aBitShift [
	self tag: aBitShift.
	aBitShift target usedAt: position.

]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitBitShiftRight: aBitShift [
	self tag: aBitShift.
	aBitShift target usedAt: position.

]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitBitTest: aBitTest [
	self tag: aBitTest.
	aBitTest location usedAt: position.

]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitCall: aCall [
	self tag: aCall.

]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitCallable: aCallable [
	position := 0.
	callable := aCallable.
	callable basicBlocksDo: [ :b | b accept: self ] .
	self removeInstructionsOf: aCallable.

]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitCaptureClosure: capture [
	self tag: capture.
	capture resultVariable assignedAt: position.  
	capture closure imports do: [ :aVariable | 
		aVariable usedAt: position+1 ].
	capture containsReturn ifTrue: [
		callable basePointer usedAt: position+1 ]  

]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitClosure: aClosure [
	self visitCallable: aClosure
]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitCompare: aComparison [
	self visitOperation: aComparison
]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitCompareEqual: aComparison [
	self visitCompare: aComparison   	
	  
]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitCompareNotEqual: aComparison [
	self visitCompare: aComparison   	
	  
]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitConditionalJump: aJump [
	self tag: aJump
]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitEndBlock: aEndBlock [

]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitHalt: aHalt [
  	self tag: aHalt
]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitIndirectCall: aCall [
	self tag: aCall.

]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitIndirectJump: anIndirectJump [
	self tag: anIndirectJump.
	anIndirectJump register usedAt: position
	

]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitJump: aJump [
	| startPos |
	self tag: aJump.
	aJump target isSymbol ifTrue: [^self].
	startPos := aJump target firstElement flowNumber.
	"startPos was already tagged -> backJump"
	startPos ifNotNil: [
		{callable locals. callable temps} do: 
			[ :vars | vars do: [ :var |
				(var isUsed and: [var lastUse >= startPos]) ifTrue: [
					var usedAt: position ]]]].

]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitMethod: aMethod [
	self visitCallable: aMethod.
	
	aMethod closures do: [ :closure |
		closure accept: self ]

]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitOperation: anOperation [
	self tag: anOperation.
	anOperation left usedAt: position.
	anOperation right usedAt: position.
]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitOr: anOr [
	self visitOperation: anOr
]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitPop: aReg [
]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitPush: aReg [
]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitReturn: aReturn [
	self tag: aReturn
]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitSub: aSub [
	self visitOperation: aSub
]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitTeardown: aReturn [
	self tag: aReturn
]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitTest: aTest [
	self visitOperation: aTest
]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitVolatileFence: volatileFence [
	self tag: volatileFence.
	callable temps do: [ :t | t methodCalled: position ].
	callable locals do: [ :v | v methodCalled: position ].

]

{ #category : #visiting }
P4TACLivenessAnalysis >> visitXor: anOr [
	self visitOperation: anOr
]
