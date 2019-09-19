Class {
	#name : #P4TACRegisterSwapper,
	#superclass : #P4TACPostCompiler,
	#instVars : [
		'helper'
	],
	#category : #'P4-TAC'
}

{ #category : #'as yet unclassified' }
P4TACRegisterSwapper >> helper: aHelper [
	helper := aHelper
]

{ #category : #'as yet unclassified' }
P4TACRegisterSwapper >> process: statement [
	statement acceptRegisterSwapper: self
]

{ #category : #'as yet unclassified' }
P4TACRegisterSwapper >> visitOperation: instruction [
	| left replacement right |
	replacement := P4ObjectStream new.
	( instruction left isDoubleAccess )
		ifTrue: [
			left := (helper intermediate).
			replacement << (instruction left variable moveTo: left).
			left := left accessAt: instruction left index ]
		ifFalse: [ left := instruction left  ].
	
	( instruction right isDoubleAccess )
		ifTrue: [
			right := helper intermediateLValue.
			replacement << (instruction right variable moveTo: right).
			right := right accessAt: instruction right index ]
		ifFalse: [ right := instruction right ].
		
	( (left isAccess or: [ left isConstant]) and: [ right isAccess or: [ right isConstant ] ] ) ifTrue: [
		replacement << (left moveTo: helper intermediate).
		left := helper intermediate].
	
	replacement isEmpty ifFalse: [
		instruction left: left; right: right.
		replacement << instruction.
		(basicBlock overridePosition: instruction)  << replacement]
]
