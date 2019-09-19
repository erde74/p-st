Class {
	#name : #P4KernelTest,
	#superclass : #P4Object,
	#type : #variable,
	#instVars : [
		'a',
		'b'
	],
	#category : #'P4-Test'
}

{ #category : #test }
P4KernelTest >> + other [
	^ true
]

{ #category : #'as yet unclassified' }
P4KernelTest >> arg1: argA [
	^ argA+1
]

{ #category : #'as yet unclassified' }
P4KernelTest >> do: block [
	block value.
	^ 1+1

]

{ #category : #'as yet unclassified' }
P4KernelTest >> do: block with: value [
	block value: value

]

{ #category : #'as yet unclassified' }
P4KernelTest >> fib2: n [
	^ (n<2) ifTrue: [ 1 ] ifFalse: [ (self fib2: (n-1)) + (self fib2: (n-2)) ]
]

{ #category : #'as yet unclassified' }
P4KernelTest >> fib: n [
	^ (n<2) ifTrue: [ 1 ] ifFalse: [ (self fib: (n-1)) + (self fib: (n-2)) ]
]

{ #category : #'as yet unclassified' }
P4KernelTest >> get1 [
	^ 1
]

{ #category : #'as yet unclassified' }
P4KernelTest >> get5 [
	^ 5
]

{ #category : #'as yet unclassified' }
P4KernelTest >> getNumber [ 
	^2
]

{ #category : #'as yet unclassified' }
P4KernelTest >> getSelf [
	^ self
]

{ #category : #'as yet unclassified' }
P4KernelTest >> nonLocalReturn [
	self do: [].
	self do: [ : val | ^val ] with: true.
	^ false
]

{ #category : #'as yet unclassified' }
P4KernelTest >> ok [
	'ok' print
]

{ #category : #'as yet unclassified' }
P4KernelTest >> readArray: p [
	(p at: 10) == #bla ifFalse: [ self pHalt ]	
]

{ #category : #'as yet unclassified' }
P4KernelTest >> test0 [
	self test1 shouldBe: self test1
]

{ #category : #'as yet unclassified' }
P4KernelTest >> test1 [
	^ self test2
]

{ #category : #'as yet unclassified' }
P4KernelTest >> test2 [
	^ 23
]

{ #category : #'as yet unclassified' }
P4KernelTest >> testArray [
	| p |
	p := P4Array new: 20.
	p at: 10 put: #bla.
	(p at: 10) shouldBe: #bla.
	self readArray: p.
	
]

{ #category : #'as yet unclassified' }
P4KernelTest >> testCustomMethodDict [
	| obj  test |
	obj := P4TestObject new.
	obj class methodDictionary: P4CustomMethodDictionary new.
	obj callSomeMethod shouldBe: 1.

	' --> calling to a custom method object' print.
	((obj callCustomMethodObject at: 1) == obj) shouldBeTrue.	
	test := (obj callCustomMethodObjectWith: 1 with: 2 with: 42).
	(test at: 3) shouldBe: 42.
	((test at: 4) == obj) shouldBeTrue.
	test pInspect.  

]

{ #category : #'as yet unclassified' }
P4KernelTest >> testDictionary [
	| dict |
	'-- create' print.
	dict := P4IdentityDictionary new.
	'-- put' print.
	dict at: #bla put: 2.
	dict at: #bla2 put: 3.
	'-- read' print.
	(dict at: #bla) shouldBe: 2.
	
	'-- grow' print.
	1 to: 110 do: [ :i |
		dict at: i put: i ].
	
	'-- read again' print.
	(dict at: 101) shouldBe: 101.

	'-- grow more' print.
	1 to: 5000 do: [ :i |
		dict at: i put: i+1 ].
	
	'-- read again' print.
	(dict at: 4801) shouldBe: 4802.
	
			
]

{ #category : #'as yet unclassified' }
P4KernelTest >> testDynamic [
	'*** dynamic tests...' print.
	self test0.
	
	'*** tests inst vars 2' print.
	self testInstVar.
	
	'*** test non boolean receivers' print.
	self testNonBooleanReceivers.

	'*** test doesNotUnderstand' print.
	self bla: #foo bla: #bar bla: 1 bla: 2 bla: 3.

	'*** with 1 argument:' print.
	(self arg1: 1) shouldBe: 2.  
	
	'*** fib' print.
	(self fib: 5) shouldBe: 8.
		
	'*** test inlinecaching... this should not take more than 1s:' print.
	(self fib: 34) == 9227465 ifFalse: [self pHalt].

	'*** testing invoke with a custom methodDictionary' print.
	self testCustomMethodDict.
	
	'*** testing message proxy' print.
	self testMessageProxy.

	'*** testing fallbacks for inlined methods' print.
	self testInlineFallback.

	'*** forcing an inline cache miss' print.
	a := 1.
	a + 1.
	a := self.
	(a + 1) shouldBeTrue.
	
	'*** test if grounded Types work' print.
	self testGroundedTypes.
	
	'*** overriding does not undestand' print.
	P4DoesUnderstand new blablabla selector shouldBe: #blablabla.

	'*** testing lookup of SmallInteger methods' print.
	(self get1 + 2) shouldBe: 3.  
	(self get5 \\ 2) shouldBe: 1.  
	
	'*** testing array' print.
	self testArray.

	'*** testing nonlocal return' print.
	self nonLocalReturn shouldBeTrue.
	
	'*** testing dictionary' print.
	self testDictionary.
	
	'*** run the examples' print.
	P4ExamplesTest new run.
	
	'*** done' print.
	
	^ P4Object new.
	
]

{ #category : #'as yet unclassified' }
P4KernelTest >> testGroundedTypes [
	<groundTypes>
	a := 1.
	a + 1.
	a := self.
	(a + 1) shouldBeTrue.
]

{ #category : #'as yet unclassified' }
P4KernelTest >> testGroundedTypes2 [
	<groundTypes>
	<typeHint: #var as: #'Test.StaticKernelTest'>
	| var |
	var := self.
	(var getNumber) shouldBe: 2.
]

{ #category : #'as yet unclassified' }
P4KernelTest >> testInlineFallback [
	(self to: 1 by: 1 do: [])  shouldBeTrue.
	self value shouldBeTrue.
	(self value: false value: true) shouldBeTrue.
]

{ #category : #'as yet unclassified' }
P4KernelTest >> testInstVar [
	[ a := #bla ] value.
	a shouldBe: #bla.
	self do: [ b := 1 ].
	b shouldBe: 1.
	a shouldBe: #bla.
]

{ #category : #'as yet unclassified' }
P4KernelTest >> testMessageProxy [
	| obj proxy |
	proxy := P4MessageProxy for: (P4KernelTest methodDictionary at: #fib2:).
	P4KernelTest methodDictionary at: #fib2: put: proxy.
	proxy counter shouldBe: 0.
	(self fib2: 3) shouldBe: 3.
	proxy counter shouldBe: 5.
	
]

{ #category : #'as yet unclassified' }
P4KernelTest >> testNonBooleanReceivers [
	| v test |
	test := false.
	v := 'test'.
	v ifFalse: [ self pHalt ].
	v ifTrue: [ test := true ].
	test ifFalse: [ self pHalt ].
	v ifTrue: [  ] ifFalse: [ self pHalt ].
		
	test := false.
	v := nil.
	v ifTrue: [ self pHalt ].
	v ifFalse: [ test := true ].
	test ifFalse: [ self pHalt ].
	v ifTrue: [ self pHalt ] ifFalse: [ 'ok' print ].
]

{ #category : #'as yet unclassified' }
P4KernelTest >> to: aha by: ogo do: iga [
	^ true
]

{ #category : #'as yet unclassified' }
P4KernelTest >> value [
	^true
]

{ #category : #'as yet unclassified' }
P4KernelTest >> value: arg1 value: arg2 [
	^arg2
]
