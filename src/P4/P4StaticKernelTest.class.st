Class {
	#name : #P4StaticKernelTest,
	#superclass : #P4Object,
	#type : #variable,
	#instVars : [
		'a',
		'b',
		'c',
		'd'
	],
	#category : #'P4-Test'
}

{ #category : #'as yet unclassified' }
P4StaticKernelTest class >> testc [
	^self
]

{ #category : #'as yet unclassified' }
P4StaticKernelTest class >> typeHints [ 
	<preventExport>
	^ { #self -> #'Test.StaticKernelTest' } asDictionary
]

{ #category : #test }
P4StaticKernelTest >> arrayTest [
	<typeHint: #x as: #'Kernel.Collection.Array'>  
	| x|
	x := Array basicNew: 10.
	x basicAt: 5 put: 7.
	^ x basicAt: 5.
]

{ #category : #test }
P4StaticKernelTest >> arrayTest2 [
	<typeHint: #x as: #'Kernel.Collection.Array'>  
	<typeHint: #y as: #'Kernel.Collection.Array'>  
	|x y |
	x := Array basicNew: 10.
	y := Array basicNew: 1.
	1 to: 10 do: [ :i |
		x basicAt: i put: i ].
	y basicAt: 1 put: x.
	^ y basicAt: 1.
]

{ #category : #test }
P4StaticKernelTest >> blockTest [
	| x y z|
	x := 1.
	y := x + 1.
	z := [ :v | y := x + v. ].
	z value: 2.
	^ y
]

{ #category : #test }
P4StaticKernelTest >> blockTest2 [
	<globalName: #blockTest2>
	| x |
	x := 1.
	a := 2.
	[ [ [ x ] value ] value ] value shouldBe: 1.  
	^ [ [ [ a ] value ] value ] value
]

{ #category : #test }
P4StaticKernelTest >> blockTest3 [
	| h h2 |
	h := 7.
	h2 := 2.	
	[[h+h2] value + 1]  value shouldBe: 10.
	[[[h] value ] value ] value shouldBe: 7.  
	[[[[h+h2] value ] value ] value ] value shouldBe: 9.  
	h2 := 1.
	h := 2.
	[[[[[h+h2] value ] value ] value ] value ] value shouldBe: 3.
	^ h + h2
]

{ #category : #test }
P4StaticKernelTest >> blockTest4 [
	| h |
	a := 5.
	[ a ] value shouldBe: 5.
	a := 6.
	[ a ] value shouldBe: 6.
	a := 7.
	[ [a] value + 1]  value shouldBe: 8.
	h := 1.
	[[[[[a+h] value ] value ] value ] value ] value shouldBe: 8. 
	^ a + h
]

{ #category : #test }
P4StaticKernelTest >> blockTest5 [
	[ :arg1 :arg2 :arg3 :arg4 | arg1 shouldBeTrue. arg4 shouldBe: 3 ] value: true value: false value: false value: 3.
]

{ #category : #test }
P4StaticKernelTest >> get1 [
	^1

]

{ #category : #test }
P4StaticKernelTest >> getNumber [ 
	^ 1
]

{ #category : #test }
P4StaticKernelTest >> simpleMethod [
	<globalName: #simpleMethod>
	1 + 1.
	[] value.
	^ [ self ] value
]

{ #category : #test }
P4StaticKernelTest >> testInstVar [
	a := 1.
	b := self.
	c := a + 1.
	d := #test.
]

{ #category : #test }
P4StaticKernelTest >> testStatic [
	<globalName: #testStatic>
	self get1 == 1 ifFalse: [ self pHalt ].
	self get1 == 2 ifFalse: [ '*** return values are correct' print ].

	self blockTest == 3 ifFalse: [self pHalt].
	self blockTest2 == 2 ifFalse: [self pHalt].	
	self blockTest5.
	'*** finished blocks' print.

	self blockTest3.
	self blockTest4.
	'*** finished testing remote variables' print.

	self arrayTest == 7 ifFalse: [self pHalt].
	(self arrayTest2 basicAt: 10) == 10 ifFalse: [self pHalt].
	'*** finished arrays' print.
	
	self testInstVar.
	a == 1 ifFalse: [self pHalt].
	b == self ifFalse: [self pHalt].
	c == 2 ifFalse: [self pHalt].
	d == #test ifFalse: [self pHalt].
	'*** inst vars work' print.	
	
	'*** all done ***' print.
]
