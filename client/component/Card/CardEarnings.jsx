
import blockchain from '../../../lib/blockchain';
import numeral from 'numeral';
import PropTypes from 'prop-types';
import React from 'react';

import Card from './Card';

const CardEarnings = ({ coin }) => {
  const subsidy = blockchain.getMNSubsidy(coin.blocks, coin.mnsOn, coin.supply);
  const day = blockchain.getMNBlocksPerDay(coin.mnsOn) * subsidy;
  const week = blockchain.getMNBlocksPerWeek(coin.mnsOn) * subsidy;
  const month = blockchain.getMNBlocksPerMonth(coin.mnsOn) * subsidy;
  const year = blockchain.getMNBlocksPerYear(coin.mnsOn) * subsidy;

  const nbtc = v => numeral(v).format('0,0.0000');
  const nusd = v => numeral(v).format('0,0.00');

  return (
    <Card title="推定報酬 (PHR/BTC/JPY)">
      <div className="row">
        <div className="col-sm-12 col-md-3">
          日ごと
        </div>
        <div className="col-sm-12 col-md-9">
          { nbtc(day) } PHR / { nbtc(day * coin.btc) } BTC / { nusd(day * coin.usd) } JPY
        </div>
      </div>
      <div className="row">
        <div className="col-sm-12 col-md-3">
          週ごと
        </div>
        <div className="col-sm-12 col-md-9">
          { nbtc(week) } PHR / { nbtc(week * coin.btc) } BTC / { nusd(week * coin.usd) } JPY
        </div>
      </div>
      <div className="row">
        <div className="col-sm-12 col-md-3">
          月ごと
        </div>
        <div className="col-sm-12 col-md-9">
          { nbtc(month) } PHR / { nbtc(month * coin.btc) } BTC / { nusd(month * coin.usd) } JPY
        </div>
      </div>
      <div className="row">
        <div className="col-sm-12 col-md-3">
          年ごと
        </div>
        <div className="col-sm-12 col-md-9">
          { nbtc(year) } PHR / { nbtc(year * coin.btc) } BTC / { nusd(year * coin.usd) } JPY
        </div>
      </div>
      <div className="row">
        <div className="col">
          <small className="u--text-gray">
            * 現在のブロック報酬・マスターノード数から見積もられた数字です。
          </small>
        </div>
      </div>
    </Card>
  );
};

CardEarnings.propTypes = {
  coin: PropTypes.object.isRequired
};

export default CardEarnings;
