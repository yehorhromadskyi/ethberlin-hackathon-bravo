module.exports = {
  // WETH
  tokenA: {
    symbol: 'WETH',
    address: "0xc778417e063141139fce010982780140aa0cd5ab",
    // Check ETH oracle
    //   https://makerdao.com/feeds/#0xc778417e063141139fce010982780140aa0cd5ab
    //   Price: 200
	//   should be not less then equivalent of 10000$
    //   10100$ = 10100/200 ETH = 50.5 
    funding: 50.5
  },
  // CWBR
  tokenB: {
    symbol: 'CWBR',
    address: "0xf30396d65fbbb29b90d8c2f8bc489bca3446d6b1",
    funding: 0 //optional, can be 0
  },
  // at some point)
  // Price: 
  //   https://www.coingecko.com/en/price_charts/project-crowbar/eth
  //   1 ETH = 500$ = 500 CWBR
  //   initial price = 500 CWBR/WETH
  // we will do 1 CWBR = 1$
  initialPrice: {
    numerator: 200,
    denominator: 1
  }
}