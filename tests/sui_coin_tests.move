#[test_only]
module sui_coin::sui_coin_test;

use sui_coin::sui_coin::{Self,SUI_COIN};
use sui::test_scenario;
use sui::coin::{Self,Coin,TreasuryCap};




#[test]
public fun test_init_and_mint(){
        let alice = @0xA;
        let bob=@0xB;
        
        
        let mut scenario = test_scenario::begin(alice);
        
        
        sui_coin::run_init(scenario.ctx());
        
        
        scenario.next_tx(alice);    
        
        
        let item = scenario.take_from_sender<Coin<SUI_COIN>>();
        let mut treasury = scenario.take_from_sender<TreasuryCap<SUI_COIN>>();
        let coins:u64=30000000000;
        
        assert!(coin::value(&item) == coins, 1);
        scenario.return_to_sender(item);
        
        sui_coin::mint(&mut treasury, 20000000000, bob, scenario.ctx());
        scenario.return_to_sender(treasury);
        
        scenario.next_tx(bob);
        let item = scenario.take_from_sender<Coin<SUI_COIN>>();
        let coins:u64=20000000000;
        assert!(coin::value(&item) == coins, 1);
        scenario.return_to_sender(item);

        
        scenario.next_tx(alice);

        let treasury = scenario.take_from_sender<TreasuryCap<SUI_COIN>>();
        let supply = coin::total_supply(&treasury);
        let expected_supply: u64 = 50000000000; // 300 + 200 tokens (with 10^8 decimals)
        
        assert!(supply == expected_supply, 1);
        scenario.return_to_sender(treasury);




        scenario.end();


}



