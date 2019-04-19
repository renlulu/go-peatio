-- we don't know how to generate schema peatio_development (class Schema) :(
create table if not exists accounts
(
	id int auto_increment
		primary key,
	member_id int not null,
	currency_id varchar(10) not null,
	balance decimal(32,16) default '0.0000000000000000' not null,
	locked decimal(32,16) default '0.0000000000000000' not null,
	created_at datetime not null,
	updated_at datetime not null,
	constraint index_accounts_on_currency_id_and_member_id
		unique (currency_id, member_id)
)
;

create index index_accounts_on_member_id
	on accounts (member_id)
;

create table if not exists ar_internal_metadata
(
	`key` varchar(255) not null
		primary key,
	value varchar(255) null,
	created_at datetime not null,
	updated_at datetime not null
)
;

create table if not exists assets
(
	id int auto_increment
		primary key,
	code int not null,
	currency_id varchar(255) not null,
	reference_type varchar(255) null,
	reference_id int null,
	debit decimal(32,16) default '0.0000000000000000' not null,
	credit decimal(32,16) default '0.0000000000000000' not null,
	created_at datetime not null,
	updated_at datetime not null
)
;

create index index_assets_on_currency_id
	on assets (currency_id)
;

create index index_assets_on_reference_type_and_reference_id
	on assets (reference_type, reference_id)
;

create table if not exists blockchains
(
	id int auto_increment
		primary key,
	`key` varchar(255) not null,
	name varchar(255) null,
	client varchar(255) not null,
	server varchar(255) null,
	height int not null,
	explorer_address varchar(255) null,
	explorer_transaction varchar(255) null,
	min_confirmations int default '6' not null,
	status varchar(255) not null,
	created_at datetime not null,
	updated_at datetime not null,
	constraint index_blockchains_on_key
		unique (`key`)
)
;

create index index_blockchains_on_status
	on blockchains (status)
;

create table if not exists currencies
(
	id varchar(10) not null
		primary key,
	name varchar(255) null,
	blockchain_key varchar(32) null,
	symbol varchar(1) not null,
	type varchar(30) default 'coin' not null,
	deposit_fee decimal(32,16) default '0.0000000000000000' not null,
	min_deposit_amount decimal(32,16) default '0.0000000000000000' not null,
	min_collection_amount decimal(32,16) default '0.0000000000000000' not null,
	withdraw_fee decimal(32,16) default '0.0000000000000000' not null,
	min_withdraw_amount decimal(32,16) default '0.0000000000000000' not null,
	withdraw_limit_24h decimal(32,16) default '0.0000000000000000' not null,
	withdraw_limit_72h decimal(32,16) default '0.0000000000000000' not null,
	position int default '0' not null,
	options varchar(1000) default '{}' null,
	enabled tinyint(1) default '1' not null,
	base_factor bigint default '1' not null,
	`precision` tinyint default '8' not null,
	icon_url varchar(255) null,
	created_at datetime not null,
	updated_at datetime not null
)
;

create index index_currencies_on_enabled
	on currencies (enabled)
;

create index index_currencies_on_enabled_and_code
	on currencies (enabled)
;

create index index_currencies_on_position
	on currencies (position)
;

create table if not exists deposits
(
	id int auto_increment
		primary key,
	member_id int not null,
	currency_id varchar(10) not null,
	amount decimal(32,16) not null,
	fee decimal(32,16) not null,
	address varchar(95) null,
	txid varchar(128) collate latin1_bin null,
	txout int null,
	aasm_state varchar(30) not null,
	block_number int null,
	type varchar(30) not null,
	tid varchar(64) collate latin1_bin not null,
	created_at datetime not null,
	updated_at datetime not null,
	completed_at datetime null,
	constraint index_deposits_on_currency_id_and_txid_and_txout
		unique (currency_id, txid, txout)
)
;

create index index_deposits_on_aasm_state_and_member_id_and_currency_id
	on deposits (aasm_state, member_id, currency_id)
;

create index index_deposits_on_currency_id
	on deposits (currency_id)
;

create index index_deposits_on_member_id_and_txid
	on deposits (member_id, txid)
;

create index index_deposits_on_tid
	on deposits (tid)
;

create index index_deposits_on_type
	on deposits (type)
;

