Class {
	#name : #P4MessageLogBehavior,
	#superclass : #P4SmalltalkBehavior,
	#instVars : [
		'logger',
		'wrap'
	],
	#category : #'P4-Examples'
}

{ #category : #accessing }
P4MessageLogBehavior >> logger [
	^ logger
]

{ #category : #accessing }
P4MessageLogBehavior >> logger: anObject [
	logger := anObject
]

{ #category : #'as yet unclassified' }
P4MessageLogBehavior >> lookup: selector for: object [
	^ P4MessageLogProxy wrap: (wrap lookup: selector for: object) logger: logger
]

{ #category : #accessing }
P4MessageLogBehavior >> wrap [
	^ wrap
]

{ #category : #accessing }
P4MessageLogBehavior >> wrap: anObject [
	wrap := anObject
]
