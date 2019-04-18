Extension { #name : #Symbol }

{ #category : #'*P4' }
Symbol >> pHash [
	| hash maxInt |
	self flag: 'Not a super fast implementation; but it matches what we have in C...'.
	maxInt := (1 bitShift: 64) - 1.
	hash := 5381.
	1 to: self size do: [ :i |
		hash := (hash + ((hash bitShift: 5) bitAnd: maxInt) + (self at: i) asInteger) bitAnd: maxInt ].
	((hash bitShift: -63) bitAnd: 1) = 1 ifTrue: [ hash := hash bitShift: -1].
	^ hash
]
