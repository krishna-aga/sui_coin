#[test_only]
module sui_coin::sui_coin_test;

use sui_coin::sui_coin::{Self,SUI_COIN};
use sui::test_scenario;
use sui::coin::{Self,Coin,TreasuryCap};
use std::unit_test::assert_eq;


#[test]
public fun test_init(){
        let alice = @0xA;
        let mut scenario = test_scenario::begin(alice);
        
        sui_coin::run_init(scenario.ctx());
        scenario.next_tx(alice);    
        let item = scenario.take_from_sender<Coin<SUI_COIN>>();

        // let mut treasury = scenario.take_from_sender<TreasuryCap<SUI_COIN>>();
        let coins:u64=30000000000;
        assert!(coin::value(&item) == coins, 1);
        

        scenario.return_to_sender(item);
        scenario.end();


}



