Class {
	#name : #P4A2THelper,
	#superclass : #P4Object,
	#instVars : [
		'builder',
		'processor',
		'methodCompiler',
		'resultVariable',
		'groundTypes',
		'inlinedMethods'
	],
	#category : #'P4-TAC'
}

{ #category : #convenience }
P4A2THelper >> annotation: anAnnotation [
]

{ #category : #arguments }
P4A2THelper >> arg: num of: total [
	^ (P4TACArgument withRegister: (processor callRegister: num of: total)) name: 'arg', num asString
]

{ #category : #accessing }
P4A2THelper >> builder: aBuilder [
	builder := aBuilder.
	resultVariable := builder resultVariable: processor resultVariable.
	inlinedMethods builder: builder.
]

{ #category : #convenience }
P4A2THelper >> currentHost: aMethod [  
]

{ #category : #optimizations }
P4A2THelper >> implements: aSelector [
	^ inlinedMethods implements: aSelector
]

{ #category : #'initialize-release' }
P4A2THelper >> initialize [
	groundTypes := false.
	inlinedMethods := P4TACInlineMessages new
							builder: builder;
							helper: self.
]

{ #category : #typeChecking }
P4A2THelper >> inlineCacheHitCheck: method [
	| invokeBlock |
	invokeBlock := builder nextBasicBlock.
	method invokeBlock: invokeBlock.  
	^ self 
		inlineCacheHitCheck: method host 
		for: (self arg: 1 of: methodCompiler numArgs) 
		fallbackLabel: invokeBlock
]

{ #category : #typeChecking }
P4A2THelper >> inlineCacheHitCheck: host for: receiver fallbackLabel: invokeBlock [
	| endBlock taggedBlock phost |
	
	phost := host inPharo.
	
	builder testBit: 0 on: receiver.
	
	phost == P4SmallInteger  
		ifTrue: [ ^ builder jumpNoCarry: invokeBlock].
			
	(P4SmallInteger inheritsFrom: phost) 
		ifTrue: [
			taggedBlock := builder nextBasicBlock.
			endBlock := builder nextBasicBlock.

			builder shortJumpCarry: taggedBlock.
	
			builder 
				compare: (receiver accessClass)
				to: self typeVariable.
			builder jumpNotEqual: invokeBlock.
			builder shortJump: endBlock.  

			builder useAsNextBasicBlock: taggedBlock.
			builder
				compare: (P4TACExternalReference target: P4SmallInteger asPClass theBehavior)
				to: self typeVariable.
			builder jumpNotEqual: invokeBlock.

			^ builder useAsNextBasicBlock: endBlock. ].

		builder jumpCarry: invokeBlock.
		builder 
			compare: (receiver accessClass)
			to: self typeVariable.
		builder jumpNotEqual: invokeBlock.		  
		
		

]

{ #category : #typeChecking }
P4A2THelper >> insertCondition: consitions fallback: aFallback [
	self insertCondition: consitions fallback: aFallback block: builder nextBasicBlock.
]

{ #category : #typeChecking }
P4A2THelper >> insertCondition: conditions fallback: aFallback block: fallbackBlock [
	| endBlock |
	endBlock := builder nextBasicBlock.
	
	(conditions includes: #carry) 
		ifTrue: [ builder shortJumpCarry: fallbackBlock ].  
	
	self flag: 'we just assume that the fallback will not be more than a small jump away. this should be the case since the fallback will normally just call a function'.
	builder shortJump: endBlock.
	
	builder useAsNextBasicBlock: fallbackBlock.
	aFallback value.
	
	builder useAsNextBasicBlock: endBlock.
]

{ #category : #'as yet unclassified' }
P4A2THelper >> insertMethodPreamble: method [
	self inlineCacheHitCheck: method
]

{ #category : #'as yet unclassified' }
P4A2THelper >> insertPopArguments [
]

{ #category : #typeChecking }
P4A2THelper >> insertTypeGuard: types andCondition: conditions for: receiver around: aBlock fallback: aFallback [
	| nextBlock codeBlock fallbackBlock type |
	
	builder volatileFence.
	codeBlock := builder nextBasicBlock.
	fallbackBlock := builder nextBasicBlock.
	
	1 to: (types size - 1) do: [ :i |
		type := types at: i.
		nextBlock := builder nextBasicBlock.
		type inPharo ~~ P4SmallInteger 
			ifTrue: [ builder move: (builder loadConstant: type theBehavior) to: self typeVariable ].
		self inlineCacheHitCheck: type for: receiver fallbackLabel: nextBlock.
		builder shortJump: codeBlock.  
		builder useAsNextBasicBlock: nextBlock].
	
	type := types at: types size.
	
	type inPharo ~~ P4SmallInteger 
		ifTrue: [ builder move: (builder loadConstant: type theBehavior) to: self typeVariable ].
	self inlineCacheHitCheck: type for: receiver fallbackLabel: fallbackBlock.
	
	builder useAsNextBasicBlock: codeBlock.  
	aBlock value.
	
	self insertCondition: conditions fallback: aFallback block: fallbackBlock.
]

{ #category : #arguments }
P4A2THelper >> intermediate [
	^ (P4TACFixedVariable withRegister: (processor intermediateRegisters at: 2)) name: #intermediate
]

{ #category : #arguments }
P4A2THelper >> intermediateLValue [
	^ (P4TACFixedVariable withRegister: (processor intermediateRegisters at: 1)) name: #intermediateLValue
]

{ #category : #convenience }
P4A2THelper >> invoke: message for: receiver with: arguments [
	"load selector"
	builder move: (builder loadConstant: message selector) to: self selectorVariable.
	builder invoke: message numOfArguments.

]

{ #category : #visitor }
P4A2THelper >> invokeBlockFor: method [
	method invokeBlock 
		<< ((builder loadConstant: method selector ) moveTo: self resultVariable);
		<< (P4TACJump to: (P4Object earlySelectorAddress: #invoke:)).
]

{ #category : #convenience }
P4A2THelper >> loadArguments: arguments andReceiver: receiver toSend: message [
	| nativeArgsize |
	"the first argument is the receiver -> nativeArgsize := args + 1"
	nativeArgsize := arguments size + 1.
	
	builder move: receiver to: ( self arg: 1 of: nativeArgsize ).

	arguments withIndexDo: [ :arg :index |
		builder
			move: arg
			to: (self arg: index + 1 of: nativeArgsize) ].
	
]

{ #category : #convenience }
P4A2THelper >> loadMethodArguments: parameters [
	| theSelf numOfArgs aLocal i |

	"arg 1 is the caller class"
	
	numOfArgs := parameters size + 1.
	
	theSelf := builder local: #self.  
	builder move: ( self arg: 1 of: numOfArgs ) to: theSelf.
	i := 0.
	parameters do: [ :arg |
		aLocal := builder declare: arg name.
		i := i + 1.
		builder move: ( self arg: i + 1 of: numOfArgs ) to: aLocal ]. 
	
	builder volatileFence
]

{ #category : #accessing }
P4A2THelper >> methodCompiler: anObject [
	methodCompiler := anObject
]

{ #category : #convenience }
P4A2THelper >> methodReturn: aReturnExpression [
	| ret |
	ret := aReturnExpression value acceptVisitor: methodCompiler.
	builder return: ret.
	^ ret
]

{ #category : #accessing }
P4A2THelper >> processor: anObject [
	processor := anObject
]

{ #category : #accessing }
P4A2THelper >> resultVariable [
	^ resultVariable
]

{ #category : #accessing }
P4A2THelper >> selectorVariable [
	^ resultVariable 
]

{ #category : #optimizations }
P4A2THelper >> send: aMessage to: aReceiver with: theArguments for: aVisitor [
	^ inlinedMethods send: aMessage to: aReceiver with: theArguments for: aVisitor
]

{ #category : #arguments }
P4A2THelper >> stackPointer [ 
	^ (P4TACFixedVariable withRegister: (processor stackPointer)) name: #stack
]

{ #category : #accessing }
P4A2THelper >> typeVariable [
	^ resultVariable
]

{ #category : #convenience }
P4A2THelper >> unrollPrimitiveFor: callable [ 
	| code |
	callable isPrimitive ifFalse: [^self].
	code := callable primitiveCalling.
	code positionAtBeginning.
	builder 
		directCall: callable primitive;
		compare: (P4TACConstant with: 0) to: self resultVariable;
		jumpEqual: callable entry;
		return: self resultVariable 
]
