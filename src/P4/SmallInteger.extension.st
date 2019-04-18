Extension { #name : #SmallInteger }

{ #category : #'*P4' }
SmallInteger >> asTaggedInteger [ 
	^ 1+(self bitShift: 1)
]

{ #category : #'*P4' }
SmallInteger >> pHash [ 
	^ self
]
