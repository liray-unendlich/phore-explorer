
import Actions from '../core/Actions';
import Component from '../core/Component';
import { connect } from 'react-redux';
import { dateFormat } from '../../lib/date';
import { Link } from 'react-router-dom';
import moment from 'moment';
import PropTypes from 'prop-types';
import React from 'react';
import sortBy from 'lodash/sortBy';

import HorizontalRule from '../component/HorizontalRule';
import Pagination from '../component/Pagination';
import Table from '../component/Table';
import Select from '../component/Select';

import { PAGINATION_PAGE_SIZE } from '../constants';

class Proposal extends Component {
  static propTypes = {
    getPRs: PropTypes.func.isRequired
  };

  constructor(props) {
    super(props);
    this.debounce = null;
    this.state = {
      cols: [
        { key: 'name', title: 'Name' },
        { key: 'url', title: 'URL' },
        { key: 'address', title: 'Address' },
        { key: 'total_amount', title: 'Total' },
        { key: 'monthly_amount', title: 'Monthly' },
        { key: 'end_height', title: 'End block' },
      ],
      error: null,
      loading: true,
      prs: [] ,
      pages: 0,
      page: 1,
      size: 10
    };
  };

  componentDidMount() {
    this.getPRs();
  };

  componentWillUnmount() {
    if (this.debounce) {
      clearTimeout(this.debounce);
      this.debounce = null;
    }
  };

  getPRs = () => {
    this.setState({ loading: true }, () => {
      if (this.debounce) {
        clearTimeout(this.debounce);
      }

      this.debounce = setTimeout(() => {
        this.props
          .getPRs({
            limit: this.state.size,
            skip: (this.state.page - 1) * this.state.size
          })
          .then(({ prs, pages }) => {
            if (this.debounce) {
              this.setState({ prs, pages, loading: false });
            }
          })
          .catch(error => this.setState({ error, loading: false }));
      }, 800);
    });
  };

  handlePage = page => this.setState({ page }, this.getPRs);

  handleSize = size => this.setState({ size, page: 1 }, this.getPRs);

  render() {
    if (!!this.state.error) {
      return this.renderError(this.state.error);
    } else if (this.state.loading) {
      return this.renderLoading();
    }
    const selectOptions = PAGINATION_PAGE_SIZE;

    const select = (
      <Select
        onChange={ value => this.handleSize(value) }
        selectedValue={ this.state.size }
        options={ selectOptions } />
    );

    return (
      <div>
        <HorizontalRule
          select={ select }
          title="Proposals" />
        <Table
          cols={ this.state.cols }
          data={ sortBy(this.state.prs.map((pr) => {
            return {
              ...pr,
              url: (
                <a href={pr.url} target="_blank">
                  {`${ pr.url.substr(0, 20) }...` }
                </a>
              ),
              address: (
                <Link to={ `/address/${ pr.address }` }>
                  { `${ pr.address.substr(0, 20) }...` }
                </Link>
              )
            };
          }), ['end_height'])} />
        <Pagination
          current={ this.state.page }
          className="float-right"
          onPage={ this.handlePage }
          total={ this.state.pages } />
        <div className="clearfix" />
      </div>
    );
  };
}

const mapDispatch = dispatch => ({
  getPRs: query => Actions.getPRs(query)
});

export default connect(null, mapDispatch)(Proposal);
