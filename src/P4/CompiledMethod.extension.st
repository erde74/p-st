Extension { #name : #CompiledMethod }

{ #category : #'*P4' }
CompiledMethod >> earlySelectorAddress [
	| realSelector |
	(self pragmaAt: #globalName: ) ifNotNil: [ :pragma |
		^ pragma argumentAt: 1 ].
	
	(self pragmaAt: #renameExport: ) 
		ifNil: [ realSelector := self selector ]
		ifNotNil: [ :pragma | realSelector := pragma argumentAt: 1 ].

	^ (self pMethodClass pExportedName, '__', realSelector) asSymbol
]

{ #category : #'*P4' }
CompiledMethod >> pMethodClass [ 
	^ self methodClass asPClass
]
