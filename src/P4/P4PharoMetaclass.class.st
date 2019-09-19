Class {
	#name : #P4PharoMetaclass,
	#superclass : #P4PharoBehavior,
	#category : #'P4-PharoBridge'
}

{ #category : #accessing }
P4PharoMetaclass >> instance: anObject [
	p4instance := P4Metaclass new
					instance: anObject;
					setBehavior: (P4SmalltalkBehavior for: self);  
					superclass: (anObject superclass
									ifNil: [ P4Class asPClass ]
									ifNotNil: [ :s | s pclass ]).
	pharoInstance := anObject inPharo class.
]

{ #category : #accessing }
P4PharoMetaclass >> pInstSize [
	^ pharoInstance pInstSize 
]

{ #category : #accessing }
P4PharoMetaclass >> pIsBytes [
	^ false
]

{ #category : #accessing }
P4PharoMetaclass >> pIsVariable [
	^ false
]

{ #category : #accessing }
P4PharoMetaclass >> pIsVariableOrBytes [ 
	^ false
]

{ #category : #accessing }
P4PharoMetaclass >> pclass [
	^ P4Metaclass asPClass
]
