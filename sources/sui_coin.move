module sui_coin::sui_coin;

use sui::coin::{Self,TreasuryCap};
use sui::url;

public struct SUI_COIN has drop {}

#[allow(deprecated_usage)]
fun init(witness: SUI_COIN, ctx: &mut TxContext) {
    // Create the icon URL
    let icon_url = url::new_unsafe_from_bytes(b"https://cryptologos.cc/logos/sui-sui-logo.png");
    let decimals: u8 = 8;

    // Fixed multiplier for 8 decimals (10^8)
    let multiplier = 100000000; // 10^8

    // Create the currency - make treasury mutable
    let (mut treasury, metadata) = coin::create_currency(
        witness,
        decimals,
        b"MyCoin",
        b"MyCoin ON SUI",
        b"This is my first coin",
        option::some(icon_url),
        ctx,
    );

    // Mint 300 tokens (300 * 10^8 base units)
    let initial_coins = coin::mint(&mut treasury, 300 * multiplier, ctx);
    transfer::public_transfer(initial_coins, tx_context::sender(ctx));

    transfer::public_freeze_object(metadata);
    transfer::public_transfer(treasury, tx_context::sender(ctx));
}

entry fun mint(
    treasury_cap: &mut TreasuryCap<SUI_COIN>,
    amount: u64,
    recipient: address,
    ctx: &mut TxContext,
) {
    let coin = coin::mint(treasury_cap, amount, ctx);
    transfer::public_transfer(coin, recipient);
}

#[test_only]
public fun create_suicoin_instance():SUI_COIN{
SUI_COIN{}
}

#[test_only]
public fun run_init(ctx:&mut TxContext){
    init(create_suicoin_instance(), ctx)
}