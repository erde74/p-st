Extension { #name : #ByteSymbol }

{ #category : #'*P4' }
ByteSymbol >> dumpLocalOn: binaryOut [
	^ binaryOut symbol: self  
]

{ #category : #'*P4' }
ByteSymbol >> pExportedName [ 
	^('s_', self) asSymbol
]
