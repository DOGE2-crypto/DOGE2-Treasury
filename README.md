# DOGE2-Treasury
DOGE2 treasury wallet. Guarded by timelock.

Timelock contract that guards the treasury for DOGE2.
A smart contract that functions as a wallet.

This is where DOGE2 treasury funds will be deposited to.

There is a safeguard to provide a margin of safety for all holders. The tokens can not be immediately withdrawn from the smart contract. A delay(number of blocks) must pass between the time when withdrawal is requested and when the tokens can actually leave the smart contract wallet.
The delay will be set to roughly 24hours, but this can be changed later on by simply deploying new contract.
