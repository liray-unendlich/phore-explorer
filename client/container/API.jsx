
import Component from '../core/Component';
import React from 'react';

import APIdata from '../component/API/APIdata';
import APIsection from '../component/API/APIsection';
import HorizontalRule from '../component/HorizontalRule';

export default class API extends Component {

  getSections = () => {
    return APIdata.map((section, idx) => {
      return <APIsection
        key={ idx }
        heading={ section.heading }
        subHeading={ section.subHeading }
        calls={ section.calls } />
    });
  };

  render() {
    return (
      <div className="animated fadeIn">
        <br />
        <div className="api">
          <div className="api__documentation">
            <HorizontalRule className="api__documentation-title" title="API Documentation" />
            <div className="pr-4">
              <p className="api__intro">
              ユーザー/アプリケーションがウォレットを直接利用せずにネットワークから情報を取得できるAPIをブロックエクスプローラは提供しています。
              </p>
              <div className="api__call-container">
                { this.getSections() }
              </div>
            </div>
          </div>
          <div className="api__detail">
          </div>
        </div>
      </div>
    );
  };
}
