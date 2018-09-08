const fs = require('fs');
const solc = require('solc');

var input = {
	'delayed_executor': fs.readFileSync('./delayed_executor.sol', 'UTF-8')
}

var output = solc.compile({sources: input}, 1)

for (var contractName in output.contracts)
{
	var validFileName = contractName.replace(':', '_');
	
	//console.log(output.contracts[contractName].bytecode);
	
	fs.writeFileSync('bin/' + validFileName + '.bin', output.contracts[contractName].bytecode);
	fs.writeFileSync('bin/' + validFileName + '.abi', output.contracts[contractName].interface);

	//console.log('Writing ' + validFileName);
}