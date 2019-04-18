Class {
	#name : #P4ExamplesTest,
	#superclass : #P4Object,
	#category : #'P4-Examples'
}

{ #category : #'as yet unclassified' }
P4ExamplesTest >> messageLogTest [
	| obj log oldBehavior |
	obj := P4Dictionary new.
	log := P4MessageLog new.
	oldBehavior := obj behavior.
	'** setUp logger' print.
	obj behavior: (P4MessageLogBehavior new logger: log; wrap: oldBehavior).
	'** send some messages' print.
	obj at: 1 put: #bla.
	obj at: 2 put: #whoo.
	obj at: 1.
	'** tearDown logger' print.
	obj behavior: oldBehavior.
	'** replay' print.
	log replay.

]

{ #category : #'as yet unclassified' }
P4ExamplesTest >> prototypesTest [
	| proto1 m1 m2 proto2 proto3 |
	'*** Testing Prototypes' print.
	
	proto1 := P4Prototype new.

	m1 := P4ProbeMethod new.
	m2 := P4ProbeMethod new.
	
	m1 return: #one when: #call.
	m1 return: #one when: #call1.
	m2 return: #two when: #call.
	
	proto1 addMethod: m1 at: #call.
	proto1 addMethod: m1 at: #call1.
	
	proto2 := proto1 clone.
	proto2 addMethod: m2 at: #call.
	
	proto1 call shouldBe: #one.  
	proto1 call1 shouldBe: #one. 
	proto2 call shouldBe: #two.  
	proto2 call1 shouldBe: #one. 
	
	proto3 := proto2 clone.
	proto3 call shouldBe: #two.
	proto3 call1 shouldBe: #one.

	proto2 class.
	'*** done' print
]

{ #category : #'as yet unclassified' }
P4ExamplesTest >> run [
	self messageLogTest.
	self prototypesTest.

]