create table if not exists expenses
(
	id int auto_increment
		primary key,
	code int not null,
	currency_id varchar(255) not null,
	reference_type varchar(255) null,
	reference_id int null,
	debit decimal(32,16) default '0.0000000000000000' not null,
	credit decimal(32,16) default '0.0000000000000000' not null,
	created_at datetime not null,
	updated_at datetime not null
)
;

create index index_expenses_on_currency_id
	on expenses (currency_id)
;

create index index_expenses_on_reference_type_and_reference_id
	on expenses (reference_type, reference_id)
;

create table if not exists liabilities
(
	id int auto_increment
		primary key,
	code int not null,
	currency_id varchar(255) not null,
	member_id int null,
	reference_type varchar(255) null,
	reference_id int null,
	debit decimal(32,16) default '0.0000000000000000' not null,
	credit decimal(32,16) default '0.0000000000000000' not null,
	created_at datetime not null,
	updated_at datetime not null
)
;

create index index_liabilities_on_currency_id
	on liabilities (currency_id)
;

create index index_liabilities_on_member_id
	on liabilities (member_id)
;

create index index_liabilities_on_reference_type_and_reference_id
	on liabilities (reference_type, reference_id)
;

create table if not exists markets
(
	id varchar(20) not null
		primary key,
	ask_unit varchar(10) not null,
	bid_unit varchar(10) not null,
	ask_fee decimal(17,16) default '0.0000000000000000' not null,
	bid_fee decimal(17,16) default '0.0000000000000000' not null,
	min_ask_price decimal(32,16) default '0.0000000000000000' not null,
	max_bid_price decimal(32,16) default '0.0000000000000000' not null,
	min_ask_amount decimal(32,16) default '0.0000000000000000' not null,
	min_bid_amount decimal(32,16) default '0.0000000000000000' not null,
	ask_precision tinyint default '8' not null,
	bid_precision tinyint default '8' not null,
	position int default '0' not null,
	enabled tinyint(1) default '1' not null,
	created_at datetime not null,
	updated_at datetime not null,
	constraint index_markets_on_ask_unit_and_bid_unit
		unique (ask_unit, bid_unit)
)
;

create index index_markets_on_ask_unit
	on markets (ask_unit)
;

create index index_markets_on_bid_unit
	on markets (bid_unit)
;

create index index_markets_on_enabled
	on markets (enabled)
;

create index index_markets_on_position
	on markets (position)
;

create table if not exists members
(
	id int auto_increment
		primary key,
	uid varchar(12) not null,
	email varchar(255) not null,
	level int not null,
	role varchar(16) not null,
	state varchar(16) not null,
	created_at datetime not null,
	updated_at datetime not null,
	constraint index_members_on_email
		unique (email)
)
;

create table if not exists operations_accounts
(
	id int auto_increment
		primary key,
	code mediumint not null,
	type varchar(10) not null,
	kind varchar(30) not null,
	currency_type varchar(10) not null,
	description varchar(100) null,
	scope varchar(10) not null,
	created_at datetime not null,
	updated_at datetime not null,
	constraint index_operations_accounts_on_code
		unique (code),
	constraint index_operations_accounts_on_type_and_kind_and_currency_type
		unique (type, kind, currency_type)
)
;

create index index_operations_accounts_on_currency_type
	on operations_accounts (currency_type)
;

create index index_operations_accounts_on_scope
	on operations_accounts (scope)
;

create index index_operations_accounts_on_type
	on operations_accounts (type)
;

create table if not exists orders
(
	id int auto_increment
		primary key,
	bid varchar(10) not null,
	ask varchar(10) not null,
	market_id varchar(20) not null,
	price decimal(32,16) null,
	volume decimal(32,16) not null,
	origin_volume decimal(32,16) not null,
	fee decimal(32,16) default '0.0000000000000000' not null,
	state int not null,
	type varchar(8) not null,
	member_id int not null,
	ord_type varchar(30) not null,
	locked decimal(32,16) default '0.0000000000000000' not null,
	origin_locked decimal(32,16) default '0.0000000000000000' not null,
	funds_received decimal(32,16) default '0.0000000000000000' null,
	trades_count int default '0' not null,
	created_at datetime not null,
	updated_at datetime not null
)
;

create index index_orders_on_member_id
	on orders (member_id)
;

create index index_orders_on_state
	on orders (state)
;

create index index_orders_on_type_and_market_id
	on orders (type, market_id)
;

create index index_orders_on_type_and_member_id
	on orders (type, member_id)
;

