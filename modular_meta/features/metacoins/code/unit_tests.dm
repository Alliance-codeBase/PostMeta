#if defined(UNIT_TESTS) || defined(SPACEMAN_DMM)

/datum/metacoins_controller/refund_recorder
	var/list/refunded_amounts = list()

/datum/metacoins_controller/refund_recorder/add_metacoins(target_ckey, amount)
	refunded_amounts += amount
	return TRUE

/datum/metacoin_shop_controller/refund_recorder
	var/datum/metacoins_controller/refund_recorder/recorder

/datum/metacoin_shop_controller/refund_recorder/New()
	. = ..()
	recorder = new
	wallet = recorder

/datum/metacoin_shop_controller/refund_recorder/Destroy()
	QDEL_NULL(recorder)
	return ..()

/datum/unit_test/metacoin_round_end_refunds_undelivered

/datum/unit_test/metacoin_round_end_refunds_undelivered/Run()
	var/datum/metacoin_shop_controller/refund_recorder/shop = allocate(/datum/metacoin_shop_controller/refund_recorder)
	var/datum/metacoinshop/listing/portable_suit = shop.preround_catalog["portable_suit"]
	var/list/pending_items = shop.pending_items_for("undelivered_buyer")
	pending_items["portable_suit"] = null
	shop.on_round_end()
	if(length(shop.recorder.refunded_amounts) != 1 || shop.recorder.refunded_amounts[1] != portable_suit.price)
		TEST_FAIL("Expected one refund of [portable_suit.price] for an undelivered purchase, got [json_encode(shop.recorder.refunded_amounts)]")

#endif
