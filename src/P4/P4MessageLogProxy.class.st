Class {
	#name : #P4MessageLogProxy,
	#superclass : #P4Object,
	#instVars : [
		'method',
		'logger'
	],
	#category : #'P4-Examples'
}

{ #category : #'as yet unclassified' }
P4MessageLogProxy class >> wrap: method logger: logger [
	^ self new method: method; logger: logger
]

{ #category : #accessing }
P4MessageLogProxy >> logger [
	^ logger
]

{ #category : #accessing }
P4MessageLogProxy >> logger: anObject [
	logger := anObject
]

{ #category : #accessing }
P4MessageLogProxy >> method [
	^ method
]

{ #category : #accessing }
P4MessageLogProxy >> method: anObject [
	method := anObject
]

{ #category : #accessing }
P4MessageLogProxy >> perform: selector on: receiver with: args [
	| message |
	message := Array new: 4.
	message
			at: 1 put: method;
			at: 2 put: selector;
			at: 3 put: receiver;
			at: 4 put: args.
	logger log: message.
	^ method perform: selector on: receiver with: args
]
