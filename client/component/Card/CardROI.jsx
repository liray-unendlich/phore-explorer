
import blockchain from '../../../lib/blockchain';
import numeral from 'numeral';
import PropTypes from 'prop-types';
import React from 'react';

import Card from './Card';

const CardROI = ({ coin, supply }) => {
  const mncoins = blockchain.mncoins;
  const mns = coin.mnsOff + coin.mnsOn;
  const subsidy = blockchain.getMNSubsidy(coin.blocks, mns, coin.supply);
  const roi = blockchain.getROI(subsidy, coin.mnsOn);

  return (
    <Card>
      <div className="mb-3">
        <div className="h3">
          { coin.mnsOn } / { mns }
        </div>
        <div className="h5">
          稼働中/全体 マスターノード
        </div>
      </div>
      <div className="mb-3">
        <div className="h3">
          { numeral(roi).format('0,0.0000') }%
        </div>
        <div className="h5">
          概算年利率
        </div>
      </div>
      <div className="mb-3">
        <div className="h3">
          { numeral(supply ? supply.t : 0.0).format('0,0.0000') } PHR
        </div>
        <div className="h5">
          発行枚数 (全体)
        </div>
      </div>
      <div className="mb-3">
        <div className="h3">
          { numeral(supply ? supply.c - (mns * mncoins) : 0.0).format('0,0.0000') } PHR
        </div>
        <div className="h5">
          流通枚数
        </div>
      </div>
      <div className="mb-3">
        <div className="h3">
          { numeral(coin.supply * coin.btc).format('0,0.0000') } BTC
        </div>
        <div className="h5">
          BTC建ての市場規模
        </div>
      </div>
      <div className="mb-3">
        <div className="h3">
          { numeral(coin.cap).format('0,0.00') } JPY
        </div>
        <div className="h5">
          JPY建ての市場規模
        </div>
      </div>
      <div className="mb-3">
        <div className="h3">
          { numeral(mns * mncoins).format('0,0.0000') } PHR
        </div>
        <div className="h5">
          ロックされている枚数
        </div>
      </div>
      <div className="mb-3">
        <div className="h3">
          { numeral(mncoins * coin.btc).format('0,0.0000') } BTC / { numeral(mncoins * coin.usd).format('0,0.00') }JPY
        </div>
        <div className="h5">
          マスターノードの価値
        </div>
      </div>
    </Card>
  );
};

CardROI.propTypes = {
  coin: PropTypes.object.isRequired,
  supply: PropTypes.object.isRequired
};

export default CardROI;
