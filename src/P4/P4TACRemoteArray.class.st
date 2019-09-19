Class {
	#name : #P4TACRemoteArray,
	#superclass : #P4TACVariable,
	#instVars : [
		'remotes'
	],
	#category : #'P4-TAC-Values'
}

{ #category : #accessing }
P4TACRemoteArray >> add: aValue [
	| result |
	result := self accessAt: (aValue remoteIndex: remotes size). 
	remotes add: aValue.
	^ result
]

{ #category : #accessing }
P4TACRemoteArray >> canBeVolatile [ 
	"remotes are inserted after liveness analysis. 
	we therefore cannot know if there are methods called within their lifespan"
	^false
]

{ #category : #iterating }
P4TACRemoteArray >> do: aBlock [
	^ remotes do: aBlock
]

{ #category : #'initialize-release' }
P4TACRemoteArray >> initialize [
	remotes := OrderedCollection new.
	self assignedAt: 1.  
]

{ #category : #testing }
P4TACRemoteArray >> isEmpty [
	^ remotes isEmpty
]

{ #category : #accessing }
P4TACRemoteArray >> name [
	^ #'_remote_'
]

{ #category : #accessing }
P4TACRemoteArray >> size [
	^ remotes size
]
