Class {
	#name : #P4PharoClass,
	#superclass : #P4PharoBehavior,
	#instVars : [
		'p4class'
	],
	#category : #'P4-PharoBridge'
}

{ #category : #accessing }
P4PharoClass >> inP4: aClass [
	p4instance := aClass
]

{ #category : #accessing }
P4PharoClass >> initialize [
	super initialize.
	p4instance := P4Class new.
	p4instance setBehavior: (P4SmalltalkBehavior for: self).  
]

{ #category : #accessing }
P4PharoClass >> metaclass: anObject [
	p4class := P4PharoMetaclass new instance: self		
]

{ #category : #accessing }
P4PharoClass >> name: aName [
	<preventExport>
	p4instance name: aName
]

{ #category : #accessing }
P4PharoClass >> pByteAt: i [ 
	self error: 'Should not happen'
]

{ #category : #accessing }
P4PharoClass >> pByteName [
	^ nil
]

{ #category : #accessing }
P4PharoClass >> pByteSize [
	^ 0
]

{ #category : #accessing }
P4PharoClass >> pInstSize [
	^ pharoInstance pInstSize
]

{ #category : #accessing }
P4PharoClass >> pIsBytes [
	^ pharoInstance pIsBytes
]

{ #category : #accessing }
P4PharoClass >> pIsVariable [ 
	^ pharoInstance pIsVariable
]

{ #category : #accessing }
P4PharoClass >> pIsVariableOrBytes [ 
	^ pharoInstance pIsVariableOrBytes 
]

{ #category : #accessing }
P4PharoClass >> pVariableSizeHeader [
	^ p4instance pVariableSizeHeader
]

{ #category : #accessing }
P4PharoClass >> package: package [
	<preventExport>
	p4instance package: package
]

{ #category : #accessing }
P4PharoClass >> pclass [
	^ p4class
]

{ #category : #accessing }
P4PharoClass >> typeCheckByteSize [ 
	^pharoInstance typeCheckByteSize
]
