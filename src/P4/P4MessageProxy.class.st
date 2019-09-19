Class {
	#name : #P4MessageProxy,
	#superclass : #P4Object,
	#type : #variable,
	#instVars : [
		'proxiedMethod',
		'counter'
	],
	#category : #'P4-Test'
}

{ #category : #'as yet unclassified' }
P4MessageProxy class >> for: aMethod [
	^ self new proxiedMethod: aMethod; yourself
]

{ #category : #accessing }
P4MessageProxy >> counter [
	^ counter
]

{ #category : #accessing }
P4MessageProxy >> counter: anObject [
	counter := anObject
]

{ #category : #accessing }
P4MessageProxy >> initialize [ 
	counter := 0
]

{ #category : #accessing }
P4MessageProxy >> perform: selector on: receiver with: args [
	counter := counter + 1.
	^ proxiedMethod perform: selector on: receiver with: args
]

{ #category : #accessing }
P4MessageProxy >> proxiedMethod [
	^ proxiedMethod
]

{ #category : #accessing }
P4MessageProxy >> proxiedMethod: anObject [
	proxiedMethod := anObject
]
