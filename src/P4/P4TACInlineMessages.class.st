Class {
	#name : #P4TACInlineMessages,
	#superclass : #P4Object,
	#instVars : [
		'visitor',
		'builder',
		'receiver',
		'helper'
	],
	#category : #'P4-TAC'
}

{ #category : #'as yet unclassified' }
P4TACInlineMessages class >> doesNotUnderstand [
	^ nil
]

{ #category : #'as yet unclassified' }
P4TACInlineMessages class >> instance [
	instance isNil ifTrue: [ instance := self new ].
	^ instance
]

{ #category : #'control-messages' }
P4TACInlineMessages >> + other [
	| res msg aReceiver blockTmp anOther |
	aReceiver := builder temporaryStore: (receiver acceptVisitor: visitor).
	anOther := other acceptVisitor: visitor.
	res := builder nextTemp.
	aReceiver 
		wrapTypeGuard: {P4SmallInteger asPClass}
		andCondition: {#carry}
		around: [ 
			builder move: aReceiver to: res.
			builder intAdd: anOther to: res.]
		fallback: [ 
			msg := P4TACMessage new selector: #+ ; numOfArguments: 1.
			visitor tacSend: msg to: aReceiver with: {anOther}.
			builder move: helper resultVariable to: res. ]
		with: helper.
	^ res
]

{ #category : #'control-messages' }
P4TACInlineMessages >> - other [
	| res msg aReceiver blockTmp anOther |
	aReceiver := builder temporaryStore: (receiver acceptVisitor: visitor).
	anOther := other acceptVisitor: visitor.
	res := builder nextTemp.
	aReceiver 
		wrapTypeGuard: {P4SmallInteger asPClass}
		andCondition: {#carry}
		around: [ 
			builder move: aReceiver to: res.
			builder intSub: anOther from: res.]
		fallback: [ 
			msg := P4TACMessage new selector: #- ; numOfArguments: 1.
			visitor tacSend: msg to: aReceiver with: {anOther}.
			builder move: helper resultVariable to: res. ]
		with: helper.
	^ res
]

{ #category : #'control-messages' }
P4TACInlineMessages >> == other [
	| nextBlock resultValue left right temp trueBlock |

	left := receiver acceptVisitor: visitor.
	right := other acceptVisitor: visitor.
	temp := builder nextTemp.
	builder move: right to: temp.
	
	trueBlock := builder nextBasicBlock.
	nextBlock := builder nextBasicBlock.
	resultValue := builder nextTemp.
	
	builder compare: left to: temp.
	builder jumpEqual: trueBlock.
	builder move: builder false to: resultValue.
	builder jump: nextBlock.
		
	builder useAsNextBasicBlock: trueBlock.  
	builder move: builder true to: resultValue.

	builder useAsNextBasicBlock: nextBlock.	
	^ resultValue 
]

{ #category : #convenience }
P4TACInlineMessages >> block: block condition: aCondition receiver: aReceiver equal: testEquals result: resultValue [
	| nextBlock |

	builder move: builder nil to: resultValue.

	builder compare: aCondition to: aReceiver.
		
	nextBlock := builder nextBasicBlock.
	testEquals 
		ifTrue: [ builder jumpNotEqual: nextBlock. ]
		ifFalse: [ builder jumpEqual: nextBlock. ].

	visitor visitInlinedBlock: block returnTo: resultValue.
	
	builder useAsNextBasicBlock: nextBlock.
]

{ #category : #convenience }
P4TACInlineMessages >> block: block condition: aCondition receiver: aReceiver result: resultValue [
	^self block: block condition: aCondition receiver: aReceiver equal: true result: resultValue
]

{ #category : #accessing }
P4TACInlineMessages >> builder: aBuilder [
	builder := aBuilder .
]

{ #category : #convenience }
P4TACInlineMessages >> checkReturns: aBasicBlock to: aVariable [
	aBasicBlock isEmpty 
		ifTrue: [ builder move: builder nil to: aVariable ]
		ifFalse: [ builder move: aBasicBlock lastElement asValue to: aVariable ].

]

{ #category : #accessing }
P4TACInlineMessages >> helper: aHelper [
	helper := aHelper 
]

{ #category : #'control-messages' }
P4TACInlineMessages >> ifFalse: block [
	| aReceiver nextBlock fallbackBlock resultValue testBlock msg aBlock |
	aReceiver := builder temporaryStore: (receiver acceptVisitor: visitor).
	resultValue := builder nextTemp.
	builder move: builder nil to: resultValue.
	
	nextBlock := builder nextBasicBlock.
	testBlock := builder nextBasicBlock.
	fallbackBlock := builder nextBasicBlock.

	builder compare: builder false to: aReceiver.
	builder jumpNotEqual: testBlock.

	visitor visitInlinedBlock: block returnTo: resultValue.
	builder shortJump: nextBlock.
	
	builder useAsNextBasicBlock: testBlock.    
	builder compare: builder true to: aReceiver.   
	builder shortJumpNotEqual: fallbackBlock.
	builder shortJump: nextBlock.
	  
	builder useAsNextBasicBlock: fallbackBlock.    
	msg := P4TACMessage new selector: #ifFalse: ; numOfArguments: 1.
	aBlock := block acceptVisitor: visitor.
	visitor tacSend: msg to: aReceiver with: { aBlock }.
	builder move: helper resultVariable to: resultValue.
	
	builder useAsNextBasicBlock: nextBlock.
	
	^ resultValue
]

{ #category : #'control-messages' }
P4TACInlineMessages >> ifFalse: falseBlock ifTrue: trueBlock [
	| trueBasicBlock nextBasicBlock result value fallbackBasicBlock msg trueArg falseArg |
	value := builder temporaryStore: (receiver accept: visitor).
	
	trueBasicBlock := builder nextBasicBlock.  
	fallbackBasicBlock := builder nextBasicBlock.
	nextBasicBlock := builder nextBasicBlock.

	result := builder nextTemp .
	
	builder compare: builder true to: value.
	builder jumpEqual: trueBasicBlock.
	builder compare: builder false to: value.
	builder jumpNotEqual: fallbackBasicBlock.
	
	visitor visitInlinedBlock: falseBlock returnTo: result .
	builder jump: nextBasicBlock.
		
	builder useAsNextBasicBlock: trueBasicBlock.
	visitor visitInlinedBlock: trueBlock returnTo: result.
	builder jump: nextBasicBlock.
	
	builder useAsNextBasicBlock: fallbackBasicBlock.
	msg := P4TACMessage new selector: #ifFalse:ifTrue: ; numOfArguments: 2.
	falseArg := builder temporaryStore: (falseBlock accept: visitor).
	trueArg := trueBlock accept: visitor.
	visitor tacSend: msg to: value with: { falseArg. trueArg }.
	builder move: helper resultVariable to: result.

	builder useAsNextBasicBlock: nextBasicBlock.
	^ result 
]

{ #category : #'control-messages' }
P4TACInlineMessages >> ifNil: block [
	| aReceiver res |
	aReceiver := receiver acceptVisitor: visitor.
	res := builder nextTemp.
	self block: block condition: builder nil receiver: aReceiver result: res.
	^ res.
]

{ #category : #'control-messages' }
P4TACInlineMessages >> ifNil: block ifNotNil: notblock [
	| receiverTemp evaluatedReceiverTemp notNilBlock nilBlock nextBlock ret |
	notblock arguments 
		ifNotEmpty: [
			receiverTemp := builder declare: notblock arguments first name.
			evaluatedReceiverTemp := receiver acceptVisitor: visitor.
			builder move: evaluatedReceiverTemp to: receiverTemp]
		ifEmpty: [
			receiverTemp := receiver acceptVisitor: visitor].
		
	notNilBlock := builder nextBasicBlock.
	nilBlock := builder nextBasicBlock.
	nextBlock := builder nextBasicBlock.
	ret := builder nextTemp.
	builder move: builder nil to: ret.
		
	builder compare: builder nil to: receiverTemp.
	builder jumpEqual: nilBlock.
	
	builder useAsNextBasicBlock: notNilBlock.
	visitor visitInlinedBlock: notblock returnTo: ret.
	builder jump: nextBlock.
	
	builder useAsNextBasicBlock: nilBlock.
	visitor visitInlinedBlock: block returnTo: ret.
	
	builder useAsNextBasicBlock: nextBlock.  
	^ ret
]

{ #category : #'control-messages' }
P4TACInlineMessages >> ifNotNil: block [
	| receiverTemp evaluatedReceiverTemp res |
	evaluatedReceiverTemp := receiver acceptVisitor: visitor.
	block arguments ifNotEmpty: [
		receiverTemp := builder declare: block arguments first name.
		builder move: evaluatedReceiverTemp to: receiverTemp ] .
	res := builder nextTemp.
	self block: block condition: builder nil receiver: evaluatedReceiverTemp equal: false result: res.
	^ res
]

{ #category : #'control-messages' }
P4TACInlineMessages >> ifNotNil: notblock ifNil: block [
	^ self ifNil: block ifNotNil: notblock
	

]

{ #category : #'control-messages' }
P4TACInlineMessages >> ifTrue: block [
	| aReceiver nextBlock fallbackBlock resultValue testBlock msg aBlock |
	aReceiver := builder temporaryStore: (receiver acceptVisitor: visitor).
	resultValue := builder nextTemp.
	builder move: builder nil to: resultValue.
	
	nextBlock := builder nextBasicBlock.
	testBlock := builder nextBasicBlock.
	fallbackBlock := builder nextBasicBlock.

	builder compare: builder true to: aReceiver.
	builder jumpNotEqual: testBlock.

	visitor visitInlinedBlock: block returnTo: resultValue.
	builder shortJump: nextBlock.
	
	builder useAsNextBasicBlock: testBlock.    
	builder compare: builder false to: aReceiver.   
	builder shortJumpNotEqual: fallbackBlock.
	builder shortJump: nextBlock.
	  
	builder useAsNextBasicBlock: fallbackBlock.
	msg := P4TACMessage new selector: #ifTrue: ; numOfArguments: 1.
	aBlock := block acceptVisitor: visitor.
	visitor tacSend: msg to: aReceiver with: { aBlock }.
	builder move: helper resultVariable to: resultValue.
	
	builder useAsNextBasicBlock: nextBlock.
	
	^ resultValue
]

{ #category : #'control-messages' }
P4TACInlineMessages >> ifTrue: trueBlock ifFalse: falseBlock [
	| falseBasicBlock nextBasicBlock result value fallbackBasicBlock msg trueArg falseArg |
	value := builder temporaryStore: (receiver acceptVisitor: visitor).
	
	falseBasicBlock := builder nextBasicBlock.  
	fallbackBasicBlock := builder nextBasicBlock.
	nextBasicBlock := builder nextBasicBlock.

	result := builder nextTemp .
	
	builder compare: builder false to: value.
	builder jumpEqual: falseBasicBlock.
	builder compare: builder true to: value.
	builder jumpNotEqual: fallbackBasicBlock.
	
	visitor visitInlinedBlock: trueBlock returnTo: result .
	builder jump: nextBasicBlock.
		
	builder useAsNextBasicBlock: falseBasicBlock.
	visitor visitInlinedBlock: falseBlock returnTo: result.
	builder jump: nextBasicBlock.
	
	builder useAsNextBasicBlock: fallbackBasicBlock.
	msg := P4TACMessage new selector: #ifTrue:ifFalse: ; numOfArguments: 2.
	trueArg := builder temporaryStore: (trueBlock acceptVisitor: visitor).
	falseArg := falseBlock acceptVisitor: visitor.
	visitor tacSend: msg to: value with: { trueArg. falseArg }.
	builder move: helper resultVariable to: result.

	builder useAsNextBasicBlock: nextBasicBlock .  	
	^ result 
]

{ #category : #accessing }
P4TACInlineMessages >> implements: aSelector [
	| method |
	method := self class methodDictionary at: aSelector ifAbsent: [ ^ false ].
	^ method category == #'control-messages'

]

{ #category : #convenience }
P4TACInlineMessages >> methodObject: aMethod perform: selector [
	| msg aSelector numArgs |

	numArgs := builder nextTemp.
	aSelector := selector acceptVisitor: visitor.
	msg := P4TACMessage new selector: #countArgs; numOfArguments: 0.
	visitor tacSend: msg to: aSelector with: {}.
	builder move: helper resultVariable to: numArgs.
	
	msg := P4TACMessage new selector: #basicNew:; numOfArguments: 1.
	visitor tacSend: msg to: (builder loadConstant: Array asPClass) with: { numArgs }.
	
	builder move: helper resultVariable to: (helper arg:4 of:4).
	builder move: aSelector to: (helper arg:2 of:4).
	builder move: aMethod to: (helper arg:1 of:4).
	builder move: (builder loadConstant: #perform:on:with:) to: helper resultVariable.
	builder move: numArgs to: helper intermediateLValue.
	
	builder teardownToPerform.
	builder move: (helper stackPointer accessAt: 0) to: (helper arg:3 of:4).
	builder jump: #'wrap_and_call'
]

{ #category : #'control-messages' }
P4TACInlineMessages >> pHalt [
	^ builder pHalt
]

{ #category : #'control-messages' }
P4TACInlineMessages >> perform: selector andCacheOn: object [  
	| aMethod anObject msg |
	aMethod := builder temporaryStore: (receiver acceptVisitor: visitor).
	anObject := object acceptVisitor: visitor.
	aMethod 
		wrapTypeGuard: {P4Method asPClass}
		around: [
			builder move: (aMethod accessAt: 0) to: helper intermediateLValue.
			builder untag: helper intermediateLValue.
			builder bitShift: helper intermediateLValue by: 3.
			builder add: aMethod to: helper intermediateLValue.
			builder move: anObject to: (helper arg: 1 of: 1).
			builder directCallSkipTypeCheck: (P4Object earlySelectorAddress: #behavior) on: P4Object asPClass.
			builder 	tailJump: 'inline_cache_and_call' asSymbol .]
		fallback: [
			self methodObject: aMethod perform: selector ]
		with: helper.
	^ aMethod
]

{ #category : #'control-messages' }
P4TACInlineMessages >> perform: selector on: object [  
	| aMethod anObject |
	aMethod := builder temporaryStore: (receiver acceptVisitor: visitor).
	anObject := object acceptVisitor: visitor.
	aMethod 
		wrapTypeGuard: {P4Method asPClass}
		around: [
			builder move: (aMethod accessAt: 0) to: helper intermediateLValue.
			builder untag: helper intermediateLValue.
			builder bitShift: helper intermediateLValue by: 3.
			builder add: aMethod to: helper intermediateLValue.
			builder move: anObject to: (helper arg: 1 of: 1).
			builder directCallSkipTypeCheck: (P4Object earlySelectorAddress: #behavior) on: P4Object asPClass.
			builder 	indirectTailJump: helper intermediateLValue.]
		fallback: [
			self methodObject: aMethod perform: selector ]
		with: helper.
	^ aMethod
]

{ #category : #'control-messages' }
P4TACInlineMessages >> perform: selector on: object with: arguments [
	| aMethod anObject theArgs aSelector msg |
	aMethod := builder temporaryStore: (receiver acceptVisitor: visitor).
	aSelector := builder temporaryStore: (selector acceptVisitor: visitor).
	anObject := builder temporaryStore: (object acceptVisitor: visitor).
	theArgs := arguments acceptVisitor: visitor.  
	aMethod 
		wrapTypeGuard: {P4Method asPClass}
		around: [
			builder move: (aMethod accessAt: 0) to: helper intermediateLValue.
			builder untag: helper intermediateLValue.
			builder bitShift: helper intermediateLValue by: 3.
			builder add: aMethod to: helper intermediateLValue.
			builder move: anObject to: (helper arg: 1 of: 1).
			builder directCallSkipTypeCheck: (P4Object earlySelectorAddress: #behavior) on: P4Object asPClass.
			builder move: theArgs to: (helper intermediate).
			builder directCall: #'unwrap'.
			builder 	indirectTailJump: helper intermediateLValue.]
		fallback: [
			msg := P4TACMessage new selector: #perform:on:with:; numOfArguments: 3.
			visitor tacSend: msg to: aMethod with: { aSelector. anObject. theArgs }. ]
		with: helper.
	^ aMethod
]

{ #category : #facade }
P4TACInlineMessages >> send: aMessage to: aReceiver with: theArguments for: aVisitor [
	receiver := aReceiver.
	visitor := aVisitor.
	^ self perform: aMessage selector withArguments: theArguments asArray.

]

{ #category : #convenience }
P4TACInlineMessages >> sendValue: msg to: aReceiver [
	
	aReceiver 
		wrapTypeGuard: {P4Closure asPClass}
		around: [ 
			builder move: (aReceiver accessAt: 0) to: helper intermediate.
			builder indirectCall: helper intermediate]
		fallback: [ 
			helper invoke: msg for: aReceiver with: {}]
		with: helper.
		
	^ helper resultVariable.
]

{ #category : #'control-messages' }
P4TACInlineMessages >> to: end by: step do: aBlock [
	| startValue endValue stepValue resultValue currentValue bodyBlock nextBlock res plus smaller msg currentValueName |
	startValue := builder temporaryStore: (receiver acceptVisitor: visitor).
	endValue := builder temporaryStore: (end acceptVisitor: visitor).
	stepValue := builder temporaryStore: (step acceptVisitor: visitor).
	
	plus := P4TACMessage new selector: #+ ; numOfArguments: 1.
	smaller := P4TACMessage new selector: #<= ; numOfArguments: 1.
	resultValue := builder nextTemp.
	
	startValue
		wrapTypeGuard: {P4SmallInteger asPClass } 
		around: [
			builder move: builder nil to: resultValue.
			currentValueName := aBlock arguments ifEmpty: [ #index ] ifNotEmpty: [ aBlock arguments first name ].
			currentValue := builder declare: currentValueName.
			builder move: startValue to: currentValue.
	
			bodyBlock := builder nextBasicBlock.
			nextBlock := builder nextBasicBlock.

			builder useAsNextBasicBlock: bodyBlock.
			res := visitor tacSend: smaller to: currentValue with: {endValue}.
			builder compare: builder true to: res.
			builder jumpNotEqual: nextBlock.  
		
			visitor visitInlinedBlock: aBlock returnTo: resultValue.
			res := visitor tacSend: plus to: currentValue with: {stepValue}.
			builder move: res to: currentValue.
			builder jump: bodyBlock.
	
			builder useAsNextBasicBlock: nextBlock.]
		fallback: [
			msg := P4TACMessage new selector: #to:by:do: ; numOfArguments: 3.
			visitor tacSend: msg to: startValue with: {stepValue . endValue }.
			builder move: helper resultVariable to: resultValue.]
		with: helper.
	^ resultValue
]

{ #category : #'control-messages' }
P4TACInlineMessages >> value [
	| msg aReceiver |
	aReceiver := receiver acceptVisitor: visitor.
	builder volatileFence.
	
	msg := P4TACMessage new selector: #value; numOfArguments: 0.
	helper loadArguments: {} andReceiver: aReceiver toSend: msg selector.
	
	^ self sendValue: msg to: aReceiver
]

{ #category : #'control-messages' }
P4TACInlineMessages >> value: arg [
	| msg aReceiver anArg |
	aReceiver := builder temporaryStore: (receiver acceptVisitor: visitor).
	anArg := arg acceptVisitor: visitor.  
	builder volatileFence.
	
	msg := P4TACMessage new selector: #value:; numOfArguments: 1.
	helper loadArguments: {anArg} andReceiver: aReceiver toSend: msg selector.

	^ self sendValue: msg to: aReceiver
]

{ #category : #'control-messages' }
P4TACInlineMessages >> value: arg1 value: arg2 [
	| msg aReceiver anArg1 anArg2 |
	aReceiver := builder temporaryStore: (receiver acceptVisitor: visitor).
	anArg1 := builder temporaryStore: (arg1 acceptVisitor: visitor).
	anArg2 := arg2 acceptVisitor: visitor.  
	builder volatileFence.
	
	msg := P4TACMessage new selector: #value:value:; numOfArguments: 2.
	helper loadArguments: {anArg1. anArg2} andReceiver: aReceiver toSend: msg selector.

	^ self sendValue: msg to: aReceiver
]

{ #category : #'control-messages' }
P4TACInlineMessages >> value: arg1 value: arg2 value: arg3 [
	| msg aReceiver anArg1 anArg2 anArg3 |
	aReceiver := builder temporaryStore: (receiver accept: visitor).
	anArg1 := builder temporaryStore: (arg1 accept: visitor).
	anArg2 := builder temporaryStore: (arg2 accept: visitor).
	anArg3 := arg3 accept: visitor.  
	builder volatileFence.
	
	msg := P4TACMessage new selector: #value:value:value:; numOfArguments: 3.
	helper loadArguments: {anArg1. anArg2. anArg3} andReceiver: aReceiver toSend: msg selector.

	^ self sendValue: msg to: aReceiver
]

{ #category : #'control-messages' }
P4TACInlineMessages >> value: arg1 value: arg2 value: arg3 value: arg4 [
	| msg aReceiver anArg1 anArg2 anArg3 anArg4 |
	aReceiver := builder temporaryStore: (receiver acceptVisitor: visitor).
	anArg1 := builder temporaryStore: (arg1 acceptVisitor: visitor).
	anArg2 := builder temporaryStore: (arg2 acceptVisitor: visitor).
	anArg3 := builder temporaryStore: (arg3 acceptVisitor: visitor).
	anArg4 := arg4 acceptVisitor: visitor.  
	builder volatileFence.
	
	msg := P4TACMessage new selector: #value:value:value:value:; numOfArguments: 4.
	helper loadArguments: {anArg1. anArg2. anArg3. anArg4} andReceiver: aReceiver toSend: msg selector.

	^ self sendValue: msg to: aReceiver
]

{ #category : #accessing }
P4TACInlineMessages >> visitor [
	^ visitor
]

{ #category : #accessing }
P4TACInlineMessages >> visitor: anObject [
	visitor := anObject.
]

{ #category : #convenience }
P4TACInlineMessages >> while: block condition: aCondition [
	| whileBasicBlock nextBasicBlock checkResult result checkBlock |
	checkBlock := receiver.	
	whileBasicBlock := builder nextBasicBlock.  
	nextBasicBlock := builder nextBasicBlock.	
	builder useAsNextBasicBlock: whileBasicBlock.  

	checkResult := builder nextTemp.
	visitor visitInlinedBlock: checkBlock returnTo: checkResult.
	builder compare: aCondition to: checkResult.
	builder jumpNotEqual: nextBasicBlock.
	
	result := builder nextTemp.
	visitor visitInlinedBlock: block returnTo: result.
	builder jump: whileBasicBlock.  

	builder useAsNextBasicBlock: nextBasicBlock.
	^ result
]

{ #category : #'control-messages' }
P4TACInlineMessages >> whileFalse: block [
	^ self while: block condition: builder false
]

{ #category : #'control-messages' }
P4TACInlineMessages >> whileTrue: block [
	^ self while: block condition: builder true
]
