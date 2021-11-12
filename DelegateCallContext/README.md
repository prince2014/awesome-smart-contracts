## The contexts in callee contract with different invoke methods(by caller)

| invoke method  | msg.sender | isContract  | StateChangeAt |
| ------------- | ------------- | ------------- | ------------- |
| EOA  | EOA  | False  | Callee  |
| call  | CallerContract  | True  | Callee  |
| callcode  | ContextMixin.msgSender(): 0x19?; msg.sender: CallerContract  | ContextMixin.msgSender():False?; msg.sender: True  | Caller  |
| delegatecall  | EOA  | False  | Caller  |
| delegateFwd (low level)  | EOA  | False  | Caller  |
