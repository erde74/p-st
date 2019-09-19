Class {
	#name : #P4IdentityDictBucket,
	#superclass : #P4DictBucket,
	#type : #variable,
	#category : #'P4-Kernel-Collection'
}

{ #category : #'as yet unclassified' }
P4IdentityDictBucket class >> typeHints [ 
	<preventExport>
	^ super typeHints addAll:
	{
		#self-> #'Kernel.Collection.IdentityDictBucket'
	} asDictionary
]

{ #category : #accessing }
P4IdentityDictBucket >> assign: key to: value [
	1 to: bucketSize by: 2 do: [ :index |
		(self at: index) == key
			ifTrue: [ self at: index + 1 put: value. ^true ]].
	^ false
]

{ #category : #accessing }
P4IdentityDictBucket >> at: aKey ifAbsent: aBlock [
	<groundTypes>
	1 to: bucketSize by: 2 do: [ :index | 
		(self at: index) == aKey ifTrue: [ ^ self at: 1 + index ]].
	^ aBlock value
]

{ #category : #testing }
P4IdentityDictBucket >> includesKey: aKey [
	1 to: bucketSize by: 2 do: [ :index | 
		(self at: index) == aKey ifTrue: [ ^ true ]].
	^ false
]

{ #category : #removing }
P4IdentityDictBucket >> remove: aKey ifAbsent: aBlock [
	| value |
	1 to: bucketSize by: 2 do: [ :index | 
		(self at: index) == aKey
			ifTrue: [
				value := self at: index + 1.
				self removeAt: index.
				^ value ]].
	^ aBlock value
]
