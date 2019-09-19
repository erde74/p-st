Class {
	#name : #P4PharoBehavior,
	#superclass : #Object,
	#instVars : [
		'pharoInstance',
		'p4instance'
	],
	#category : #'P4-PharoBridge'
}

{ #category : #accessing }
P4PharoBehavior >> asPClass [
	^ self
]

{ #category : #accessing }
P4PharoBehavior >> dumpGlobalOn: bo [
	^ self dumpOn: bo
]

{ #category : #accessing }
P4PharoBehavior >> dumpLocalOn: bo [
	^ bo postpone: self
]

{ #category : #accessing }
P4PharoBehavior >> earlySelectorAddress: addr [
	^ pharoInstance earlySelectorAddress: addr  
]

{ #category : #accessing }
P4PharoBehavior >> inPharo [
	<preventExport>
	^ pharoInstance 
]

{ #category : #accessing }
P4PharoBehavior >> inPharo: anObject [
	<preventExport>
	pharoInstance := anObject.
	p4instance instanceHeader: anObject pInstanceHeader
]

{ #category : #accessing }
P4PharoBehavior >> inPinocchio [
	<preventExport>
	^ p4instance 
]

{ #category : #accessing }
P4PharoBehavior >> installMethod: method [
	<preventExport>
	p4instance installMethod: method
]

{ #category : #accessing }
P4PharoBehavior >> lookupSelector: selector [
	<preventExport>
	^ pharoInstance lookupSelector: selector
]

{ #category : #accessing }
P4PharoBehavior >> pExportedName [
	^ pharoInstance pExportedName ifNil: [ p4instance pExportedName ]
	
]

{ #category : #accessing }
P4PharoBehavior >> pHeader [
	^ pharoInstance pHeader
]

{ #category : #accessing }
P4PharoBehavior >> pInstVarAt: i [
	^ i <= P4Object class pInstSize
		ifTrue: [ p4instance pInstVarAt: i ]
		ifFalse: [ pharoInstance instVarAt: i - P4Object class pInstSize + Class instSize ]
]

{ #category : #accessing }
P4PharoBehavior >> pLookupSelector: addr [
	^ pharoInstance pLookupSelector: addr  
]

{ #category : #accessing }
P4PharoBehavior >> pVariableAt: i [
	^ p4instance pVariableAt: i
]

{ #category : #accessing }
P4PharoBehavior >> pVariableSize [
	^ p4instance pVariableSize
]

{ #category : #accessing }
P4PharoBehavior >> printOn: stream [
	stream << p4instance name << ' (' << pharoInstance name << ')'
]

{ #category : #accessing }
P4PharoBehavior >> superclass [
	^ p4instance superclass
]

{ #category : #accessing }
P4PharoBehavior >> superclass: anObject [
	p4instance superclass: anObject
]

{ #category : #accessing }
P4PharoBehavior >> theBehavior [
	^ p4instance theBehavior
]
