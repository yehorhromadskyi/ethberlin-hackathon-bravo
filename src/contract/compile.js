const fs = require('fs');
const solc = require('solc');

var input = {
	'safe_math.sol': fs.readFileSync('./contracts/safe_math.sol', 'UTF-8'),
	'delayed_executor.sol': fs.readFileSync('./contracts/delayed_executor.sol', 'UTF-8'),
	'delayed_executor_factory.sol': fs.readFileSync('./contracts/delayed_executor_factory.sol', 'UTF-8')
}

var output = solc.compile({sources: input}, 1)
console.log(output);

for (var contractName in output.contracts)
{
	var validFileName = contractName.replace(':', '_');
	
	//console.log(output.contracts[contractName].bytecode);
	
	fs.writeFileSync('compiled/' + validFileName + '.bin', output.contracts[contractName].bytecode);
	fs.writeFileSync('compiled/' + validFileName + '.abi', output.contracts[contractName].interface);

	//console.log('Writing ' + validFileName);
}