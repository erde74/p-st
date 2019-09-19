Extension { #name : #RBVariableNode }

{ #category : #'*P4' }
RBVariableNode >> isDynamic [
	^ false
]

{ #category : #'*P4' }
RBVariableNode >> isSuper [
	^ self name = 'super'
]
