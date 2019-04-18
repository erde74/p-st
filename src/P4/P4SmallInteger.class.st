Class {
	#name : #P4SmallInteger,
	#superclass : #P4Object,
	#category : #'P4-Kernel-Number'
}

{ #category : #exporting }
P4SmallInteger class >> pExportedName [ 
	^ self == P4SmallInteger
		ifTrue: [ #SmallInteger ]
		ifFalse: [ super pExportedName ]
]

{ #category : #exporting }
P4SmallInteger class >> typeCheckByteSize [
	<preventExport>
	^ 10
]

{ #category : #exporting }
P4SmallInteger class >> typeHints [ 
	<preventExport>
	^ { #self -> #'Kernel.Number.SmallInteger' } asDictionary
]

{ #category : #'as yet unclassified' }
P4SmallInteger >> * anObject [
	<pprimitive: #mult>
	self pHalt.
]

{ #category : #'as yet unclassified' }
P4SmallInteger >> + anObject [
	<pprimitive: #plus>
	self pHalt.
]

{ #category : #'as yet unclassified' }
P4SmallInteger >> - anObject [
	<pprimitive: #minus>
	self pHalt.
]

{ #category : #'as yet unclassified' }
P4SmallInteger >> // anObject [
	<pprimitive: #intDivide>
	self pHalt.
]

{ #category : #'as yet unclassified' }
P4SmallInteger >> < anObject [
	<pprimitive: #smaller>
	self pHalt.
]

{ #category : #'as yet unclassified' }
P4SmallInteger >> <= anObject [
	<pprimitive: #smallerEqual>
	self pHalt.
]

{ #category : #'as yet unclassified' }
P4SmallInteger >> > anObject [
	<pprimitive: #bigger>
	self pHalt.
]

{ #category : #'as yet unclassified' }
P4SmallInteger >> \\ anObject [
	<pprimitive: #modulo>
	self pHalt.
]

{ #category : #'as yet unclassified' }
P4SmallInteger >> bitShift: n [
	<pprimitive: #bitShift>
	self pHalt.
]

{ #category : #'as yet unclassified' }
P4SmallInteger >> hash [
	^ self 
]

{ #category : #'as yet unclassified' }
P4SmallInteger >> print [
	self printObj 
]

{ #category : #'as yet unclassified' }
P4SmallInteger >> to: end by: step do: aBlock [
	| nextValue |
	nextValue := self.
	[nextValue <= end]
		whileTrue: 
			[aBlock value: nextValue.
			nextValue := nextValue + step]
]

{ #category : #'as yet unclassified' }
P4SmallInteger >> to: end do: aBlock [
	| nextValue |
	nextValue := self.
	[nextValue <= end]
		whileTrue: 
			[aBlock value: nextValue.
			nextValue := nextValue + 1]
]
