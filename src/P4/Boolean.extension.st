Extension { #name : #Boolean }

{ #category : #'*P4' }
Boolean >> dumpGlobalOn: executableFormat [
	^ self dumpOn: executableFormat.
]

{ #category : #'*P4' }
Boolean >> dumpLocalOn: executableFormat [
	^ executableFormat postpone: self
]

{ #category : #'*P4' }
Boolean >> pExportedName [ 
	^ self asString asSymbol
]