create index index_orders_on_type_and_state_and_market_id
	on orders (type, state, market_id)
;

create index index_orders_on_type_and_state_and_member_id
	on orders (type, state, member_id)
;

create index index_orders_on_updated_at
	on orders (updated_at)
;

create table if not exists payment_addresses
(
	id int auto_increment
		primary key,
	currency_id varchar(10) not null,
	account_id int not null,
	address varchar(95) null,
	secret varchar(128) null,
	details varchar(1024) default '{}' not null,
	created_at datetime not null,
	updated_at datetime not null,
	constraint index_payment_addresses_on_currency_id_and_address
		unique (currency_id, address)
)
;

create table if not exists revenues
(
	id int auto_increment
		primary key,
	code int not null,
	currency_id varchar(255) not null,
	member_id int null,
	reference_type varchar(255) null,
	reference_id int null,
	debit decimal(32,16) default '0.0000000000000000' not null,
	credit decimal(32,16) default '0.0000000000000000' not null,
	created_at datetime not null,
	updated_at datetime not null
)
;

create index index_revenues_on_currency_id
	on revenues (currency_id)
;

create index index_revenues_on_reference_type_and_reference_id
	on revenues (reference_type, reference_id)
;

create table if not exists schema_migrations
(
	version varchar(255) not null
		primary key
)
;

create table if not exists trades
(
	id int auto_increment
		primary key,
	price decimal(32,16) not null,
	volume decimal(32,16) not null,
	ask_id int not null,
	bid_id int not null,
	trend int not null,
	market_id varchar(20) not null,
	ask_member_id int not null,
	bid_member_id int not null,
	funds decimal(32,16) not null,
	created_at datetime not null,
	updated_at datetime not null
)
;

create index index_trades_on_ask_id
	on trades (ask_id)
;

create index index_trades_on_ask_member_id_and_bid_member_id
	on trades (ask_member_id, bid_member_id)
;

create index index_trades_on_bid_id
	on trades (bid_id)
;

create index index_trades_on_created_at
	on trades (created_at)
;

create index index_trades_on_market_id_and_created_at
	on trades (market_id, created_at)
;

create table if not exists transfers
(
	id int auto_increment
		primary key,
	`key` int not null,
	kind varchar(30) not null,
	`desc` varchar(255) default '' null,
	created_at datetime not null,
	updated_at datetime not null,
	constraint index_transfers_on_key
		unique (`key`)
)
;

create index index_transfers_on_kind
	on transfers (kind)
;

create table if not exists wallets
(
	id int auto_increment
		primary key,
	blockchain_key varchar(32) null,
	currency_id varchar(10) null,
	name varchar(64) null,
	address varchar(255) not null,
	kind int not null,
	nsig int null,
	gateway varchar(20) default '' not null,
	settings varchar(1000) default '{}' not null,
	max_balance decimal(32,16) default '0.0000000000000000' not null,
	parent int null,
	status varchar(32) null,
	created_at datetime not null,
	updated_at datetime not null
)
;

create index index_wallets_on_currency_id
	on wallets (currency_id)
;

create index index_wallets_on_kind
	on wallets (kind)
;

create index index_wallets_on_kind_and_currency_id_and_status
	on wallets (kind, currency_id, status)
;

create index index_wallets_on_status
	on wallets (status)
;

create table if not exists withdraws
(
	id int auto_increment
		primary key,
	account_id int not null,
	member_id int not null,
	currency_id varchar(10) not null,
	amount decimal(32,16) not null,
	fee decimal(32,16) not null,
	txid varchar(128) collate latin1_bin null,
	aasm_state varchar(30) not null,
	block_number int null,
	sum decimal(32,16) not null,
	type varchar(30) not null,
	tid varchar(64) collate latin1_bin not null,
	rid varchar(95) not null,
	note varchar(256) null,
	created_at datetime not null,
	updated_at datetime not null,
	completed_at datetime null,
	constraint index_withdraws_on_currency_id_and_txid
		unique (currency_id, txid)
)
;

create index index_withdraws_on_aasm_state
	on withdraws (aasm_state)
;

create index index_withdraws_on_account_id
	on withdraws (account_id)
;

create index index_withdraws_on_currency_id
	on withdraws (currency_id)
;

create index index_withdraws_on_member_id
	on withdraws (member_id)
;

create index index_withdraws_on_tid
	on withdraws (tid)
;

create index index_withdraws_on_type
	on withdraws (type)
;

