
import React from 'react';

import Card from './Card';

const CardExchanges = () => (
  <Card title="取引所">
    <a href="https://www.cryptopia.co.nz/Exchange/?market=PHR_BTC" target="_blank">Cryptopia</a><br />
    <a href="https://www.idax.mn/#/exchange?pairname=PHR_BTC" target="_blank">IDAX</a><br />
    <a href="https://wallet.crypto-bridge.org/market/BRIDGE.PHR_BRIDGE.BTC" target="_blank">CryptoBridge</a><br />
    <a href="https://bitebtc.com/trade/phr_btc" target="_blank">BiteBTC</a><br />
    <a href="https://coinswitch.co/app/exchange?from=btc&to=phr" target="_blank">CoinSwitch</a><br />
    <a href="https://phore.io/buy-phore/" target="_blank">CryptoWolf</a><br />
  </Card>
);

export default CardExchanges;
