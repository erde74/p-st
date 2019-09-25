Class {
	#name : #P4Object,
	#superclass : #Object,
	#classInstVars : [
		'pname'
	],
	#category : #'P4-Kernel-Object'
}

{ #category : #accessing }
P4Object class >> earlyClassSelectorAddress: aSelector [
	| method |
	method := self pclass pLookupSelector: aSelector.
	^ method earlySelectorAddress.
]

{ #category : #accessing }
P4Object class >> earlySelectorAddress: aSelector [
	"copy in Metaclass"
	| method |
	method := self pLookupSelector: aSelector.
	^ method earlySelectorAddress.
]

{ #category : #accessing }
P4Object class >> flush [
	pname := nil
]

{ #category : #exporting }
P4Object class >> identityHash [
	<preventExport>
	^ super identityHash >> 18
]

{ #category : #exporting }
P4Object class >> mapToPclass [
	^ self
]

{ #category : #accessing }
P4Object class >> p4class [
	^ self class
]

{ #category : #accessing }
P4Object class >> p4super [
	P4Object == self ifTrue: [ ^ nil ].
	^ self superclass
]

{ #category : #exporting }
P4Object class >> pExportedName [ 
	^ nil
]

{ #category : #accessing }
P4Object class >> pHalt [
	<preventExport>
]

{ #category : #accessing }
P4Object class >> pInstanceHeader [
	| base variable bytes hash |
	base := self pInstSize.
	variable := self pIsVariable ifTrue: [ 1 ] ifFalse: [ 0 ].
	bytes := self pIsBytes ifTrue: [ 1 ] ifFalse: [ 0 ].
	^ (bytes bitShift: 9) + (variable bitShift: 8) + base
]

{ #category : #accessing }
P4Object class >> pfullName [
	^ (P4Package packageOfClass: self) relativeNameFor: self pname
]

{ #category : #accessing }
P4Object class >> pname [
	<preventExport>
	^ pname ifNil: [ pname := (self name copyFrom: 'P4' size + 1 to: self name size) asSymbol ]
]

{ #category : #testing }
P4Object class >> typeCheckByteSize [
	<preventExport>
	(P4SmallInteger inheritsFrom: self) ifTrue: [ ^ 30 ].
	^ 20
]

{ #category : #testing }
P4Object >> = other [
	<globalName: #equality>
	^ (self == other)
]

{ #category : #testing }
P4Object >> == other [
	" Implemented in the compiler "
	^ self == other
]

{ #category : #accessing }
P4Object >> at: key [
	<pprimitive: #basicAt>
	^ self basicAt: key  
]

{ #category : #accessing }
P4Object >> at: key put: object [
	<pprimitive: #basicAtPut>
	^ self basicAt: key put: object
]

{ #category : #accessing }
P4Object >> basicAt: key [
	<preventExport>
	^ super basicAt: key
]

{ #category : #accessing }
P4Object >> basicAt: key put: object [
	<preventExport>
	^ super basicAt: key put: object
]

{ #category : #'class hierarchy' }
P4Object >> behavior [
	<pprimitive: #behavior> 
	self pHalt.
]

{ #category : #'class hierarchy' }
P4Object >> behavior: aBehavior [
	<pprimitive: #'set_behavior'> 
	self pHalt.
]

{ #category : #'class hierarchy' }
P4Object >> class [
	<preventExport>
	^super class
]

{ #category : #'message handling' }
P4Object >> doesNotUnderstand: selector [
	<preventExport>
	^ super doesNotUnderstand: selector  
]

{ #category : #spec }
P4Object >> error: string [
	string print.
	self pHalt.
]

{ #category : #spec }
P4Object >> expectationFail: got expected: expected [
	'expectation not met. got:' print.
	got printObj.
	'but expected:' print.
	expected printObj.
	self pHalt.
]

{ #category : #spec }
P4Object >> flag: flag [
]

{ #category : #'message handling' }
P4Object >> groundedInvoke: selector [
	<invoke>
	<globalName: #groundedInvoke>	
	<groundTypes>
	<fixedType: 	#self             		as: #'Kernel.Object.Object'>
	<typeHint: 	#behavior        		as: #'Kernel.Behavior.SmalltalkBehavior'>

	| behavior class method |
	behavior := self behavior.
	method := (behavior lookup: selector for: self).
	^ method perform: selector on: self.
]

{ #category : #accessing }
P4Object >> identityHash [
	<preventExport>
	^ super identityHash >> 18
]

{ #category : #testing }
P4Object >> ifFalse: aBlock [
]

{ #category : #testing }
P4Object >> ifFalse: aFalseBlock ifTrue: aBlock [ 
	^aBlock value
]

{ #category : #testing }
P4Object >> ifNil: aBlock [
	^ aBlock value
]

{ #category : #testing }
P4Object >> ifNil: aBlock ifNotNil: anOtherBlock [
	^ anOtherBlock value
]

{ #category : #testing }
P4Object >> ifTrue: aBlock [
	^aBlock value
]

{ #category : #testing }
P4Object >> ifTrue: aBlock ifFalse: aFalseBlock [
	^aBlock value
]

{ #category : #'initialize-release' }
P4Object >> initialize [
	<preventExport>
	^super initialize
]

{ #category : #'message handling' }
P4Object >> invoke: selector [
	<invoke>
	<globalName: #invoke>	
	<groundTypes>
	<fixedType: 	#self             		as: #'Kernel.Object.Object'>
	<typeHint: 	#behavior        		as: #'Kernel.Behavior.SmalltalkBehavior'>

	| behavior class method |
	behavior := self behavior.
	method := (behavior lookup: selector for: self).
	^ method perform: selector andCacheOn: self.
]

{ #category : #'message handling' }
P4Object >> or: aBlock [
	self ifFalse: [ ^aBlock value ]
]

{ #category : #accessing }
P4Object >> pBasicAt: key [
	<pprimitive: #basicAt>
	<renameExport: #basicAt:>  
	self error: 'Object>>basicAt: failed. this is not an arrayed object'.
]

{ #category : #accessing }
P4Object >> pBasicAt: key put: object [
	<pprimitive: #basicAtPut>
	<renameExport: #basicAt:put:>
	self pHalt
]

{ #category : #'class hierarchy' }
P4Object >> pClass [
	<renameExport: #class>
	^ self behavior theClass
]

{ #category : #'message handling' }
P4Object >> pDoesNotUnderstand: message [
	<renameExport: #doesNotUnderstand:>
	
	'------> does not understand' print.
	self class name print.
	message selector print.
	
	(message arguments size > 0) 
		ifTrue: [ 
			' ------>  arguments: ' print.
			message arguments do: [ :arg |
				arg print ]].
	'<------' print.
	"self pHalt."
]

{ #category : #testing }
P4Object >> pHalt [
	<preventExport>
]

{ #category : #hash }
P4Object >> pHash [
	^ self hash
]

{ #category : #accessing }
P4Object >> pIdentityHash [
	<pprimitive: #identityHash>
	<renameExport: #identityHash>
	self pHalt.  
]

{ #category : #'initialize-release' }
P4Object >> pInitialize [
	<renameExport: #initialize>
]

{ #category : #testing }
P4Object >> pInspect [ 
	self printObj
]

{ #category : #'message handling' }
P4Object >> pLookupSelector: aSelector [
	^ self lookupSelector: aSelector
]

{ #category : #'message performing' }
P4Object >> perform: selector with: args [
	| behavior method |
	behavior := self behavior.
	method := (behavior lookup: selector for: self).
	^ method perform: selector on: self with: args.
]

{ #category : #accessing }
P4Object >> print [ 
	'a ' print.
	self class name print.
]

{ #category : #spec }
P4Object >> printObj [
	<pprimitive: #'print_object'>
	self pHalt.
]

{ #category : #accessing }
P4Object >> psize [
	<pprimitive: #size>
	<renameExport: #size>  
	self pHalt.
]

{ #category : #spec }
P4Object >> shouldBe: sth [
	(self = sth) ifFalse: [ self expectationFail: self expected: sth ]  
]

{ #category : #testing }
P4Object >> shouldBeTrue [
	self expectationFail: self expected: true  
]

{ #category : #'message handling' }
P4Object >> shouldNotCall [
	self error: 'my subclass should have overwritten this'
]

{ #category : #accessing }
P4Object >> size [
	<preventExport>
	^super size
]

{ #category : #accessing }
P4Object >> yourself [
	^ self
]
