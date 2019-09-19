Class {
	#name : #P4ExportedReference,
	#superclass : #P4Object,
	#instVars : [
		'target',
		'offset'
	],
	#category : #'P4-Exec'
}

{ #category : #accessing }
P4ExportedReference >> addend [
	^ 0
]

{ #category : #accessing }
P4ExportedReference >> offset [
	^ offset
]

{ #category : #accessing }
P4ExportedReference >> offset: anObject [
	offset := anObject
]

{ #category : #accessing }
P4ExportedReference >> target [
	^target 
]

{ #category : #accessing }
P4ExportedReference >> target: aTarget [
	self haltIf: (aTarget isKindOf: P4ExportedReference).
	target := aTarget
]
